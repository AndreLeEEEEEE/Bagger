;;; Towers of Hanoi from Artificial Intelligence: Tools, Techniques,
;;; and Applications, Tim O'Shea and Marc Eisenstadt, Harper & Rowe,
;;; 1984, pp.45

;;; The rules of the game are: (1) move one ring at a time and (2)
;;; never place a larger ring on top of a smaller ring.  The object
;;; is to transfer the entire pile of rings from its starting
;;; peg to either of the other pegs - the target peg.

(deffacts pegs
	(peg left)
	(peg middle)
	(peg right))

(defclass ring (is-a USER)
	(role concrete)
	(pattern-match reactive)
	(slot size)
	(slot on))

(defclass move (is-a USER)
	(role concrete)
	(pattern-match reactive)
	(slot size)
	(slot from)
	(slot to))

;;; If the target peg holds all the rings 1 to n, stop because according
;;; to game rule (2) they must be in their original order and so the
;;; problem is solved.
(defrule rule-1
	(forall (object (is-a ring) (on ?peg))
	        (test (eq ?peg right)))
=>
	(printout t "Problem solved!" crlf)
	(halt))

;;; If there is no current goal - that is, if a ring has just been
;;; successfully moved, or if no rings have yet to be moved - generate
;;; a goal.  In this case the goal is to be that of moving to the 
;;; target peg the largest ring that is not yet on the target peg.
(defrule rule-2
	(not (object (is-a move)))
	(object (is-a ring) (size ?size) (on ?peg&~right))
	(not (object (is-a ring) (size ?size-1&:(> ?size-1 ?size)) (on ?peg-1&~right)))
=>
	(make-instance of move (size ?size) (from ?peg) (to right)))

;;; If there is a current goal, it can be achieved at once if there is
;;; no small rings on top of the ring to be moved (i.e., if the latter
;;; is at the top of its pile), and there are no smaller rings on the
;;; peg to which it is to be moved (i.e., the ring to be moved is 
;;; smaller that the top ring on the peg we intend to move it to).  If
;;; this is the case, carry out the move and then delete the current
;;; goal so that rule 2 will apply next time.
(defrule rule-3
	?move <- (object (is-a move) (size ?size) (from ?from) (to ?to))
	?ring <- (object (is-a ring) (size ?size) (on ?from))
	(not (object (is-a ring) (size ?size-1&:(< ?size-1 ?size)) (on ?from|?to)))
=>
    (printout t "Move ring " ?size " from " ?from " to " ?to "." crlf)
	(unmake-instance ?move)
	(send ?ring put-on ?to))

;;; If there is a current goal but its disc cannot be moved as in rule
;;; 3, set up a new goal: that of moving the largest of the obstructing
;;; rings to the peg that is neither of those specified in the current
;;; goal (i.e. well out of the way of the current goal).  Delete the
;;; current goal, so that rule 2 will apply to the new goal next time.
(defrule rule-4
	?move <- (object (is-a move) (size ?size) (from ?from) (to ?to))
	(peg ?other&~?from&~?to)
	(object (is-a ring) (size ?size-1&:(< ?size-1 ?size)) (on ?peg-1&~?other))
	(not (object (is-a ring) (size ?size-2&:(< ?size-1 ?size-2 ?size)) (on ?peg-2&~?other)))
=>
	(unmake-instance ?move)
	(make-instance of move (size ?size-1) (from ?peg-1) (to ?other)))

(defrule start
	(declare (salience 10)) ; So it fires instead of rule-1 initially.
=>
	(printout t "How many disks? ")
	(loop-for-count (?i 1 (read)) do
		(make-instance of ring (size ?i) (on left))))
