% https://drive.google.com/file/d/1x4X-0AfaKK3Zv-twZfsviXRlH6Xg2Oxt/view

% vaquitasDeSanAntonio(peso)
% cucarachas(tamaño, peso)
% hormigas(peso) -> siempre lo mismo

% comio(Personaje, Bicho)
comio(pumba, vaquitasDeSanAntonio(gervasia, 3)).
comio(pumba, hormiga(federica)).
comio(pumba, hormiga(tuNoEresLaReina)).
comio(pumba, cucaracha(ginger, 15, 6)).
comio(pumba, cucaracha(erikElRojo, 25, 70)).

comio(timon, vaquitasDeSanAntonio(romualdam, 4)).
comio(timon, cucaracha(gimeno, 12, 8)).
comio(timon, cucaracha(cucurucha, 12, 5)).

comio(simba, vaquitasDeSanAntonio(remeditos, 4)).
comio(simba, hormiga(schwartzenegger)).
comio(simba, hormiga(niato)).
comio(simba, hormiga(lula)).
comio(shenzi,hormiga(conCaraDeSimba)).

pesoHormiga(2).

% peso(Personaje, Peso)
peso(pumba, 100).
peso(timon, 50).
peso(simba, 200).
peso(scar, 300).
peso(shenzi, 400).
peso(banzai, 500).

% -- Punto 1 -- 
% a 
cucarachaJugosita(cucaracha(Nombre, Tamanio, Peso)) :-
    comio(_, cucaracha(Nombre, Tamanio, Peso)),
    comio(_, cucaracha(OtroNombre, Tamanio, OtroPeso)), 
    Nombre \= OtroNombre,
    Peso > OtroPeso.

% b 
hormigofilico(Personaje) :-
    comio(Personaje, hormiga(Hormiga1)), 
    comio(Personaje, hormiga(Hormiga2)), 
    Hormiga1 \= Hormiga2.

% c
cucarachofobico(Personaje) :-
    peso(Personaje, _),
    not(comio(Personaje, cucaracha(_, _, _))).

% d -> poodria hacer comioSegun
/*
picaron(Personaje) :-
    comio(Personaje, cucaracha(Nombre, Tamanio, Peso)), 
    cucarachaJugosita(cucaracha(Nombre, Tamanio, Peso)).

picaron(Personaje) :-
    comio(Personaje, vaquitasDeSanAntonio(remeditos, _)).
para no repetir logica
*/

picaron(Personaje) :-
    peso(Personaje, _),
    comioSegun(Personaje).

picaron(pumba).

% comio segun 
comioSegun(Personaje) :-
    comio(Personaje, Cucaracha), 
    cucarachaJugosita(Cucaracha).

comioSegun(Personaje) :-
    comio(Personaje, vaquitasDeSanAntonio(remeditos, _)).

listaDePicarones(Lista) :-
    findall(Personaje, picaron(Personaje), Lista).

% agrego mas personajes scar y las hienas 
persigue(scar, timon).
persigue(scar, pumba).
persigue(shenzi, simba).
persigue(shenzi, scar).
persigue(banzai, timon).
persigue(scar, mufasa).

% -- Punto 2 -- 
% a
cuantoEngorda(Personaje, Cantidad) :-
    peso(Personaje, _),
    findall(PesoBicho, (comio(Personaje, Algo), pesoSegun(Algo, PesoBicho)), ListaDepeso), 
    sumlist(ListaDepeso, Cantidad).

% Peso segun 
pesoSegun(cucaracha(_,_, Peso),Peso).

pesoSegun(vaquitasDeSanAntonio(_, Peso), Peso).

pesoSegun(hormiga(_), Peso) :-
    pesoHormiga(Peso).

pesoSegunPersonaje(Personaje, Peso) :-
    peso(Personaje, Peso).

% b 
cuantoEngorda1(Personaje, Total) :-
    peso(Personaje,_),
    cuantoEngorda(Personaje, EngordaBichos),
    findall(PesoVictima, (persigue(Personaje, Victima), pesoSegunPersonaje(Victima, PesoVictima)), PesosVictimas),
    sumlist(PesosVictimas, SumaVictimas),
    Total is EngordaBichos + SumaVictimas.

% c 
/*
cuantoEngorda2(Personaje, Total) :-
    peso(Personaje, _), 
    cuantoEngorda(Personaje, EngordaBichos), 
    findall(PesoVictimaTotal, (persigue(Pesonaje, Victima), 
    pesoSegun(Victima, PesoOriginal),cuantoEngorda2(Victima, EngordaVictima), 
    PesoVictimaTotal is PesoOriginal + EngordaVictima), ListaPesosVictima),
    sumlist(PesosVictimas, SumaVictimas), 
    Total is EngordaBichos + SumaVictimas.
% un choclazo no se no lo probe 
*/

cuantoEngorda2(Personaje, Cantidad) :-
    persigue(Personaje, _), 
    findall(PesoPresa, (persigue(Personaje, Presa), pesoSegun(Presa, PesoPresa)), ListaPresas),
    sumlist(ListaPresas, TotalPresas), 
    findall(PesoBicho, (persigue(Personaje, Presa), comio(Presa, Bicho), pesoSegun(Bicho, PesoBicho)), ListaBichos),
    sumlist(ListaBichos, TotalBichos),
    Cantidad is TotalPresas + TotalBichos.

% ---------------------------------------------
% es lo mismo cuanto engorda 2 y 3 solo que 3 
% el 3 es mas declarativo y delege 

cuantoEngorda3(Personaje, Cantidad) :-
    peso(Personaje, _),
    engordaPorPresas(Personaje, TotalPresas),
    engordaPorBichosDePresas(Personaje, TotalBichos),
    Cantidad is TotalPresas + TotalBichos.

engordaPorPresas(Personaje, TotalPresas) :-
    findall(PesoPresa, (persigue(Personaje, Presa), peso(Presa, PesoPresa)), ListaPresas),
    sumlist(ListaPresas, TotalPresas).

engordaPorBichosDePresas(Personaje, TotalBichos) :-
    findall(EngordaPresa, (persigue(Personaje, Presa), cuantoEngorda(Presa, EngordaPresa)), ListaEngorda),
    sumlist(ListaEngorda, TotalBichos).

% -- Punto 3 -- 
adora(Personaje, OtroPersonaje) :-
    peso(Personaje, _), 
    peso(OtroPersonaje, _), 
    Personaje \= OtroPersonaje, 
    not(comio(Personaje, OtroPersonaje)), 
    not(persigue(Personaje, OtroPersonaje)).

esElRey(Personaje) :-
    peso(Personaje, _), 
    findall(Alguien, persigue(Alguien, Personaje), Lista), 
    length(Lista, 1), 
    forall((peso(Otro,_), Otro \= Personaje), adora(Otro, Personaje)).