; bagger.clp
(deffacts items
	(Step Check-order)
	(Is-bag 1)
	(To-be-bagged Bread plastic-bag medium no-freeze no-freezer-bag)
	(To-be-bagged Glop jar small no-freeze no-freezer-bag)
	(To-be-bagged Granola cardboard-box large no-freeze no-freezer-bag)
	(To-be-bagged Ice-cream cardboard-carton medium yes-freeze no-freezer-bag)
	(To-be-bagged Potato-chips plastic-bag medium no-freeze no-freezer-bag)
	(To-be-bagged Pepsi bottle large no-freeze no-freezer-bag)
	(current-size 0)
	(current-content empty))

(defrule B1
	(Step Check-order)
	(To-be-bagged Potato-chips ?container ?size ?freeze ?freezeBag)
	(not (To-be-bagged Pepsi ?container ?size ?freeze ?freezeBag))
=>
	(printout t "Execute B1" crlf)
	(assert (To-be-bagged Pepsi bottle large no-freeze no-freezer-bag)))

(defrule B2
	(Step Check-order)
=>
	(retract 0)
	(Step bag-large-items))

(defrule B3
	(Step bag-large-items)
	(Is-bag ?bagName)
	?itemToBeBagged <- (To-be-bagged ?item bottle large ?freeze ?freezeBag)
	?currentSize <- (current-size ?bagSize)
	(< ?bagSize 6)
	?currentContent <- (current-content ?content)
=>
	(assert (current-size (+ ?bagSize 1)))
	(retract ?currentSize)
	(assert (In-bag ?bagName ?item))
	(retract ?itemToBeBagged)
	(retract ?currentContent)
	(assert (current-content large)))

(defrule B4
	(Step bag-large-items)
	(Is-bag ?bagName)
	?itemToBeBagged <- (To-be-bagged ?item ?container large ?freeze ?freezeBag)
	?currentSize <- (current-size ?bagSize)
	(< ?bagSize 6)
	?currentContent <- (current-content ?content)
=>
	(assert (current-size (+ ?bagSize 1)))
	(retract ?currentSize)
	(assert (In-bag ?bagName ?item))
	(retract ?itemToBeBagged)
	(retract ?currentContent)
	(assert (current-content large)))

(defrule B5
	(Step bag-large-items)
	?currentBag <- (Is-bag ?bagName)
	(To-be-bagged ?item ?container large ?freeze ?freezeBag)
	?currentSize <- (current-size ?bagSize)
	?currentContent <- (current-content ?content)
=>
	(assert (Is-bag (+ ?bagName 1)))
	(retract ?currentSize)
	(assert (current-size 0))
	(retract ?currentBag)
	(retract ?currentContent)
	(assert (current-content empty)))

(defrule B6
	(Step bag-large-items)
=>
	(retract (Step bag-large-items))
	(assert (Step bag-medium-items)))

(defrule B7
	(Step bag-medium-items)
	?frozen <- (To-be-bagged ?item ?container medium yes-freeze no-freezer-bag)
=>
	(assert (To-be-bagged ?item ?container medium yes-freeze yes-freezer-bag))
	(retract ?frozen))

(defrule B8
	(Step bag-medium-items)
	(Is-bag ?bagName)
	?itemToBeBagged <- (To-be-bagged ?item ?container medium ?freeze ?freezeBag)
	(not (current-content large))
	?currentSize <- (current-size ?bagSize)
	(< ?bagSize 12)
	?currentContent <- (current-content ?content)
=>
	(assert (current-size (+ ?bagSize 1)))
	(retract ?currentSize)
	(assert (In-bag ?bagName ?item))
	(retract ?itemToBeBagged)
	(retract ?currentContent)
	(assert (current-content medium)))

(defrule B9
	(Step bag-medium-items)
	?currentBag <- (Is-bag ?bagName)
	(To-be-bagged ?item ?container medium ?freeze ?freezeBag)
	?currentSize <- (current-size ?bagSize)
	?currentContent <- (current-content ?content)
=> 
	(assert (Is-bag (+ ?bagName 1)))
	(retract ?currentSize)
	(assert (current-size 0))
	(retract ?currentBag)
	(retract ?currentContent)
	(assert (current-content empty)))

(defrule B10
	(Step bag-medium-items)
=>
	(retract (Step bag-medium-items))
	(assert (Step bag-small-items)))

(defrule B11
	(Step bag-small-items)
	(Is-bag ?bagName)
	?itemToBeBagged <- (To-be-bagged ?item ?container small ?freeze ?freezeBag)
	(not (current-content large))
	(not (current-content medium))
	?currentSize <- (current-size ?bagSize)
	(< ?bagSize 18)
	?currentContent <- (current-content ?content)
=>
	(assert (current-size (+ ?bagSize 1)))
	(retract ?currentSize)
	(assert (In-bag ?bagName ?item))
	(retract ?itemToBeBagged)
	(retract ?currentContent)
	(assert (current-content small)))

(defrule B12
	(Step bag-small-items)
	(Is-bag ?bagName)
	(To-be-bagged ?item ?container small ?freeze ?freezeBag)
	?currentSize <- (current-size ?bagSize)
	?currentContent <- (current-content ?content)
=>
	(assert (Is-bag (+ ?bagName 1)))
	(retract ?currentSize)
	(assert (current-size 0))
	(retract ?currentBag)
	(retract ?currentContent)
	(assert (current-content empty)))

(defrule B13
	(Step bag-small-items)
=>
	(retract (Step bag-small-items))
	(assert (Step done)))