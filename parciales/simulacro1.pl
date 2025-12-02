% Varios cambios xd
persona(Nombre, Edad, Genero).
gustos(Persona, [Gustos]).
disgustos(Persona, [Disgustos]).
edadDeInteres(Persona, EdadMinima, EdadMaxima).
generoDeInteres(Persona, Generos).
indiceDeAmor(Persona, OtraPersona, Indice).

% Perfil incompleto 
perfilIncompleto(Persona) :-
    gustos(Persona, Gustos),
    length(Gustos, CantidadDeGustos), 
    CantidadDeGustos < 5, 
    disgustos(Disgustos, CantidadDeDisgustos),
    CantidadDeDisgustos < 5.

perfilIncompleto(Persona) :-
    persona(_, Edad, _),
    Edad < 18.

% Es Alma libre 

esAlmaLibre(Persona) :-
    generoDeInteres(Persona, Generos),
    forall(persona(_, _, Genero), member(Genero, Generos)).

esAlmaLibre(Persona) :-
    edadDeInteres(Persona, EdadMinima, EdadMaxima),
    EdadMaxima - EdadMinima > 30.

% Quiere la herencia

quiereLaHerencia(Persona) :-
    persona(_, Edad, _),
    edadDeInteres(Persona, EdadMinima, _), 
    Edad >= EdadMinima + 30.

% Es indeaeable

esIndeseable(Persona) :-
    not(esPretendiente(Persona,_)).

% Es pretendiente 
esPretendiente(Persona, Pretendiente) :-
    persona(Persona, _, _),
    persona(Pretendiente, _, _),
    coincideGenero(Persona, Pretendiente),
    coincideEdad(Persona, Pretendiente),
    coincideGustos(Persona, Pretendiente).

% Delego las condiciones
coincideGenero(Persona, Pretendiente) :-
    persona(Persona, _, Genero),
    generoDeInteres(Pretendiente, Generos),
    member(Genero, Generos).

coincideEdad(Persona, Pretendiente) :-
    persona(Persona, Edad, _),
    edadDeInteres(Pretendiente, EdadMinima, EdadMaxima),
    Edad >= EdadMinima,
    Edad =< EdadMaxima.

coincideGustos(Persona, Pretendiente) :-
    gustos(Persona, GustosPersona),
    gustos(Pretendiente, GustosPretendiente),
    member(GustosPersona, GustosPretendiente).

% Hay match 
hayMatch(Persona1, Persona2) :-
    esPretendiente(Persona1, Persona2),
    esPretendiente(Persona2, Persona1).

% triangulo amoroso
trianguloAmoroso(Persona1, Persona2, Persona3) :-
    esPretendientePeroNoHayMach(Persona1, Persona2),
    esPretendientePeroNoHayMach(Persona3, Persona1),
    esPretendientePeroNoHayMach(Persona2, Persona3).
       
esPretendientePeroNoHayMach(Persona1,Persona2) :-
    esPretendiente(Persona1, Persona2),
    not(hayMatch(Persona1, Persona2)).

% Son el uno para el otro
sonElUnoParaElOtro(Persona1, Persona2) :-
    hayMatch(Persona1, Persona2),
    noHayGustoQueDisguste(Persona1, Persona2).

noHayGustoQueDisguste(Persona1, Persona2) :-
    noHayDisgustos(Persona1, Persona2), 
    noHayDisgustos(Persona2, Persona1).

noHayDisgustos(Persona1, Persona2) :-
    gustos(Persona1, GustosPersona1), 
    disgustos(Persona2, DisgustosPersona2),
    forall(gustos(Persona1, GustosPersona1), not(disgustos(Gustos, DisgustosPersona2))).

% Indice de amor 

promedioDeIndiceDeAmor(Persona1, Persona2, Promedio) :-
    findall(Valor, indiceDeAmor(Persona1, Persona2, Valor), Valores),
    sum_list(Valores, Suma), 
    length(Valores, Cantidad),
    Promedio is Suma / Cantidad.

% mas del doble

masDelDoble(Numero1, Numero2) :-
    Doble is Numero1 * 2, 
    Doble < Numero2.

masDelDoble(Numero1, Numero2) :-
    Doble is Numero2 * 2,
    Doble < Numero1.

% desbalance 

desbalance(Persona1, Persona2) :-
    promedioDeIndiceDeAmor(Persona1, Persona2, Promedio1),
    promedioDeIndiceDeAmor(Persona2, Persona1, Promedio2),
    masDelDoble(Promedio1, Promedio2).

% ghostea 

ghostea(Persona1, Persona2) :-
    leEscribioPeroNoResponde(Persona1, Persona2).
    
leEscribioPeroNoResponde(Persona, OtraPersona) :-
    indiceDeAmor(Persona, OtraPersona, _),
    not(indiceDeAmor(OtraPersona, Persona, _)).
