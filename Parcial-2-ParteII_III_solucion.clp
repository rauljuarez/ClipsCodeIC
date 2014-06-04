Parte II: Especificaci�n en lenguaje CLIPS de la soluci�n de un problema l�gico. 

1. Realizar una funci�n para obtener el factorial de un n�mero de manera recursiva.
2. Realizar una funci�n para obtener el factorial de un n�mero de manera iterativa.

Recuerde que el factorial de un numero es el producto de ese numero 
por el factorial del numero anterior, y que el factorial de 0 es 1.


1. Manera recursiva

(deffunction factorial (?numero)
	(if (= ?numero 0) 
	 then
  		1
	 else
	    	(* ?numero (factorial (- ?numero 1))) )
)

;prueba
(factorial 3)  
;respuesta 6


2. Manera iterativa

(deffunction factorial (?numero)
      (if (= ?numero 0)
       then 
            1
       else  
            (bind ?x (- ?numero 1)) 
            (while (<> ?x 0)
            	(bind ?numero (* ?numero ?x))
                  (bind ?x (- ?x 1))  )
             ?numero           
      )      
)

;prueba
(factorial 4)  
;respuesta 24




Parte III: PROBLEMA A RESOLVER
Especificar en lenguaje CLIPS la soluci�n de un problema l�gico:

El Mistero de la Mansi�n Dreadsbury
Premisas P:
1.  La t�a Agata fue asesinada por alguien que vive en la mansi�n.
2.  Agata, el mayordomo y Charles viven en Dreadsbury Mansion, y ellos son los �nicos que viven alli.
3.  Un asesino siempre odia a su v�ctima y nunca es m�s rico que ella.
4.  Charles no odia a nadie que la t�a Agata odie.
5.  Agata odia a todo el mundo menos al mayordomo.
6.  El mayordomo odia a todos los que no son m�s ricos que la t�a Agata.
7.  El mayordomo odia a todos los que la t�a Agata odia.
8.  Nadie odia a todos.
9.  Agata no es el mayordomo.

Utilizando el programa desarrollado en CLIPS y haciendo una corrida de escritorio, trate de sacar todas las conclusiones y verifique si las siguientes conclusiones de los inspectores son correctas:
1.  Inspector Bjorn: Charles no asesin� a Agata
2.  Inspector Reidar: Agata asesin� a Agata (Agata se suicid�)
3.  Inspector Olaf: El mayordomo no asesin� a Agata

;Extraido de la red semantica del primer parcial
(deftemplate sospechoso
	(slot nombre)
	(slot odia-a-Agata)
	(slot mas-rico-que-Agata)
	(slot vive-en-mansion)
)

(defrule asesino
	(sospechoso (nombre ?nombre)
		(odia-a-Agata si)
		(mas-rico-que-Agata no)
		(vive-en-mansion si)
	)
	=>
	(printout t ?nombre " Asesino a Agata" crlf)
)

(deffacts sospechosos
	(sospechoso (nombre Agata)
				(odia-a-Agata si)
				(mas-rico-que-Agata no)
				(vive-en-mansion si)
	)
	(sospechoso (nombre Charles)
				(odia-a-Agata no)
				(mas-rico-que-Agata noConfirmado)
				(vive-en-mansion si)
	)
	(sospechoso (nombre Mayordomo)
				(odia-a-Agata si)
				(mas-rico-que-Agata noConfirmado)
				(vive-en-mansion si)
	)
)

