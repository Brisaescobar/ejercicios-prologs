% sabemos de una persona su fuerza de agarre y si altura 
altura(ivo, 177).
altura(maru, 177). 
altura(connie, 165). 
altura(dana, 190). 
altura(esteban, 201).

% agarre 
agarre(ivo, 50). 
agarre(maru, 55). 
agarre(connie, 40). 
agarre(dana, 60). 
agarre(esteban, 30). 

% PARTE A 
/*
1 es cierto que connie mide 180cm 
altura(connie, 180).

2 existe alguien que mida 190cm 
altura(Persona, 190).

3 cual es el agarre de dana
agarre(dana, Agarre).

4 quienes miede 177cm
altura(Persona, 177).

5 milhouse mide 201cm 
altura(milhouse, 201).

*/

% PARTE B 
% bloque dado 
mismaAltura(Persona1, Persona2) :-
    altura(_, Altura), 
    findall(Persona, altura(Persona, Altura), Personas), 
    member(Persona1, Personas),
    member(Persona2, Personas).

/* indique v o f justificar conceptualmente 
    a - El codigo resuelve el problema planteado. v 
    b - El predicado mismaAltura es inversible. v
    c - El predicado mismaAltura tiene problemas de declaratividad. v

    A El codigo si resuelve el problema planteado, pero podria hacerse de otra forma mas eficiente
    B El predicado es parcialmente inversible 
    C El codigo si tiene problemas de declaratividad ya que usa el findall que es mas rebuscado 

*/
mismaAltura(Persona1, Persona2) :-
    altura(Persona1, Altura1), 
    altura(Persona2, Altura2), 
    sonLoMismo(Altura1, Altura2), 
    Persona1 \= Persona2.

sonLoMismo(Altura, Altura). 


% PARTE C 
% rocas relaciona el tipo de roca con la distancia desde el piso
roca(regleta(7), 150). 
roca(regleta(15), 80). 
roca(regleta(2), 370). 
roca(poligono(aspero, 8), 200). 
roca(poligono(liso, 5), 360).
roca(romo(100), 200). 
roca(romo(10), 400). 

% Las regletas tienen profundidad, los polígonos un material y una cantidad de caras, y los romos un diámetro

puedeAgarrar(Persona, regleta(Profundidad)):- 
   agarre(Persona, Agarre), 
   Agarre >= 10 / Profundidad. 

puedeAgarrar(Persona, poligono(liso, CantCaras)):- 
   agarre(Persona, Agarre), 
   Agarre >= 5 * CantCaras. 

puedeAgarrar(Persona, poligono(aspero, CantCaras)):- 
   agarre(Persona, Agarre), 
   Agarre >= CantCaras.

puedeAgarrar(Persona, romo(Diametro)):- 
   agarre(Persona, Agarre), 
   Agarre >= Diametro. 

/* verdadero o falso 
    a - es sencillo agregar un nuevo tipo de roca sin modificar el coddigo existente f
    b - hay un concepto del dominio que no esta en el codigo v
    c - se repite logica v 

    a- hay que agregar una nueva clausula y no queda limpio el codigo 
    para cada roca que se agregue

    b- la dificultad falta 

    c- si se repetite logica en el predicado puede agarrar y pasarle el agarre 
    se podria hacer un predicado agarreSegunTipo(UnaPiedra).

*/
% ---------------------------------------------
% agarreSegunTipo(Tipo, Dificultad).


% -------------------------------------------------------

puedeAgarrar(UnaPersona, UnaRoca) :-
    agarre(UnaPersona, Agarre), 
    agarreSegunTipo(Tipo, Dificultad), 
    Agarre >= Dificultad.

agarreSegunTipo(ragleta(Profundidad), Dificultad) :-
    Dificultad is 10 / Profundidad.

agarreSegunTipo(poligono(liso, CantidadDeCaras), Dificultad) :-
    Dificultad is 5 * CantidadDeCaras.

agarreSegunTipo(poligono(aspero, CantidadDeCaras), Dificultad). 
    %Dificultad is CantidadDeCaras.

agarreSegunTipo(romo(Diametro), Dificultad).
   % Dificultad is Diametro. % no que tan bien esta esto marta 


% PARTE D 

esCrack(Persona):- 
  forall(roca(Roca, _), puedeAgarrar(Persona, Roca)). 

esCrack(Persona):- 
  altura(Persona,_), 
  findall(Roca, (roca(Roca,_), not(puedeAgarrar(Persona, Roca))), Rocas), length(Rocas, 0). 

/*
    ¿Ambas soluciones funcionan igual?
    No, no funcionan igual si funcionan pero no de la misma forma,
    la primera hace un para todo que cumple una condicion hace la accion 
    mientras que la segunda hace una busqueda de las personas y devuelve una lista 

*/

esCrack(Persona) :-
    altura(Persona, _),
    not(((roca(Tipo, Dificultad)), not(puedeAgarrar(Persona, Roca)))).

% niego un para todo y dice no existe roca que no pueda levantar una persona

% PARTE E 
/*
Queremos saber si una persona puedeHacerUnMovimiento/3 de cierta altura a otra.  Esto se cumple cuando 
hay una roca en la primera altura que puede agarrar, una roca en la segunda altura que puede agarrar, y la 
distancia entre las rocas no supera la altura de la persona. 
Codificar un predicado inversible que resuelva este problema. 
*/

puedeHacerUnMovimiento(Persona, Altura, OtraAltura) :-
    altura(Persona, AlturaPersona), 
    roca(UnaRoca, Altura), 
    puedeAgarrar(Persona, UnaRoca),
    roca(OtraRoca, OtraAltura), 
    puedeAgarrar(Persona, OtraRoca), 
    Diferencia is Altura - OtraAltura,
    abs(Diferencia, Distancia),
    Distancia =< AlturaPersona.

% PARTE F 
/* Queremos conocer si una persona puedeLlegarHasta/2 cierta altura, que se cumple cuando puede hacer 
una sucesión de movimientos entre la altura de la roca más baja de la pared y la altura deseada. Debe ser 
inversible. */
%puedeLLegasHasta(Persona, Altura) :-


% HAY QUE HACER ARREGLOS !!!
