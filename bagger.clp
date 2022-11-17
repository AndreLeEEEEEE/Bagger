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
	(current-size 0))

(defrule B1
	(Step Check-order)
	(To-be-bagged Potato-chips)
	(not (To-be-bagged Pepsi))
=>
	(printout t "Execute B1" crlf)
	(assert (To-be-bagged Pepsi)))

(defrule B2
	(Step Check-order)
=>
	(retract 0)
	(Step bag-large-items))

(defrule B3
	(Step bag-large-items)
	(Is-bag ?bagName)
	?itemToBeBagged <- (To-be-bagged ?item bottle large ?freeze)
	?currentSize <- (current-size ?bagSize)
	(< ?bagSize 6)
=>
	(assert (current-size (+ ?bagSize 1)))
	(retract ?currentSize)
	(assert (In-bag ?bagName ?item))
	(retract ?itemToBeBagged))

(defrule B4
	(Step bag-large-items)
	(Is-bag ?bagName)
	?itemToBeBagged <- (To-be-bagged ?item ?container large ?freeze)
	?currentSize <- (current-size ?bagSize)
	(< ?bagSize 6)
=>
	(assert (current-size (+ ?bagSize 1)))
	(retract ?currentSize)
	(assert (In-bag ?bagName ?item))
	(retract ?itemToBeBagged))

(defrule B5
	(Step bag-large-items)
	?currentBag <- (Is-bag ?bagName)
	(To-be-bagged ?item ?container large ?freeze)
=>
	(assert (Is-bag (+ ?bagName 1)))
	(retract ?currentBag))

(defrule B6)