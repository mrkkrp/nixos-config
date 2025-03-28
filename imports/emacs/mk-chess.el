;;; mk-chess.el --- -*- lexical-binding: t; -*-

;;; Commentary:

;; Generation of daily tasks for chess practice.  This depends on having a
;; chess.com account.

;;; Code:

(require 'cl-lib)

(defconst mk-chess-openings
  '(("Alekhine's defense"
     "https://www.chess.com/lessons/learn-the-alekhines-defense"
     "https://www.chess.com/practice/openings/e4-openings/e3e05a56-d397-11eb-bafd-a909aabc0805")
    ("Caro-Kann defense"
     "https://www.chess.com/lessons/learn-the-caro-kann-defense"
     "https://www.chess.com/practice/openings/e4-openings/e3e08620-d397-11eb-abb8-7d15a0e728b2")
    ("Closed Sicilian"
     "https://www.chess.com/lessons/learn-the-closed-sicilian"
     "https://www.chess.com/practice/openings/e4-openings/e3e2b684-d397-11eb-89c2-0ff52d7395ae")
    ("Dutch defense"
     "https://www.chess.com/lessons/learn-the-dutch-defense"
     "https://www.chess.com/practice/openings/d4-openings/e3e3aca6-d397-11eb-838c-6996e2abe545")
    ("English opening"
     "https://www.chess.com/lessons/learn-the-english-opening"
     "https://www.chess.com/practice/openings/other-openings/e3e57b1c-d397-11eb-a259-61f7cbd8ae02")
    ("French defense"
     "https://www.chess.com/lessons/why-simon-loves-the-french"
     "https://www.chess.com/practice/openings/e4-openings/e3e0b4ec-d397-11eb-af5b-cb0786486d2b")
    ("Italian game"
     "https://www.chess.com/lessons/learn-the-italian-game"
     "https://www.chess.com/practice/openings/e4-openings/e3e0e9ee-d397-11eb-be47-c3983591cd87")
    ("London system"
     "https://www.chess.com/lessons/london-system-for-the-busy-chess-player"
     "https://www.chess.com/practice/openings/d4-openings/e3e45c28-d397-11eb-a94e-69a3665ae494")
    ("Open Sicilian"
     "https://www.chess.com/lessons/learn-the-sicilian-najdorf"
     "https://www.chess.com/practice/openings/e4-openings/e3e2d984-d397-11eb-8cce-41d851d0e21e")
    ("Pirc defense"
     "https://www.chess.com/lessons/learn-the-pirc-defense-and-the-modern-defense"
     "https://www.chess.com/practice/openings/e4-openings/e3e1c9cc-d397-11eb-a263-8513b85e19c9")
    ("Queen's gambit accepted"
     "https://www.chess.com/lessons/learn-the-queens-gambit-accepted"
     "https://www.chess.com/practice/openings/d4-openings/e3e4c5b4-d397-11eb-8b7c-81e37b3f6664")
    ("Queen's gambit declined"
     "https://www.chess.com/lessons/learn-the-queens-gambit-declined"
     "https://www.chess.com/practice/openings/d4-openings/e3e4c5b4-d397-11eb-8b7c-81e37b3f6664")
    ("Ruy Lopez"
     "https://www.chess.com/lessons/learn-the-ruy-lopez-berlin-defense"
     "https://www.chess.com/practice/openings/e4-openings/e3e1fd7a-d397-11eb-9f49-41d35c64019e")
    ("Scandinavian defense"
     "https://www.chess.com/lessons/learn-the-scandinavian-defense"
     "https://www.chess.com/practice/openings/e4-openings/e3e231dc-d397-11eb-9dbe-a377b26633b7")
    ("Scotch game"
     "https://www.chess.com/lessons/learn-the-scotch-game"
     "https://www.chess.com/practice/openings/e4-openings/e3e26846-d397-11eb-a316-a765e326abcb")
    ("Semi-Slav defense"
     "https://www.chess.com/lessons/learn-the-semi-slav-defense"
     "https://www.chess.com/practice/openings/d4-openings/e3e50c5e-d397-11eb-88b0-1b8d8d12ccad")
    ("Slav defense"
     "https://www.chess.com/lessons/learn-the-slav-defense"
     "https://www.chess.com/practice/openings/d4-openings/e3e50c5e-d397-11eb-88b0-1b8d8d12ccad"))
  "The chess openings that I aim to learn and practice.

