;Ejemplo maquina estado finito TCP

(clear)

(reset)

(defrule inicial
      (initial-fact)
=>
      (assert (estado cerrado))
      (printout t "Estado actual: CERRADO" crlf
		    "Ingresar la entrada inicial {activa, pasiva}" crlf )
      (assert (comando (read)))
)

(defrule anything-a-cerrado
	?cerrado <- (estado cerrado)
	?segmento <- (segmento ?x)        
=>
	(retract ?segmento)				;elimina segmentos de una conexion previa
        (assert (segmento rst))
	(printout t "Estado actual: CERRADO" crlf
		    "Ingresar comando {pasiva, activa}" crlf)			
	(assert (comando (read)))
)	

(defrule cerrado-a-synsent
	?cerrado <- (estado cerrado)
	?activa <- (comando activa)        
=>
	(retract ?activa)
        (retract ?cerrado)
        (assert (segmento syn))
	(assert (estado synsent))
	(printout t "Estado actual: SYN SENT" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read)))
)	

(defrule cerrado-a-escucha
	?cerrado <- (estado cerrado)				;entrada
	?comando <- (comando pasiva)  				;entrada
=>
	(retract ?comando)
        (retract ?cerrado)
	(assert (estado escucha))				;salida
	(printout t "Estado actual: ESCUCHA" crlf
		    "Ingresar comando {send, cerrado}" crlf)			
	(assert (comando (read)))
)	

;***************************************		

(defrule escucha-a-synrecvd (declare (salience 1))
	?escucha <- (estado escucha)
	?syn <- (segmento syn)
=>
	(retract ?escucha)
	(assert (segmento ack))
	(assert (estado synrecvd))
	(printout t "Estado actual: SYN RECVD" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read)))
)	

(defrule escucha-a-synsent
	?escucha <- (estado escucha)
	?send <- (comando send)
=>
	(retract ?send)
	(retract ?escucha)
	(assert (segmento syn))
	(assert (estado synsent))
	(printout t "Estado actual: SYN SENT" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read)))
)	

(defrule escucha-a-cerrado
	?escucha <- (estado escucha)
	?cerrado <- (comando cerrado)
=>
	(retract ?cerrado)
	(retract ?escucha)
	(assert (estado cerrado))
	(printout t "Estado actual: CERRADO" crlf
		    "Ingresar comando {pasiva, activa}" crlf)			
	(assert (comando (read)))
)	

;********************************

(defrule synrecvd-a-establecido
	?synrecvd <- (estado synrecvd)
	?ack <- (segmento ack)
=>
	(retract ?synrecvd)
	(retract ?ack)
	(assert (estado establecido))
	(printout t "Estado actual: ESTABLECIDO" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read))))

(defrule synrecvd-a-escucha
	?synrecvd <- (estado synrecvd)
	?rst <- (segmento rst)
=>
	(retract ?synrecvd)
	(retract ?rst)
	(assert (estado escucha))
	(printout t "Estado actual: ESCUCHA" crlf
		    "Ingresar comando {send, cerrado}" crlf)			
	(assert (comando (read))))

(defrule synrecv-a-finEspera1 (declare (salience -1))
	?synrecvd <- (estado synrecvd)
	?cerrado <- (comando cerrado)
=>
	(retract ?cerrado)
	(retract ?synrecvd)
	(assert (segmento fin))
	(assert (estado finEspera1))
	(printout t "Estado actual: FIN ESPERA-1" crlf)			
)

;**********************************

(defrule synsent-a-establecido
	?synsent <- (estado synsent)
	?syn <- (segmento syn)
        ?ack <- (segmento ack)
=>
	(retract ?syn)
	(retract ?synsent)
	(assert (estado establecido))
	(printout t "Estado actual: ESTABLECIDO" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read))))	        

(defrule synsent-a-synrecvd
        ?synsent <- (estado synsent)
	?syn <- (segmento syn)
=>
	(retract ?synsent)
	(assert (segmento ack))
	(assert (estado synrecvd))
	(printout t "Estado actual: SYN RECVD" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read))))

(defrule synsent-a-cerrado
	?synsent <- (estado synsent)
	?cerrado <- (comando cerrado)
=>
	(retract ?cerrado)
	(retract ?synsent)
	(assert (segmento rst))
	(assert (estado cerrado))
	(printout t "Estado actual: CERRADO" crlf
		    "Ingresar comando {pasiva, activa}" crlf)			
	(assert (comando (read)))
)

