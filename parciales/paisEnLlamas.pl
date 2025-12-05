% tieneFoco(Lugar, tamaño). -> cant de hectareas

/*
ciudad(Poblacion).
pueblo(Poblacion).
campo(Nombre).
*/

tieneFoco(rosario, 20).
tieneFoco(cosquin, 50).
tieneFoco(km607, 300).

lugar(rosario, ciudad(500)).
lugar(coquin, pueblo(20)).
lugar(km607, campo).

% cercanos(Lugar1, Lugar2).
% provinvia(Lugar, Provincia).
% tamaño de foco = cantidad de hectareas 

% Punto 1 

tienenFocosParecidos(Lugar1, Lugar2) :-
    Lugar1 \= Lugar2, 
    tieneFoco(Lugar1, Tamanio1), 
    tieneFoco(Lugar2, Tamanio2), 
    abs(Tamanio1 - Tamanio2) < 5. 

% Punto 2 
/*
tieneFocoGrave(UnLugar) :-
    focoSegun(Lugar).

focoSegun(pueblo(Poblacion)) :-
    tieneFoco(pueblo(Poblacion), Tamanio), 
    Tamanio > 100.

focoSegun(pueblo(Poblacion)) :-
    tieneFoco(pueblo(Poblacion), Tamanio), 
    Tamanio > 20, 
    superPoblado(UnLugar).

superPoblado(UnLugar) :-
    lugar(UnLugar, Poblacion),
    Poblacion > 200.
*/

tieneFocoGrave(UnLugar):-
    tieneFoco(UnLugar, Tamanio),
    Tamanio > 100.

tieneFocoGrave(UnLugar):-
    tieneFoco(UnLugar, Tamanio),
    Tamanio > 20,
    esPoblado(UnLugar).

esPoblado(UnLugar):-
    lugar(UnLugar, ciudad(_)).

esPoblado(UnLugar):-
    lugar(UnLugar, pueblo(Cantidad)),
    Cantidad > 200.

% Punto 3 
buenPronostico(UnLugar) :-
    not(tieneFocoGrave(UnLugar)), 
    % creo que tambien podria ir un forall para que ningun lugar tenga foco
    forall(cercarno(Lugar, _), not(lugarCercanoConFocoGrave(UnLugar))).

lugarCercanoConFocoGrave(UnLugar) :-
    cercarno(UnLugar, _), 
    tieneFocoGrave(UnLugar).

% Punto 4 

provinciaComprometida(UnaProvincia) :-
    provincia(UnaProvincia, _), 
    findall(Lugar, (provincia(Lugar,UnaProvincia), tieneFoco(Lugar, _)), LugaresConFoco), 
    length(LugaresConFoco, Cantidad), 
    Cantidad > 4.

% Punto 5

provinciaAlHorno(UnaProvincia) :-
    provinciaComprometida(UnaProvincia), 
    forall((provincia(Lugar, UnaProvincia), tieneFoco(Lugar, _)), tieneFocoGrave(Lugar)).
    
provinciaAlHorno(UnaProvincia) :-
    provincia(Lugar, UnaProvincia),
    not(lugar(Lugar,_)), 
    not(tieneFoco(Lugar)).