Each opening is represented as a 3-element list.  The first item is the
name of the opening, the second is the tutorial page, and the third
element is the practice page.")

(defconst mk-chess-endgames
  '(("Two rooks mate"
     "https://www.chess.com/lessons/winning-the-game/checkmate-with-two-rooks"
     "https://www.chess.com/endgames/checkmates/two-rooks-mate/practice")
    ("Queen mate"
     "https://www.chess.com/lessons/winning-the-game/checkmate-with-the-queen"
     "https://www.chess.com/endgames/checkmates/queen-mate/practice")
    ("Rook mate"
     "https://www.chess.com/lessons/winning-the-game/checkmate-with-the-rook"
     "https://www.chess.com/endgames/checkmates/rook-mate/practice")
    ("Two bishops mate"
     "https://www.chess.com/lessons/master-endgame-checkmates/checkmate-with-two-bishops"
     "https://www.chess.com/endgames/checkmates/two-bishops-mate/practice")
    ("Bishop and knight mate"
     "https://www.chess.com/lessons/master-endgame-checkmates/checkmate-with-bishop-and-knight"
     "https://www.chess.com/endgames/checkmates/bishop-and-knight-mate/practice")
    ("Checkmate with queen vs rook"
     "https://www.chess.com/video/player/mating-with-queen-vs-rook-i"
     "https://www.chess.com/endgames/checkmates/queen-vs-rook/practice")
    ("Winning king and pawn"
     "https://www.chess.com/lessons/understanding-endgames/passed-pawns"
     "https://www.chess.com/endgames/pawn/winning-king-and-pawn/practice")
    ("Drawn king and pawn"
     "https://www.chess.com/lessons/understanding-endgames/passed-pawns"
     "https://www.chess.com/endgames/pawn/drawn-king-and-pawn/practice")
    ("Intermediate wins"
     "https://www.chess.com/lessons/pawn-endings-beginner-to-expert"
     "https://www.chess.com/endgames/pawn/intermediate-wins/practice")
    ("Intermediate draws"
     "https://www.chess.com/lessons/pawn-endings-beginner-to-expert"
     "https://www.chess.com/endgames/pawn/intermediate-draws/practice")
    ("Advanced wins"
     "https://www.chess.com/lessons/mastering-the-endgame"
     "https://www.chess.com/endgames/pawn/advanced-wins/practice")
    ("Advanced draws"
     "https://www.chess.com/lessons/mastering-the-endgame"
     "https://www.chess.com/endgames/pawn/advanced-draws/practice")
    ("Win with the bishop"
     "https://www.chess.com/lessons/winning-with-opposite-colored-bishops"
     "https://www.chess.com/endgames/minor-piece/bishop/practice")
    ("Win with the knight"
     "https://www.chess.com/lessons/mastering-the-endgame"
     "https://www.chess.com/endgames/minor-piece/knight/practice")
    ("Win with the knight vs bishop"
     "https://www.chess.com/lessons/bishop-versus-knight-part-1"
     "https://www.chess.com/endgames/minor-piece/knight-vs-bishop/practice")
    ("Win with a knight vs pawns"
     "https://www.chess.com/lessons/mastering-the-endgame"
     "https://www.chess.com/endgames/minor-piece/knight-vs-pawns/practice")
    ("Win with a bishop vs pawns"
     "https://www.chess.com/lessons/winning-with-opposite-colored-bishops"
     "https://www.chess.com/endgames/minor-piece/bishop-vs-pawns/practice")
    ("Winning rook endings"
     "https://www.chess.com/lessons/super-gm-rook-endings"
     "https://www.chess.com/endgames/rook/winning-rook-endings/practice")
    ("Drawn rook endings"
     "https://www.chess.com/lessons/super-gm-rook-endings"
     "https://www.chess.com/endgames/rook/drawn-rook-endings/practice")
    ("Rook vs pawns"
     "https://www.chess.com/lessons/super-gm-rook-endings"
     "https://www.chess.com/endgames/rook/rook-vs-pawns/practice")
    ("Basic queen endings"
     "https://www.chess.com/lessons/rook-and-other-endgames"
     "https://www.chess.com/endgames/queen/basic-queen-endings/practice")
    ("Defending queen endings"
     "https://www.chess.com/lessons/rook-and-other-endgames"
     "https://www.chess.com/endgames/queen/defending-queen-endings/practice")
    ("Advanced queen endings"
     "https://www.chess.com/lessons/rook-and-other-endgames"
     "https://www.chess.com/endgames/queen/advanced-queen-endings/practice")
    ("Queen vs pawns"
     "https://www.chess.com/lessons/rook-and-other-endgames"
     "https://www.chess.com/endgames/queen/queen-vs-pawns/practice")
    ("Rook vs minor piece"
     "https://www.chess.com/lessons/master-material-imbalances"
     "https://www.chess.com/endgames/imbalances/rook-vs-minor-piece/practice")
    ("Rook vs two minor pieces"
     "https://www.chess.com/lessons/master-material-imbalances"
     "https://www.chess.com/endgames/imbalances/rook-vs-two-minor-pieces/practice")
    ("Queen vs two rooks"
     "https://www.chess.com/lessons/master-material-imbalances"
     "https://www.chess.com/endgames/imbalances/queen-vs-two-rooks/practice")
    ("Basic imbalances"
     "https://www.chess.com/lessons/master-material-imbalances"
     "https://www.chess.com/endgames/imbalances/basic-imbalances/practice")
    ("Advanced imbalances"
     "https://www.chess.com/lessons/rook-and-knight-vs-rook"
     "https://www.chess.com/endgames/imbalances/advanced-imbalances/practice"))
  "A collection of endgame situations to practice.

