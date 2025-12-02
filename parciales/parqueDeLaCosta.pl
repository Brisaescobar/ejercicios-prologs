% base de conocimiento

% puestos de comida
puesto(hamburguesitas, 2000).
puesto(panchitosConPapitas, 1500).
puesto(lomitoCompleto, 2500).
puesto(caramelos, 0).

% atracciones tranquilas
atraccion(autitosChocadores, chicosYAdultos).
atraccion(laCasaEmbrujada, chicosYAdultos).
atraccion(laberinto, chicosYAdultos).
atraccion(tobogan, soloChicos).
atraccion(calesita, soloChicos).

% atracciones intensas
atraccion(barcoPirata, 14).
atraccion(tazasChinas, 6).
atraccion(simulador3D, 2).

% montañas rusas 
% montaniaRusa(Nombre, GirosInvertidos, Duracion).
montaniaRusa(abismoMortalRecargada, 3, 134).
montaniaRusa(paseoPorElBosque, 0, 45).

% atracciones acuaticas sep a marzo
atraccion(elTorpedoSalpicon).
atraccion(esperoQueHayasTraidoUnaMudaDeRopa).

% modelo persona
% visitante(Nombre, Edad, Dinero, Hambre, Aburrimiento, Grupo).

% grupo viejitos y solos
visitante(eusebio, 80, 3000, 50, 0, viejitos).
visitante(carmela, 80, 0, 0, 25, viejitos).
visitante(mariana, 25, 5000, 10, 5, solo).
visitante(juan, 40, 2000, 30, 15, solo).
visitante(nestor, 50, 5000, 0, 0, solo).

% otros grupos
grupo(lopez).
grupo(promocion23).

% punto 2 
% estadoDeBienestar(Visitante, Estado).

% estados
estadoDeBienestar(Visitante, sienteFelicidadPlena) :-
    visitante(Visitante, _, _, 0, 0, Grupo), 
    Grupo \= solo.

estadoDeBienestar(Visitante, podriaEstarMejor) :-
    visitante(Visitante, _, _, Hambre, Aburrimiento, _), 
    Suma is Hambre + Aburrimiento, 
    Suma >= 1, 
    Suma =< 50.

estadoDeBienestar(Visitante, necesitaEntretenerse) :-
    visitante(Visitante, _, _, Hambre, Aburrimiento, _), 
    Suma is Hambre + Aburrimiento, 
    Suma >= 51, 
    Suma =< 99.

estadoDeBienestar(Visitante, seQuiereIrACasa) :-
    visitante(Visitante, _, _, Hambre, Aburrimiento, _), 
    Suma is Hambre + Aburrimiento, 
    Suma >= 100.

% punto 3 

satisfaceHambre(GrupoFamiliar, Comida) :-
    grupo(GrupoFamiliar), 
    forall(integrante(GrupoFamiliar, Visitante), puedeComer(Visitante, Comida)).
    
puedeComer(Visitante, hamburguesitas) :-
    visitante(Visitante, _, Dinero, Hambre, _, Grupo),
    Grupo \= solo,
    Dinero >= 2000, 
    Hambre < 50.

puedeComer(Visitante, panchitosConPapitas) :-
    visitante(Visitante, Edad, Dinero, _,  _, Grupo), 
    Grupo \= solo,
    Edad =< 13,
    Dinero  >= 1500.

puedeComer(Visitante, lomitoCompleto) :-
    visitante(Visitante, _, Dinero, _,  _, Grupo),
    Grupo \= solo, 
    Dinero >= 1500.

puedeComer(Visitante, caramelos) :-
    visitante(Visitante, _, Dinero, _,  _, _),
    Dinero < 2000,
    Dinero < 1500,
    Dinero < 2500.

integrante(Grupo, Visitante) :-
    visitante(Visitante, _, _, _, _, Grupo).

 % punto 4 
lluviaDeHamburguesas(Visitante, Atraccion) :-
    puedeComer(Visitante, hamburguesitas), 
    atraccion(Atraccion, Coeficiente), 
    Coeficiente > 10.

lluviaDeHamburguesas(Visitante, Atraccion) :-
    puedeComer(Visitante, hamburguesitas), 
    montaniaPeligrosa(Visitante, Atraccion).

lluviaDeHamburguesas(Visitante, tobogan) :-
   puedeComer(Visitante, hamburguesitas).

montaniaPeligrosa(Visitante, Montania) :-
    visitante(Visitante, Edad, _, _, _, _),
    Edad >= 13,
    estadoDeBienestar(Visitante, Estado), 
    Estado \= necesitaEntretenerse,
    cantidadDeGiros(Max),
    montaniaRusa(Montania, Max, _).
    
montaniaPeligrosa(Visitante, Montania) :-
    visitante(Visitante, Edad, _, _, _, _),
    Edad < 13,
    montaniaRusa(Montania, _, Duracion), 
    Duracion > 60. 

cantidadDeGiros(Max) :-
    findall(GirosInvertidos, montaniaRusa(_, GirosInvertidos, _), Giros), 
    max_list(Giros, Max).

% Punto 5 
opcionesDeEntretenimiento(Visitante, Mes, Opcion) :-
    puedeComer(Visitate, Opcion).

opcionesDeEntretenimiento(Visitante, _, Atraccion) :-
    atraccion(Atraccion, Visitante).

opcionesDeEntretenimiento(_, _, Atraccion) :-
    atraccion(Atraccion, Coeficiente).

opcionesDeEntretenimiento(Visitante,_, Montania) :-
    montaniaRusa(Montania, _, _),
    not(montaniaPeligrosa(Visitante, Montania)).

opcionesDeEntretenimiento(_, Mes, Atraccion) :-
    atraccion(Atraccion), % atarccion acuatica
    mesDisponible(Mes).

mesDisponible(septiembre).
mesDisponible(obctubre).
mesDisponible(noviembre).
mesDisponible(diciembre).
mesDisponible(enero).
mesDisponible(febrero).
mesDisponible(marzo).
    

