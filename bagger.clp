; bagger.clp
(deftemplate Bag 
    (slot number) 
    (slot size) 
    (multislot items))

(deftemplate Item 
    (slot name) 
    (slot container) 
    (slot size) 
    (slot frozen?)) 

(deffacts baggerFacts
	(Step check-order)
	(Bag (number 1) (size empty) (items))
	(Current-bag 1)
	(Item (name Bread) (container plastic-bag) (size medium) (frozen? no)) 
    (Item (name Glop) (container jar) (size small) (frozen? no)) 
    (Item (name Granola) (container cardboard-box) (size large) (frozen? no)) 
    (Item (name Ice-cream) (container cardboard-carton) (size medium) (frozen? yes))
    (Item (name Potato-chips) (container plastic-bag) (size medium) (frozen? no))
    (Item (name Pepsi) (container bottle) (size large) (frozen? no)))

(defrule B0 
    (declare (salience 10)) 
  	=> 
    (set-strategy complexity))

(defrule B1 
    (Step check-order) 
    (Item (name Ice-cream)) 
    (not (Item (name Pepsi))) 
  	=> 
    (println "I see you are buying potato chips. Would you like a Pepsi to go with them?") 
    (bind ?ans (upcase (sub-string 1 1 (read)))) 
    (if (eq ?ans "Y") 
		then 
		(assert (Item (name Pepsi) (container bottle) (size large) (frozen? no))))) 

(defrule B2
	?Step <- (Step check-order)
	=>
	(retract ?Step)
	(assert (Step bag-large-items)))

(defrule B3 
    (Step bag-large-items) 
    ?item <- (Item (container bottle) (size large)) 
    (Current-bag ?bagNumber) 
    ?bag <- (Bag (number ?bagNumber) (size empty|large) 
                 (items $?items&:(< (length$ $?items) 6))) 
  	=> 
    (modify ?bag (size large) 
            	 (items (insert$ $?items 1 (fact-slot-value ?item name)))) 
    (retract ?item)) 
 
(defrule B4 
    (Step bag-large-items) 
    ?item <- (Item (size large)) 
    (Current-bag ?bagNumber) 
    ?bag <- (Bag (number ?bagNumber) (size empty|large) 
            	 (items $?items&:(< (length$ $?items) 6))) 
  	=> 
    (modify ?bag (size large) 
            	 (items (insert$ $?items 1 (fact-slot-value ?item name)))) 
    (retract ?item)) 
 
(defrule B5 
    (Step bag-large-items) 
    (Item (size large)) 
    ?currentBag <- (Current-bag ?currentBagNumber) 
  	=> 
    (bind ?bagNumber (+ ?currentBagNumber 1)) 
    (assert (Bag (number ?bagNumber) (size empty) (items))) 
    (retract ?currentBag) 
    (assert (Current-bag ?bagNumber))) 

(defrule B6
	?Step <- (Step bag-large-items)
	=>
	(retract ?Step)
	(assert (Step bag-medium-items)))

(defrule B7 
    (Step bag-medium-items) 
    ?item <- (Item (size medium) (container ~freezer-bag) (frozen? yes)) 
  => 
    (modify ?item (container freezer-bag)))

(defrule B8 
    (Step bag-medium-items) 
    ?item <- (Item (size medium)) 
    (Current-bag ?bagNumber) 
    ?bag <- (Bag (number ?bagNumber) (size empty|medium) 
            	 (items $?items&:(< (length$ $?items) 12))) 
  	=> 
    (modify ?bag (size medium) 
            	 (items (insert$ $?items 1 (fact-slot-value ?item name)))) 
    (retract ?item)) 

(defrule B9
    (Step bag-medium-items) 
    (Item (size medium)) 
    ?currentBag <- (Current-bag ?currentBagNumber) 
  	=> 
    (bind ?bagNumber (+ ?currentBagNumber 1)) 
    (assert (Bag (number ?bagNumber) (size empty) (items))) 
    (retract ?currentBag) 
    (assert (Current-bag ?bagNumber))) 

(defrule B10
	?Step <- (Step bag-medium-items)
	=>
	(retract ?Step)
	(assert (Step bag-small-items)))

(defrule B11
    (Step bag-small-items) 
    ?item <- (Item (size small)) 
    (Current-bag ?bagNumber) 
    ?bag <- (Bag (number ?bagNumber) (size empty|small) 
            	 (items $?items&:(< (length$ $?items) 18))) 
  	=> 
    (modify ?bag (size small) 
            	 (items (insert$ $?items 1 (fact-slot-value ?item name)))) 
    (retract ?item)) 

(defrule B12
    (Step bag-small-items) 
    (Item (size small)) 
    ?currentBag <- (Current-bag ?currentBagNumber) 
  	=> 
    (bind ?bagNumber (+ ?currentBagNumber 1)) 
    (assert (Bag (number ?bagNumber) (size empty) (items))) 
    (retract ?currentBag) 
    (assert (Current-bag ?bagNumber))) 

(defrule B13
	?Step <- (Step bag-small-items)
	=>
	(retract ?Step)
	(assert (Step done))
	(printout t "Step is done" crlf))
