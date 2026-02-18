% punto 1 
% -- personas --
persona(dibu).
persona(messi).
persona(dePaul).
persona(kun).
persona(papu).
persona(scaloni).

% -- roles y preferencias --
parrillero(dibu).
parrillero(scaloni).

comensal(messi).
comensal(dePaul).
comensal(kun).

usaCruz(scaloni).

tienePaciencia(scaloni).

leGusta(messi, asado).
leGusta(dePaul, asado).
leGusta(kun, choripan).

esVegetariano(papu).

trae(papu, ensaladaRusa).
esContundente(ensaladaRusa).

% -- asistencias --
asistencia(dibu, sabado).
asistencia(scaloni, sabado).
asistencia(messi, sabado).
asistencia(papu, sabado).
asistencia(scaloni, domingo).
asistencia(messi, domingo).
asistencia(dePaul, domingo).
asistencia(papu, domingo).
asistencia(kun, lunes).
asistencia(kun, martes).
asistencia(kun, miercoles).
asistencia(kun, jueves).
asistencia(kun, viernes).

haceDieta(Jugador):- fail.

% -- punto 2 --
laEstaPasandoBien(Jugador) :-
    parrillero(Jugador), 
    usaCruz(Jugador), 
    tienePaciencia(Jugador).

laEstaPasandoBien(Jugador) :-
    comensal(Jugador),
    not(haceDieta(Jugador)).

laEstaPasandoBien(Jugador) :-
    comensal(Jugador),
    leGusta(Jugador, asado).

laEstaPasandoBien(Jugador) :- 
    esVegetariano(Jugador), 
    trae(Jugador, ensaladaRusa), 
    esContundente(ensaladaRusa).

todosLaPasanBien(Dia) :-
    asistencia(_, Dia),
    forall(asistencia(Jugador, Dia), laEstaPasandoBien(Jugador)).

% hacer segun tipo para que quede mas limpio 

% -- Punto 3 -- 
asistenciaPerfecta(Jugador) :-
    asistencia(Jugador, sabado),
    asistencia(Jugador, domingo).

esFalluto(Jugador) :-
    persona(Jugador),
    not(asistenciaPerfecta(Jugador)).

% -- Punto 4 -- 
asistenteQueMasAporta(Jugador, Dia) :-
    asistencia(Jugador, Dia), 
    total(Jugador, Dia, Monto), 
    forall((asistencia(OtroJugador, Dia), total(OtroJugador, Dia, OtroMonto)), Monto >= OtroMonto).

total(Jugador, Dia, Monto) :-
    asistencia(Jugador, Dia), 
    dineroSegun(Jugador, Monto).
    
dineroSegun(Jugador, 0) :-
    parrillero(Jugador).

dineroSegun(Jugador, 1000) :-
    leGusta(Jugador, asado).

dineroSegun(Jugador, 800) :-
    leGusta(Jugador, choripan), 
    haceDieta(Jugador).

dineroSegun(Jugador, 700) :-
    leGusta(Jugador, choripan), 
    not(haceDieta(Jugador)).

dineroSegun(Jugador, 500) :-
    esVegetariano(Jugador).