Each endgame is represented as a 3-element list.  The first element is
the name of the endgame, the second is the tutorial page, and the third
element is the practice page.")

(defun mk-chess-insert-daily-tasks ()
  "Insert a complete daily routine for chess: puzzles, an opening, and an endgame."
  (interactive)
  (mk-chess-insert-puzzles)
  (mk-chess-insert-opening)
  (mk-chess-insert-endgame))

(defun mk-chess-insert-puzzles ()
  "Insert a task about doing some tactic puzzles."
  (interactive)
  (insert "* Chess puzzles https://www.chess.com/puzzles/rated\n"))

(defun mk-chess-insert-opening ()
  "Insert today's task suggestion for chess openings."
  (interactive)
  (cl-destructuring-bind (topic tutorial practice)
      (mk-select-element-of-the-day mk-chess-openings)
    (mk-insert-tutorial-and-practice topic tutorial practice)))

(defun mk-chess-insert-endgame ()
  "Insert today's task suggestion for chess endgames."
  (interactive)
  (cl-destructuring-bind (topic tutorial practice)
      (mk-select-element-of-the-day mk-chess-endgames)
    (mk-insert-tutorial-and-practice topic tutorial practice)))

(defun mk-insert-tutorial-and-practice (topic tutorial practice)
  "Insert a task mentioning the TOPIC name, TUTORIAL page, and PRACTICE page."
  (insert
   "* Study "
   topic
   ":\n  * Tutorial: "
   tutorial
   "\n  * Practice: "
   practice
   "\n"))

(defun mk-select-element-of-the-day (list)
  "Given a LIST, select an element that corresponds to the current day."
  (let* ((total (length list))
         (current-day (time-to-day-in-year (current-time)))
         (i (mod current-day total)))
    (nth i list)))

(provide 'mk-chess)

;;; mk-chess.el ends here
