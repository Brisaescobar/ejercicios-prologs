% base de conocimiento 
% dias y horaios 

atiende(dodain, lunes, 9, 15).
atiende(dodain, miercoles, 9, 15).
atiende(dodain, viernes, 9, 15).

atiende(lucas, martes, 10, 20).

atiende(juanC, sabados, 18, 22).
atiende(juanC, domingos, 18, 22).

atiende(juanFdS, jueves, 10, 20).
atiende(juanFdS, viernes, 12, 20).

atiende(leoC, lunes, 14, 18).
atiende(leoC, miercoles, 14, 18).

atiende(martu, miercoles, 23, 24).

% Punto 1
atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(dodain, Dia, HorarioInicio, HorarioFinal).

atiende(vale, Dia, HorarioInicio, HorarioFinal):-
    atiende(juanC, Dia, HorarioInicio, HorarioFinal).

% Punto 2
quienAtiende(Persona, Dia, Horario) :-
    atiende(Persona, Dia, HorarioInicial, HorarioFinal),
    between(HorarioInicial, HorarioFinal, Horario). %  between entre valores 

% Punto 3 

forverAlone(Dia, Persona) :-
    quienAtiende(Persona, Dia, Horario),
    not((quienAtiende(OtraPersona, Dia, Horario), Persona \= OtraPersona)).

% Punto 4 
% falta seguir con este y el 5 
% posibilidadesDeAtencion(Persona, Dia, Horario).

    
    



