;Dados el nombre, el color de ojos, el color de cabello y la nacionalidad
;de una persona de un grupo utilizando la siguiente deftemplate:

(deftemplate persona (slot nombre) 
		(slot color-ojos)
		(slot color-cabello)
		(slot nacionalidad))

;escriba la regla que identificará:
;(a) cualquier persona con ojos azules o verdes que tiene cabello castaño y es francesa.
;(b) cualquier persona que no tiene ojos azules ni cabello negro y no tiene 
;el mismo color de ojos y cabello.
;(c) dos personas, la primera tiene ojos castaños o azules, no tiene cabello rubio y es alemana; 
;la segunda tiene ojos verdes, el mismo color de cabello que la primera persona y es de 
;cualquier nacionalidad. Los ojos de la segunda persona podrian ser cafe si el color de cabello 
;de la primera persona es castaño.

(deffacts personas
(persona (nombre Jean) (color-ojos azules)(color-cabello castano)(nacionalidad francesa))
(persona (nombre Paul) (color-ojos verdes)(color-cabello castano)(nacionalidad francesa))
(persona (nombre Luis) (color-ojos marrones)(color-cabello rojo)(nacionalidad argentino))
(persona (nombre Diogo) (color-ojos cafe)(color-cabello castano)(nacionalidad brasilero))
(persona (nombre Gretel) (color-ojos castanos)(color-cabello negro)(nacionalidad alemana))
(persona (nombre Hanz) (color-ojos azules)(color-cabello castano)(nacionalidad alemana))
(persona (nombre Monica) (color-ojos verdes)(color-cabello negro)(nacionalidad argentino))
(persona (nombre Victor) (color-ojos cafe)(color-cabello negro)(nacionalidad argentino)))

(defrule punto-a
(persona (nombre ?nombre)(color-ojos azules|verdes)(color-cabello castano)
	(nacionalidad francesa))
=>  
(printout t ?nombre " tiene ojos azules o verdes, cabello castaño y es francesa." crlf))

(defrule punto-b               
(persona (nombre ?nombre)(color-ojos ?ojos&~azules)(color-cabello ?cabello&~negro))
(test (neq ?ojos ?cabello)
=>
(printout t ?nombre " no tiene ojos azules ni cabello negro y no tiene 
el mismo color de ojos y cabello." crlf))

(defrule punto-c
(persona (nombre ?nombre1)(color-ojos ?ojos&castanos|azules)(color-cabello ?cabello&~rubio)
	(nacionalidad alemana))
(or (persona (nombre ?nombre2&~?nombre1)(color-ojos verdes)(color-cabello ?cabello))
    (and (persona (nombre ?nombre2&~?nombre1)(color-ojos cafe)(color-cabello ?cabello))
         (test (eq ?cabello castano)))
)
=>
(printout t " Primer persona es " ?nombre1 ", tiene ojos castaños o azules, no tiene cabello rubio y es alemana." crlf)
(printout t " Segunda persona es" ?nombre2 crlf))
