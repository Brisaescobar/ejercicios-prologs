%https://drive.google.com/file/d/1pNZ5M3IL6xscFUlfCnPEWBlElqsBn1K9/view
% base de conocimiento

% Relaciona al dueño con el nombre del juguete y la cantidad de años que lo ha tenido
duenio(andy, woody, 8).
duenio(andy, buzz, 4).
duenio(andy, jessiee, 2).
duenio(sam, jessie, 3).

% Relaciona al juguete con su nombre
% los juguetes son de la forma:
% deTrapo(tematica)
% deAccion(tematica, partes)
% miniFiguras(tematica, cantidadDeFiguras)
% caraDePapa(partes)

juguete(woody, deTrapo(vaquero)).
juguete(jessie, deTrapo(vaquero)).
juguete(jessiee, deTrapo(vaquero)).
juguete(buzz, deAccion(espacial, [original(casco)])).
juguete(soldados, miniFiguras(soldado, 60)).
juguete(monitosEnBarril, miniFiguras(mono, 50)).
juguete(seniorCaraDePapa,caraDePapa([ original(pieIzquierdo), original(pieDerecho),repuesto(nariz)])).

% Dice si un juguete es raro
esRaro(deAccion(stacyMalibu, 1, [sombrero])).

% Dice si una persona es coleccionista
esColeccionista(sam).

%valorDeFelicidad(Duenio,Valor)

% ----------------------------------------------------------------

% 1a tematica relaciona un juguete y su tematica 
% general 
tematica(UnJuguete, UnaTematica) :-
    juguete(UnJuguete, UnaTematica).

% Por tipo
tematica(UnJuguete, caraDePapa) :-
    juguete(UnJuguete, caraDePapa(_)).

tematica(UnJuguete, Tema) :-
    juguete(UnJuguete, deTrapo(Tema)).

tematica(UnJuguete, Tema) :-
    juguete(UnJuguete, deAccion(Tema, _)).

tematica(UnJuguete, Tema) :-
    juguete(UnJuguete, miniFiguras(Tema, _)).

% 1b es de plastico
esDePlastico(UnJuguete) :-
    juguete(UnJuguete, miniFiguras(_,_)).

esDePlastico(UnJuguete) :-
    juguete(UnJuguete, caraDePapa(_)). 

% 1c es de coleccion un juguete 
esDeColeccion(UnJuguete) :-
    juguete(UnJuguete, deAccion(_,_)).

esDeColeccion(UnJuguete) :-
    juguete(UnJuguete, caraDePapa(_)).

esDeColeccion(UnJuguete) :-
    esJugueteRaro(UnJuguete).

esJugueteRaro(UnJuguete) :-
    juguete(UnJuguete, deTrapo(_)).

% 2 amigo fiel relaciona el dueño con el nombre del juguete que no sea de plasticoque tiene hace mas tiempo
% no se si es totalmente inversible REVISAR 
amigoFiel(UnDuenio, UnJuguete) :-
    not(esDePlastico(UnJuguete)),
    tuvoMaAnios(UnDuenio, UnJuguete).

tuvoMaAnios(UnDuenio, UnJuguete):-
    duenio(UnDuenio, UnJuguete, AniosUnJuguete), 
    duenio(UnDuenio, OtroJuguete, AniosOtroJuguete),
    UnJuguete \= OtroJuguete,
    AniosUnJuguete > AniosOtroJuguete.

% 3 super valioso genera las nombres de la coleccion que tengan sus piezas originales y que no lo tenga un coleccionista
esSuperValioso(UnJuguete) :-
    esDeColeccion(UnJuguete), 
    esOriginal(UnJuguete), 
    duenio(Unduenio, UnJuguete,_),
    noEsColeccionista(Unduenio).


esOriginal(UnJuguete) :-
    juguete(UnJuguete, deAccion(_,[original(_)])),
    juguete(UnJuguete, caraDePapa([original(_)])).


