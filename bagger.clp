; bagger.clp
(deffacts items
	(Bread size medium)
	(Glop size small)
	(Granola size large)
	(Ice-cream size medium)
	(Potato-chips size medium)
	(Pepsi size large)
	(Bread container plastic-bag)
	(Glop container jar)
	(Granola container cardboard-box)
	(Ice-cream container cardboard-carton)
	(Potato-chips container plastic-bag)
	(Pepsi container bottle)
	(Ice-cream frozen))
	(Step is check-order)
	(Bag1 is a bag)
	(Bread is to be bagged)
	(Glop is to be bagged)
	(Granola is to be bagged)
	(Ice-cream is to be bagged)
	(Potato-chips is to be bagged)
	(Pepsi is to be bagged)

(defrules B1
=>
	(printout t "Execute B1" crlf)