/* A utility for jumping to local project directories.
 *
 * Projects live in ~/projects/<owner>/<name>. Given a keyword, print the
 * absolute path of the matching project, prompting for a choice when more
 * than one project matches. */

#define _POSIX_C_SOURCE 200809L

#include <dirent.h>
#include <errno.h>
#include <pwd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <termios.h>
#include <unistd.h>

#define VERSION "0.0.1.0"

/* The letters offered when several projects match, in home row order. Also
 * caps the number of choices that can be displayed. */
#define LETTERS "aoeuhtns"

static const char *usage =
  "Usage: project-jumper [-v|--version] KEYWORD\n"
  "\n"
  "  project-jumper\n";

static const char *help =
  "Usage: project-jumper [-v|--version] KEYWORD\n"
  "\n"
  "  project-jumper\n"
  "\n"
  "Available options:\n"
  "  -h,--help                Show this help text\n"
  "  -v,--version             Print version of the program\n"
  "  KEYWORD                  Keyword that is used to identify the name of the\n"
  "                           project\n";

/* A project, i.e. a ~/projects/<owner>/<name> directory. */
typedef struct {
  char *owner;
  char *name;
  int score;
} project;

typedef struct {
  project *items;
  size_t len;
  size_t cap;
} projects;

/* Print a message to stderr and stop execution with non-zero exit code. */
static void giveup(const char *msg) {
  fprintf(stderr, "%s\n", msg);
  exit(EXIT_FAILURE);
}

static void *xmalloc(size_t n) {
  void *p = malloc(n);
  if (p == NULL) giveup("Out of memory.");
  return p;
}

static char *xstrdup(const char *s) {
  char *p = strdup(s);
  if (p == NULL) giveup("Out of memory.");
  return p;
}

/* Concatenate the parts into a freshly allocated path. */
static char *path_join(const char *a, const char *b) {
  size_t n = strlen(a) + 1 + strlen(b) + 1;
  char *p = xmalloc(n);
  snprintf(p, n, "%s/%s", a, b);
  return p;
}

/* An ASCII-lowercased copy of the string. */
static char *lowercase(const char *s) {
  char *p = xstrdup(s);
  for (char *c = p; *c != '\0'; c++)
    if (*c >= 'A' && *c <= 'Z') *c += 'a' - 'A';
  return p;
}

/* Does the path name a directory? Symlinks are followed, matching the
 * behavior of the previous Haskell implementation. */
static int is_dir(const char *path) {
  struct stat st;
  return stat(path, &st) == 0 && S_ISDIR(st.st_mode);
}

static void push(projects *ps, const char *owner, const char *name) {
  if (ps->len == ps->cap) {
    ps->cap = ps->cap == 0 ? 16 : ps->cap * 2;
    project *items = realloc(ps->items, ps->cap * sizeof(project));
    if (items == NULL) giveup("Out of memory.");
    ps->items = items;
  }
  ps->items[ps->len].owner = xstrdup(owner);
  ps->items[ps->len].name = xstrdup(name);
  ps->items[ps->len].score = 0;
  ps->len++;
}

/* Open a directory, or bail out with a message naming it. */
static DIR *xopendir(const char *path) {
  DIR *d = opendir(path);
  if (d == NULL) {
    fprintf(stderr, "project-jumper: %s: %s\n", path, strerror(errno));
    exit(EXIT_FAILURE);
  }
  return d;
}

/* Collect the project directories under a single owner. */
static void list_names(const char *root, const char *owner, projects *ps) {
  char *owner_dir = path_join(root, owner);
  DIR *d = xopendir(owner_dir);
  struct dirent *e;
  while ((e = readdir(d)) != NULL) {
    if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
    char *name_dir = path_join(owner_dir, e->d_name);
    if (is_dir(name_dir)) push(ps, owner, e->d_name);
    free(name_dir);
  }
  closedir(d);
  free(owner_dir);
}

/* List available projects. The order is the order in which the directories
 * are reported by the file system, which is what determines the order of
 * the choices offered below. */
static void list_projects(const char *root, projects *ps) {
  DIR *d = xopendir(root);
  struct dirent *e;
  while ((e = readdir(d)) != NULL) {
    if (strcmp(e->d_name, ".") == 0 || strcmp(e->d_name, "..") == 0) continue;
    char *owner_dir = path_join(root, e->d_name);
    int owner = is_dir(owner_dir);
    free(owner_dir);
    if (owner) list_names(root, e->d_name, ps);
  }
  closedir(d);
}

/* Calculate the similarity score between the keyword and a project name: 2
 * for an exact match, 1 if the keyword occurs in the name, 0 otherwise. */
