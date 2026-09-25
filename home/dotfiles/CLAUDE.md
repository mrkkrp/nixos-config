## Docs and comments

When you write docs in source code most of them must be a single sentence
that conveys the essence of the thing you are documenting. Do not be afraid
to use precise technical terms. Prefer them strongly to multi-word plain
English formulations. Each sentence after the first one needs justification
to be included—it must be important and non-trivial information.

Do not write line comments that explain what is going on inside the code,
unless the point they convey is truly important and non-trivial. Code should
dominate comments, not the other way around.

Instead of writing in Claudisms, try to write in a style that is already
used in the codebase.

## Work trees

When asked to start a new git work tree look at the name of the directory
where the project is checked out. If it does not have a `-wt-N` suffix,
where `N` is an integer, then the new work tree should be named after the
directory where the current checkout is located by going one level up and
appending the `-wt-N` suffix. `N` should be inferred automatically so that
there are no collisions. For example, when we are working in `foo`, the new
work tree directory should be `../foo-wt-0` and so on.

After creating the work tree, switch the session into it with the
`EnterWorktree` tool (passing its `path`) instead of running commands in it
from the original checkout, so that the session's working directory, and
hence the status line, names the work tree.