;*******************************

(defrule establecido-a-esperaCierre
	?establecido <- (estado establecido)
	?fin <- (segmento fin)
=>
	(retract ?establecido)
	(retract ?fin)
	(assert (segmento ack))
	(assert (estado esperaCierre))
	(printout t "Estado actual: ESPERA DE CIERRE" crlf
		    "Ingresar comando {cerrado}" crlf)			
	(assert (comando (read)))
)

(defrule establecido-a-finEspera1
	?establecido <- (estado establecido)
	?cerrado <- (comando cerrado)
=>
	(retract ?establecido)
	(retract ?cerrado)
	(assert (segmento fin))
	(assert (estado finEspera1))
	(printout t "Estado actual: FIN ESPERA-1" crlf)			
)

;*************************

(defrule esperaCierre-a-ultimoAck
        ?esperaCierre <- (estado esperaCierre)
	?cerrado <- (comando cerrado)
=>
	(retract ?cerrado)
	(retract ?esperaCierre)
	(assert (segmento fin))
	(assert (estado ultimoAck))
	(printout t "Estado actual: ULTIMO ACK" crlf
		    "Ingresar comando {timeout}" crlf)			
	(assert (comando (read)))
)

;************************************

(defrule ultimoAck-a-cerrado
	?ultimoAck <- (estado ultimoAck)
	?ack <- (segmento ack)
=>
	(retract ?ultimoAck)
	(retract ?ack)
	(assert (estado cerrado))
	(printout t "Estado actual: CERRADO" crlf)		;estado final
)

(defrule ultimoAck-a-cerrado2
	?ultimoAck <- (estado ultimoAck)
	?timeout <- (comando timeout)
=>
	(retract ?ultimoAck)
	(retract ?timeout)
	(assert (estado cerrado))
	(printout t "Estado actual: CERRADO" crlf)		;estado final		
) 

;****************************************

(defrule finEspera1-a-esperaCronometrada
	?finEspera1 <- (estado finEspera1)
	?fin <- (segmento fin)
	?ack <- (segmento ack)
=>
	(retract ?finEspera1)
	(retract ?fin)
	(assert (estado esperaCronometrada))
	(printout t "Estado actual: ESPERA CRONOMETRADA" crlf
		    "Ingresar comando {timeout}" crlf)			
	(assert (comando (read)))
)

(defrule finEspera1-a-finEspera2
	?finEspera1 <- (estado finEspera1)
	?ack <- (segmento ack)
=>
	(retract ?finEspera1)
	(retract ?ack)
	(assert (estado finEspera2))
	(printout t "Estado actual: FIN ESPERA-2" crlf)			
)	

(defrule finEspera1-a-cerrado
	?finEspera1 <- (estado finEspera1)
	?fin <- (segmento fin)
=>
	(retract ?finEspera1)
	(retract ?fin)
 	(assert (segmento ack))
	(assert (estado cerrado))
	(printout t "Estado actual: CERRADO" crlf)
)

;*********************************************

(defrule finEspera2-a-esperaCronometrada
	?finEspera2 <- (estado finEspera2)
	?fin <- (segmento fin)
=>
	(retract ?finEspera2)
	(retract ?fin)
	(assert (segmento ack))
	(assert (estado esperaCronometrada))
	(printout t "Estado actual: ESPERA CRONOMETRADA" crlf
		    "Ingresar comando {timeout}" crlf)			
	(assert (comando (read)))
)

(defrule cerrado-a-esperaCronometrada
	?cerrado <- (estado cerrado)
	?ack <- (segmento ack)
=>
	(retract ?cerrado)
	(retract ?ack)
	(assert (estado esperaCronometrada))
	(printout t "Estado actual: ESPERA CRONOMETRADA" crlf
		    "Ingresar comando {timeout}" crlf)			
	(assert (comando (read)))
)

;***********************************************

(defrule esperaCronometrada-a-cerrado
	?esperaCronometrada <- (estado esperaCronometrada)
	?timeout <- (comando timeout)
=>
	(retract ?esperaCronometrada)
	(retract ?timeout)
	(assert (estado cerrado))
	(printout t "Estado actual: CERRADO" crlf)		;estado final	
)