static int score(const char *keyword, const char *name) {
  char *k = lowercase(keyword);
  char *n = lowercase(name);
  int result = 0;
  if (strstr(n, k) != NULL) result = strlen(k) == strlen(n) ? 2 : 1;
  free(k);
  free(n);
  return result;
}

/* The offset at which the keyword occurs in the name, or the length of the
 * name when it does not occur at all. */
static size_t match_offset(const char *keyword, const char *name) {
  char *k = lowercase(keyword);
  char *n = lowercase(name);
  char *at = strstr(n, k);
  size_t result = at == NULL ? strlen(n) : (size_t)(at - n);
  free(k);
  free(n);
  return result;
}

/* Read a single character without waiting for a newline, leaving the
 * terminal as we found it. */
static int read_choice(char *out) {
  struct termios saved, raw;
  int tty = tcgetattr(STDIN_FILENO, &saved) == 0;
  if (tty) {
    raw = saved;
    raw.c_lflag &= ~ICANON;
    raw.c_cc[VMIN] = 1;
    raw.c_cc[VTIME] = 0;
    tcsetattr(STDIN_FILENO, TCSANOW, &raw);
  }
  ssize_t n = read(STDIN_FILENO, out, 1);
  if (tty) tcsetattr(STDIN_FILENO, TCSANOW, &saved);
  return n == 1;
}

/* Prompt the user to choose among the given projects. */
static const project *choose_match(const char *keyword, const projects *ms) {
  size_t n = ms->len;
  if (n > strlen(LETTERS)) n = strlen(LETTERS);
  for (size_t i = 0; i < n; i++) {
    const project *p = &ms->items[i];
    /* The part of the name that matched is highlighted. */
    size_t offset = match_offset(keyword, p->name);
    size_t len = strlen(keyword);
    if (offset + len > strlen(p->name)) len = strlen(p->name) - offset;
    fprintf(stderr, "\033[36m%c\033[0m %s/", LETTERS[i], p->owner);
    fprintf(stderr, "%.*s", (int)offset, p->name);
    fprintf(stderr, "\033[32m%.*s\033[0m", (int)len, p->name + offset);
    fprintf(stderr, "%s\n", p->name + offset + len);
  }
  char c;
  if (read_choice(&c))
    for (size_t i = 0; i < n; i++)
      if (LETTERS[i] == c) return &ms->items[i];
  giveup("Invalid selection.");
  return NULL; /* not reached */
}

int main(int argc, char **argv) {
  const char *keyword = NULL;
  for (int i = 1; i < argc; i++) {
    const char *arg = argv[i];
    if (strcmp(arg, "-h") == 0 || strcmp(arg, "--help") == 0) {
      fputs(help, stdout);
      return EXIT_SUCCESS;
    } else if (strcmp(arg, "-v") == 0 || strcmp(arg, "--version") == 0) {
      puts("project-jumper " VERSION);
      return EXIT_SUCCESS;
    } else if (arg[0] == '-' && arg[1] != '\0') {
      fprintf(stderr, "Invalid option `%s'\n\n%s", arg, usage);
      return EXIT_FAILURE;
    } else if (keyword == NULL) {
      keyword = arg;
    } else {
      fprintf(stderr, "Invalid argument `%s'\n\n%s", arg, usage);
      return EXIT_FAILURE;
    }
  }
  if (keyword == NULL) {
    fprintf(stderr, "Missing: KEYWORD\n\n%s", usage);
    return EXIT_FAILURE;
  }

  /* Locate the project directory for the current user, falling back to the
   * passwd entry when HOME is not set. */
  const char *home = getenv("HOME");
  if (home == NULL || home[0] == '\0') {
    struct passwd *pw = getpwuid(getuid());
    if (pw == NULL || pw->pw_dir[0] == '\0') giveup("Cannot find home directory.");
    home = pw->pw_dir;
  }
  /* TODO The root should be configurable */
  char *root = path_join(home, "projects");

  projects ps = { NULL, 0, 0 };
  list_projects(root, &ps);

  /* Select the matching project(s): the best-scoring ones win, ties are
   * resolved by the user. */
  int best = 0;
  for (size_t i = 0; i < ps.len; i++) {
    ps.items[i].score = score(keyword, ps.items[i].name);
    if (ps.items[i].score > best) best = ps.items[i].score;
  }
  if (best == 0) giveup("No matches found.");

  projects ms = { NULL, 0, 0 };
  for (size_t i = 0; i < ps.len; i++)
    if (ps.items[i].score == best) push(&ms, ps.items[i].owner, ps.items[i].name);

  const project *target =
    ms.len == 1 ? &ms.items[0] : choose_match(keyword, &ms);

  printf("%s/%s/%s/\n", root, target->owner, target->name);
  return EXIT_SUCCESS;
}
