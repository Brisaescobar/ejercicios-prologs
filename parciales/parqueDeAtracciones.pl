% https://docs.google.com/document/d/139S8G0vwD5wJNfb8UqsH5BV75d7sfUk9ywdvFCXRcLI/edit?tab=t.0#heading=h.b7fwzcvrhqzl

% persona(Nombre, edad, altura) -> altura en centimetros
persona(nina, joven, 22, 160).
persona(marcos, ninio, 8, 132).
persona(osvaldo, adolescente, 13, 129).

% atraccion nombre y requisitos 
atraccion(parqueDeLaCosta, trenFantasma, 12, 0).
atraccion(parqueDeLaCosta, montaniaRusa, 0 , 130).
atraccion(parqueDeLaCosta, maquinaTiquetera,0 ,0).
atraccion(parqueAcuatico, toboganGigante, 0, 150).
atraccion(parqueAcuatico, rioLento, 0, 0).
atraccion(parqueAcuatico, piscinaDeOlas, 5, 0).

%----------------------------------------------------------------
% pasaportes 

pasaporte(nina, basico, 20). 
pasaporte(marcos, flex(juegoPermitido(maquinaTiquetera)), 15). 
pasaporte(osvaldo, premium, _). 

juegoComun(trenFantasma, 20). 
juegoComun(olaAzul, 10). 
juegoComun(maremoto, 30). 
juegoComun(montanaRusa, 15). 

juegoPremium(maquinaTiquetera). 
juegoPremium(corrienteSerpenteante). 

tieneAcceso(UnaPersona, UnaAtraccion) :-
    pasaporte(UnaPersona, basico, Creditos), 
    juegoComun(UnaAtraccion, UnCosto), 
    Creditos >= UnCosto.

tieneAcceso(UnaPersona, UnaAtraccion) :-
    pasaporte(UnaPersona, flex(Permitido), Creditos), (juegoComun(UnaAtraccion, Costo), Creditos >= Costo ; juegoPremium(UnaAtraccion), Permitido = juegoPermitido(UnaAtraccion)). 

tieneAcceso(UnaPersona, UnaAtraccion) :- 
    atraccion(UnaAtraccion, _, _,_),
    pasaporte(UnaPersona, premium, _).

% 1 puede subir relaciona una persona con una atraccion si puede subir a esa atraccion

puedeSubir(UnaPersona, UnaAtraccion) :-
    persona(UnaPersona, _, Edad, Altura),
    atraccion(UnaAtraccion, _, EdadNecesaria, AlturaNecesaria),  
    Edad >= EdadNecesaria, 
    Altura >= AlturaNecesaria, 
    tieneAcceso(UnaPersona, UnaAtraccion).

% 2 es para elle relaciona un parque con una persona si la persona puede subir a todos los juegos del parque

esParaElle(UnaPersona, UnParque) :-
    forall(atraccion(UnParque, Atraccion,_,_), puedeSubir(UnaPersona, Atraccion)).

/* 3 malaIdea relacion un grupo etario (adolescente/niño/joven/adulto/etc) 
con un parque y nos dice que es mala idea que las personas vayan juntas a ese parque
si no que no hay ningun juego al que puedan subir todos. */

malaIdea(UnGrupo, UnParque) :- 
    persona(_, UnGrupo,_,_),
    forall(persona(Persona,UnGrupo,_,_), not(puedeSubir(Persona, UnParque))).

% -----------------------------------------------------------------------------
% programas lista ord de atracciones que esta en el mismo parque

% programa parque de la costa
programa([trenFantasma, montaniaRusa, maquinaTiquetera]).
programa([montaniaRusa, trenFantasma, maquinaTiquetera]).
programa([maquinaTiquetera, montaniaRusa, trenFantasma]).

% programa parque acuatico
programa([toboganGigante, rioLento, piscinaDeOlas]).
programa([rioLento, toboganGigante, piscinaDeOlas]).
programa([piscinaDeOlas, rioLento, toboganGigante]).

% 4 programa logico me dice si un programa es bueno es decir todos los juegos estan en el mismo parque y no estan repetidos
programaLogico(UnPrograma) :-
    Lista = [],
    programa(UnPrograma),
    progaramaEnUnParque(UnPrograma),
    list_to_set(UnPrograma, Lista).

progaramaEnUnParque([Atraccion | MasAtracciones]) :-
    atraccion(Parque, Atraccion, _, _),
    forall(member(UnaAtraccion, MasAtracciones), atraccion(Parque, UnaAtraccion,_, _)).

/*hasta aca relaciona una persona p y un programa q 
 con el subprograma s que se compone en iniciales de q 
 hasta a la primera p no puede subir */

hastaAca(Persona, Programa, AtraccionesValidas) :-
    persona(Persona,_,_,_),
    programa(Programa),
    hastaQueNoPuedaSubir(Persona, Programa, AtraccionesValidas).

hastaQueNoPuedaSubir(_, [], []).

hastaQueNoPuedaSubir(Persona, [Atraccion | MasAtracciones], [Atraccion | Atracciones]) :-
    puedeSubir(Persona, Atraccion),
    hastaQueNoPuedaSubir(Persona, MasAtracciones, Atracciones).

hastaQueNoPuedaSubir(Persona, [Atraccion | _], []) :-
    not(puedeSubir(Persona, Atraccion)).