noEsColeccionista(UnDuenio) :-
    not(esColeccionista(UnDuenio)).

% 4 duo dinamico relaciona el dueño y a dos nombres de juguetes que le pertenezcan que hagan buena pareja
% dos juguetes distintos hacen buena pareja si son de la misma tematica 
% woody y buzz son buena pareja 

duoDinamico(Duenio, Juguete1, Juguete2) :-
    duenio(Duenio, Juguete1, _), 
    duenio(Duenio, Juguete2, _), 
    hacenBuenaPareja(Juguete1, Juguete2).

duoDinamico(Duenio, _ , _) :-
    duenio(Duenio, buzz, _), 
    duenio(Duenio, woody, _). 

sonDistintos(Juguete1, Juguete2) :-
    juguete(Juguete1,_),
    juguete(Juguete2,_),
    Juguete1 \= Juguete2.

mismaTematica(Juguete1, Juguete2) :-
    tematica(Juguete1, Tematica1), 
    tematica(Juguete2, Tematica2), 
    sonLoMismo(Tematica1, Tematica2).

sonLoMismo(Tematica, Tematica).

hacenBuenaPareja(Juguete1, Juguete2) :-
    sonDistintos(Juguete1, Juguete2), 
    mismaTematica(Juguete1, Juguete2).

% 5 felicidad relaciona un dueño con la cantidad de felicidad que le otorgan sus jugutes
/*
felicidad(Duenio, FelicidadTotal) :-
    findall(Valor, felicidadPorJuguete(Duenio, Valor), Valores), 
    sum_list(Valores, FelicidadTotal).

felicidadPorJuguete(Duenio, Valor) :-
    duenio(Duenio, Juguete, _),
    juguete(Juguete, miniFiguras(_,Cantidad)),
    Valor is Cantidad * 20.

felicidadPorJuguete(Duenio, Valor):-
    duenio(Duenio, Juguete, _),
    juguete(Juguete, caraDePapa(Piezas)),
    valorSegunPiezas(Piezas, Valor).

valorPieza(original, 5).
valorPieza(repuesto, 8).

valorSegunPiezas(Piezas, Valor) :-
    findall(ValorPieza, (member(Pieza, Piezas), valorPieza(Pieza, Valor)) , Valores),
    sum_list(Valores, Valor).

felicidadPorJuguete(Duenio, 100) :-
    duenio(Duenio, Juguete, _),
    juguete(Juguete, deTrapo(_)).

felicidadPorJuguete(Duenio, 100) :-
    duenio(Duenio, Juguete, _),
    juguete(Juguete, deAccion(_,_)),
    not((esDeColeccion(Juguete),esColeccionista(Duenio))).

felicidadPorJuguete(Duenio, 120) :-
    juguete(Juguete, deAccion(_,_)),
    esDeColeccion(Juguete),
    esColeccionista(Duenio).
*/
% me devuelve cero :( REVISAR 

% 6 puede jugar con relaciona a un duenio con un juguete

puedeJugarCon(Duenio, UnJuguete) :-
    duenio(Duenio, UnJuguete,_),
    juguete(UnJuguete,_).

puedeJugarCon(OtroDuenio, UnJuguete) :-
    duenio(DuenioPrestador, UnJuguete, _),
    puedePrestar(DuenioPrestador, OtroDuenio),
    puedeJugarCon(DuenioPrestador, UnJuguete).

puedePrestar(Duenio, OtroDuenio) :-
cantidadDeJuguetes(Duenio, CantidadDuenio),
cantidadDeJuguetes(OtroDuenio, CantidadOtroDuenio),
CantidadDuenio > CantidadOtroDuenio.

cantidadDeJuguetes(Duenio, Cantidad) :-
findall(UnJuguete, duenio(Duenio, UnJuguete,_), JuguetesDuenio),
length(JuguetesDuenio, Cantidad).

% 7 podria donar relaciona al dueño con la lista de juguetes y cant de felicidad







    


