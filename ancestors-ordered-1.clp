; ancestors-ordered-1.clp
(deffacts ancestors
	(parents penelope jessica jeremy)
	(parents jessica mary-elizabeth homer)
	(parents jeremy jenny steven)
	(parents steven loree john)
	(parents loree FALSE jason)
	(parents homer stephanie FALSE))

(defrule initialize
=>
	(printout t "Please enter the first name of a" crlf)
	(printout t "person whose ancestors you would" crlf)
	(printout t "like to find:" crlf)
	(assert (request (read))))

(defrule print-ancestors
	(request ?name)
	(parents ?name ?mother ?father)
=>
	(if ?mother
	    then
		(printout t ?mother " is an ancestor via " ?name crlf)
		(assert (request ?mother)))
	(if ?father
		then
		(printout t ?father " is an ancestor via " ?name crlf)
		(assert (request ?father))))
