; bagger.clp
(deffacts items
	(size medium Bread)
	(size small Glop)
	(size large Granola)
	(size medium Ice-cream)
	(size medium Potato-chips)
	(size large Pepsi)
	(container plastic-bag Bread)
	(container jar Glop)
	(container cardboard-box Granola)
	(container cardboard-carton Ice-cream)
	(container plastic-bag Potato-chips)
	(container bottle Pepsi)
	(is-frozen Ice-cream))
	(Step Check-order)
	(Is-bag Bag1)
	(To-be-bagged Bread)
	(To-be-bagged Glop)
	(To-be-bagged Granola)
	(To-be-bagged Ice-cream)
	(To-be-bagged Potato-chips)
	(To-be-bagged Pepsi)

(defrules B1
=>
	(printout t "Execute B1" crlf)