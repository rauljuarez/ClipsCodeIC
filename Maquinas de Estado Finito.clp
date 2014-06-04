!=====================================!
!              PROBLEMAS              !
!=====================================!

!=========================!
!       Ejemplo 1		  !
!=========================!

(clear)

(deftemplate maquina (slot estado))

(deftemplate entrada (slot valor))

(deftemplate entrada_valida (slot valor)
                            (slot valida))

(defrule imprimir_estado 
     (maquina (estado ?estado))
   =>
     (printout t " Estado de la maquina : " ?estado  crlf))

(defrule controlar_entrada1
     ?f1<-(entrada (valor ?valor&25|5))
   =>
     (retract ?f1)
     (assert (entrada_valida (valor ?valor)(valida si))))

(defrule controlar_entrada2
     ?f1<-(entrada (valor ?valor&~25|5))
   =>
     (retract ?f1)
     (assert (entrada_valida (valor ?valor)(valida no))))

(defrule entrada_no_valida
     ?f1<-(entrada_valida (valor ?valor)(valida no))
     ?f2<-(maquina (estado ?estado))
   =>
     (retract ?f1 ?f2)
     (printout t " La entrada : " ?valor " no es valida!!!"  crlf)
     (assert (maquina (estado ?estado))))


(defrule cambio_estado
     ?f1<-(maquina (estado ?estado))
     ?f2<-(entrada_valida (valor ?valor)(valida si))
   =>
     (retract ?f1 ?f2)
     (assert (maquina (estado (+ ?estado ?valor)))))

(defrule controlar_exito
     ?f1<-(maquina (estado ?estado&55|60|65|70|75))
   =>
     (printout t " Puede retirar la bebida..." crlf)      
     (retract ?f1)
     (assert (maquina (estado 0))))


;-----------------------------------------------------------------------
;Para probar

(deffacts maquina
      (maquina (estado 0)))
(reset)
(run)
(assert (entrada (valor 25)))
(run)
(assert (entrada (valor 5)))
(run)
(assert (entrada (valor 10)))
(run)
;-----------------------------------------------------------------------
!=========================!
!       Ejemplo 2		  !
!=========================!

(clear)

(deftemplate maquina (slot estado))

(deftemplate arco (slot actual)
                  (slot siguiente))

(deftemplate entrada (slot valor))

(defrule imprimir_estado
      (maquina (estado ?estado))
   =>
      (printout t " Estado de la maquina : " ?estado  crlf))

(defrule cambio_estado
      ?f1<-(maquina (estado ?estado))
      (entrada (valor ?valor&~fin))
      ?f2<-(entrada (valor ?valor))
           (arco (actual ?estado)(siguiente ?valor))
   =>
      (retract ?f1 ?f2)
      (assert (maquina (estado ?valor))))

(defrule cambio_a_exito
      ?f1<-(maquina (estado ?estado))
      ?f2<-(entrada (valor fin))
      (arco (actual ?estado)(siguiente exito)) 
   =>
      (retract ?f1 ?f2)
      (assert (maquina (estado exito))))

(defrule controlar_exito
      ?f1<-(maquina (estado exito))
   =>
      (retract ?f1)
      (printout t " La cadena es correcta "  crlf)
      (assert (maquina (estado inicio))))

(defrule entrada_mala1
      ?f1<-(maquina (estado ?estado))
      (entrada (valor ?valor&~fin))
      ?f2<-(entrada (valor ?valor))
      (arco (actual ?estado)(siguiente ?valor1&~?valor))
   =>
      (retract ?f1 ?f2)
      (printout t " La entrada : " ?valor " no es correcta "  crlf)
      (assert (maquina (estado ?estado))))

(defrule entrada_mala2
      ?f1<-(maquina (estado ?estado))
      ?f2<-(entrada (valor fin))
      (arco (actual ?estado)(siguiente ~exito))
   =>
      (retract ?f1 ?f2)
      (printout t " La entrada fin no es correcta "  crlf)
      (assert (maquina (estado ?estado))))

;-----------------------------------------------------------------------
(deffacts maquina
      (maquina (estado inicio)))

(deffacts arcos
      (arco (actual inicio)(siguiente w))
      (arco (actual w)(siguiente h))
      (arco (actual h)(siguiente i))
      (arco (actual i)(siguiente l))
      (arco (actual l)(siguiente e))
      (arco (actual e)(siguiente exito))
      (arco (actual w)(siguiente r))
      (arco (actual r)(siguiente i))
      (arco (actual i)(siguiente t))
      (arco (actual t)(siguiente e))
      (arco (actual inicio)(siguiente b))
      (arco (actual b)(siguiente e))
      (arco (actual e)(siguiente g))
      (arco (actual g)(siguiente i))
      (arco (actual i)(siguiente n))
      (arco (actual n)(siguiente exito))
)
;-----------------------------------------------------------------------
;Para probar WHILE
(assert(entrada(valor w)))
(run)
(assert(entrada(valor h)))
(run)
(assert(entrada(valor i)))
(run)
(assert(entrada(valor l)))
(run)
(assert(entrada(valor e)))
(run)
(assert(entrada(valor fin)))
(run)

;-----------------------------------------------------------------------
;Para probar WRITE
(assert(entrada(valor w)))
(run)
(assert(entrada(valor r)))
(run)
(assert(entrada(valor i)))
(run)
(assert(entrada(valor t)))
(run)
(assert(entrada(valor e)))
(run)
(assert(entrada(valor fin)))
(run)

;-----------------------------------------------------------------------
;Para probar BEGIN
(assert(entrada(valor b)))
(run)
(assert(entrada(valor e)))
(run)
(assert(entrada(valor g)))
(run)
(assert(entrada(valor i)))
(run)
(assert(entrada(valor n)))
(run)
(assert(entrada(valor fin)))
(run)
