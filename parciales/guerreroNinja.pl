% persona(Nombre, Apertura, Fuerza).

persona(ada, 166, 60). 
persona(beto, 166, 65). 
persona(connie, 154, 50). 
persona(dana, 180, 70). 
persona(esteban, 193, 40). 

% PARTE A 
/*
    1. Existe alguien que tenga una apertura de 180cm 
        persona(Nombre, 180, _).

    2. Cual es la fuerza de dana 
    persona(dana, _, Fuerza).

    3. Quienes tienen apertura de 166 cm 
    persona(Nombre, _, 166).

    4. milhouse tiene 33 de fuerza 
    persona(milhouse, _ , 33).

    5. es cierto que connie tiene una apertura de brazos de 154
    persona(connie, 154, _ ).

 */

% PARTE B

algunoSuperaA(Persona):- 
persona(Persona, _, Fuerza), 
findall(Otro, (persona(Otro,_,FuerzaOtro), FuerzaOtro > Fuerza), Otros), 
length(Otros, Longitud), 
Longitud > 0.

/*
    Verdadero o Falso 
    a. El codigo resuelve el problema planteado. V 
    b. El predicado es inversible. V 
    c. El predicado algunoSuperaA tiene problemas de declaratividad. V 

    a. Si crea una lista y verifica que la lista no este vacia
    b. Findall y length rompen la inversibilidad 
    c. Hay formas mas declarativas de resolver el problema

*/

algunoSuperaA(Persona) :-
    persona(Persona, _, Fuerza1),
    persona(Persona2, _,Fuerza2), 
    Fuerza1 > Fuerza2,
    Persona \= Persona2.

% PARTE C 

% obstaculos
obstaculo(aro(7), 14). 
obstaculo(aro(15), 70). 
obstaculo(barril(seco, 80), 10). 
obstaculo(pared(5), 90). 
obstaculo(aro(15), 10). 
obstaculo(barril(humedo, 50), 26). 
obstaculo(aro(2), 27). 

% ------------------------------------------
laMetaEstaEn1(Posicion):- 
  obstaculo(_, Posicion), 
  findall(Obs, (obstaculo(Obs, Pos),  
      Pos > Posicion), Obstaculos), 
  length(Obstaculos, 0). 

laMetaEstaEn2(Posicion):- 
  forall(obstaculo(_, Pos), Posicion >= Pos). 

/*
No no funcionan igual, en el primero al tener ligada la varibale responde en base a esa
mientras que el segundo va comparando las posiciones y cambiando segun su lugar
*/

laMetaEstaEn(Posicion) :-
    obstaculo(_, Posicion), 
    not(hayOtroObstaculo(Posicion)).

hayOtroObstaculo(Posicion) :-
    obstaculo(_, Posicion), 
    obstaculo(_, OtraPosicion), 
    Posicion < OtraPosicion.

% PARTE D 

puedeDarUnPaso(Persona, Desde, Hasta):- 
   persona(Persona, Apertura, Fuerza), 
   Apertura > Hasta - Desde,  
   obstaculo(aro(Grosor), Hasta), 
   Fuerza > Grosor. 

puedeDarUnPaso(Persona, Desde, Hasta):- 
   persona(Persona, Apertura, Fuerza), 
   Apertura > Hasta - Desde,  
   obstaculo(pared(Altura), Hasta), 
   Fuerza > Altura * 3. 

puedeDarUnPaso(Persona, Desde, Hasta):- 
   persona(Persona, Apertura, Fuerza), 
   Apertura > Hasta - Desde,  
   obstaculo(barril(humedo,Diametro), Hasta), 
   Fuerza > 50 * Diametro / 10. 

puedeDarUnPaso(Persona, Desde, Hasta):- 
   persona(Persona, Apertura, Fuerza), 
   Apertura > Hasta - Desde,  
   obstaculo(barril(seco,Diametro), Hasta), 
   Fuerza > 30 * Diametro / 10.

/*
    Verdadero o Falso 
    a. Es sencillo agregar un nuevo tipo de obs sin cambiar el predicado. F 
    b. Hay conceptos del dominio que no estan en el codigo,
    c. Se repite logica.

    a. Hay que agregar una nueva clausula.
    b. si falta la dificultad.
    c. si bastante (hay que abstraer).
*/

puedeDarUnPaso(Persona, Desde, Hasta) :-
    obstaculo(Obstaculo, _),
    persona(Persona,_, Fuerza),
    aperturaSuficiente(Persona, Desde, Hasta),
    darPasoSegunTipo(Obstaculo, Dificultad),
    Fuerza >= Dificultad.

darPasoSegunTipo(obstaculo(aro(Dificultad)), Dificultad). 
    % Dificultad is Grosor. % No se que tan bien esta esto marta

darPasoSegunTipo(obstaculo(pared(Altura)), Dificultad) :-
    Dificultad is Altura * 3.

darPasoSegunTipo(barril(humedo, Diametro), Dificultad) :-
    Dificultad is 50 * Diametro / 10.

darPasoSegunTipo(barril(seco, Diametro), Dificultad) :-
    Dificultad is 30 * Diametro / 10.

aperturaSuficiente(Persona, Desde, Hasta) :-
    persona(Persona, Apertura, _), 
    Apertura > Hasta - Desde.

% PARTE E 

/*Codificar un predicado que permita conocer si una persona puedeGanarDesde/2 cierta posición en metros, 
que se cumple cuando puede hacer una sucesión de pasos entre la posición en la que está y la meta. Debe 
ser inversible. */
puedeGanar(_, Posicion , Posicion).

puedeGanarDesde(Persona, PosicionActual, Meta) :-
   puedeDarUnPaso(Persona, PosicionActual, PosicionSiguiente), 
   PosicionSiguiente \= PosicionActual,
   puedeGanarDesde(Persona, PosicionSiguiente, Meta).

