% https://docs.google.com/document/d/14Yl1bvRpTeZSMc6ZW2JFEo8wsn7WTVQTBqUhiDwbYw0/edit?tab=t.0#heading=h.nobj16s2tioc

% rata(Nombre, Domicilio)
rata(remy, gusteaus). 
rata(emile,chezMilleBar).
rata(django,pizzeriaJeSuis).

% humano(Nombre, Platos, Experiencia)
humano(linguini, ratatouille, 3).
humano(linguini, sopa, 5). 
humano(colette, salmonAsado, 9). 
humano(horst, ensaladaRusa, 8). 

% trabaja(humano, donde)
trabaja(linguini, gusteaus).
trabaja(colette, gusteaus).
trabaja(horst, gusteaus).
trabaja(amelie, cafeDes2Moulins).

% 1 saber si un plato esta en el menu de un restaurante que es cuando alguno de los empleados lo sabe cocinar

menu(UnPlato, UnRestaurante) :-
    trabaja(Empleado, Restaurante), 
    humano(Empleado, Plato, _).

% 2 saber quien cocina bien un determinado plato 
% experiencia > 7 o si tiene tutor a una rata que viva en el lugar donde trabaja
% Amelie es la tutora de Skinner
% remy cocina muy bien cualquier plato que exista

tutor(Empleado, Tutor).

cocinaBien(Empleado, Unplato) :-
    humano(Empleado, Plato, Experiencia), 
    Experiencia > 7.

cocinaBien(Empleado, UnPlato) :-
    tutor(Empleado, Tutor), 
    cocinaBien(Tutor, UnPlato).

cocinaBien(remy, UnPlato) :-
    humano(_, UnPlato, _).


% 3 es chef de un resto cocinan bien todos los platos del muenu 
% o entre todos los platos sabe que sabe cocinar suma 20 de experiencia

esChefDeResto(UnChef, UnRestaurante) :-
    trabaja(UnChef, UnRestaurante), 
    forall(menu(UnPlato, UnRestaurante), cocinaBien(UnChef, UnPlato)).

esChefDeResto(UnChef, UnRestaurante) :-
    trabaja(UnChef, UnRestaurante), 
    esExperimentado(UnChef).

esExperimentado(UnChef) :-
    findall(Experiencia, humano(UnChef,_, Experiencia), Experiencias), 
    sum_list(Experiencias, CantidadDeExperiencia),
    CantidadDeExperiencia >= 20.

% 4 persona encargada de cocinar un plato quien tiene mas experiencia
% si sos la unica que cocina ese plato sos encargado 

esEncargado(UnChef, UnPlato, UnRestaurante) :-
    humano(UnChef, UnPlato, Experiencia),
    trabaja(UnChef, UnRestaurante),
    forall((humano(OtroChef, UnPlato, OtraExperiencia), trabajaEnMismoRestaurante(UnChef, OtroChef)), UnaExperiencia >=OtraExperiencia).

trabajaEnMismoRestaurante(UnChef, OtroChef) :-
    trabaja(UnChef, UnRestaurante), 
    trabaja(OtroChef, UnRestaurante), 
    UnChef \= OtroChef.

% plato (entrada, lista de ing)
% plato (principal, acompañamiento y tiempo)
% plato (postre, calorias)

plato(ensaladaRusa, entrada([papa, zanahoria, arvejas, huevo, mayonesa])).
plato(bifeDeChorizo, principal(pure, 20)).
plato(frutillasConCrema, postre(265)).


% 5 es saludable < 75 calorias 

esSaludable(UnPlato) :-
    plato(Unplato, Categoria), 
    esPlatoSaludable(UnPlato, Calorias).

esPlatoSaludable(UnPlato, Calorias) :-
    calorias >= 75.

calorias(entrada(Ingedientes), calorias) :-
    length(Ingedientes, Cantidad), 
    Calorias is Cantidad * 15.
    
calorias(principal(Guarnicion, Minutos), Calorias) :-
    caloriasGuarnicion(Guarnicion, Cantidad), 
    Calorias is Minutos * 5 + Cantidad.

caloriasGuarnicion(papasFritas, 50).
caloriasGuarnicion(pure, 20).
caloriasGuarnicion(ensalada, 0).

calorias(postre(Calorias), Calorias).

% 6 mayor reputacion si tiene reseña positiva 

critico(antonEgo). 
critico(cormillot). 
critico(martiniano). 
critico(gordonRamsey).  

% criterio comun no tiene ratas

reseniaPositiva(UnCritico, UnRestaurante) ;-
    trabaja(_, UnRestaurante), 
    critico(UnCritico),
    not(rata(_, UnRestaurante)),
    criterioSegun(UnCritico, UnRestaurante).

criterioSegun(antonEgo, UnRestaurante) :-
    esEspecialista(UnRestaurante, UnPlato).

criterioSegun(cormillot, UnRestaurante) :-
    todosLosPlatosSaludables(UnRestaurante, UnPlato).

criterioSegun(martiniano, UnRestaurante) :-
    haySoloUnChef(UnRestaurante).

%-------------------------------------------------------
esEspecialista(UnRestaurante, UnPlato) :-
    forall(trabaja(UnChef, UnRestaurante), cocinaBien(UnChef, UnPlato)).

todosLosPlatosSaludables(UnRestaurante, UnPlato) :-
    forall(plato(UnPlato, Categoria), esSaludable(UnPlato)).

haySoloUnChef(UnRestaurante) :-
    trabaja(UnChef, UnRestaurante), 
    trabaja(OtroChef, UnRestaurante), 
    sonIguales(UnChef, OtroChef).

sonIguales(Persona1, Persona1).