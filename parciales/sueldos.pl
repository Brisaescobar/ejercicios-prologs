% https://docs.google.com/document/d/1PwMkOFJ6-CtyevoqgfZy0XiirTJIB5apQZgiInUfsjU/edit?tab=t.0#heading=h.odtep4bv0bkg

% punto 1 
% trabajaEn(nombre, departamento).

trabajaEn(kyle, ventas).
trabajaEn(trisha, ventas).
trabajaEn(joshua, ventas).
trabajaEn(ian, logistica).
trabajaEn(sherri, logistica).

%asalartiado(nombre, horas, sueldo).
% persona(nombre, cargo).
% asalariado(horas, sueldo)
% jefe([esclavos], sueldo)

persona(kyle, asalariado(6, 50)).
persona(sherri, asalariado(7, 60)).
persona(gus, asalariado(8, 50)).
persona(ian, jefe([kyle, bob, ginger], 40)).
persona(trisha, jefe([ian, gus],60)).
persona(joshua, independiente(arquitecto,55)). 

promedioDeHoras(6, 45).
promedioDeHoras(7, 60).
promedioDeHoras(8, 80).

esPaganni(UnDepartamento) :-
    forall(trabajaEn(Persona, UnDepartamento), ganaBien(Persona)).

ganaBien(Persona) :-
    persona(Persona, TipoEmpleo),
    ganaBienSegun(TipoEmpleo).
ganaBienSegun(aslariado(Horas, Sueldo)) :-
    promedioDeHoras(Horas,Promedio), 
    Sueldo > Promedio.

ganaBienSegun(jefe(Trabajadores, Sueldo)) :-
    length(Trabajadores, CantidadDeTrabajadores), 
    Sueldo > 20 * CantidadDeTrabajadores.

ganaBienSegun(independiente(arquitecto, _)).

ganaBienSegun(independiente(_, Sueldo)) :-
    Sueldo > 70.

% Punto 3 
%leGustaTrabajar(persona, departamento).

leGustaTrabajar(kyle,ventas).
leGustaTrabajar(kyle,logistica).
leGustaTrabajar(trisha,ventas).
leGustaTrabajar(joshua,ventas).
leGustaTrabajar(sherri, contabilidad).
leGustaTrabajar(sherri, facturacion).
leGustaTrabajar(sherri, cobranzas).

estaEnProblemas(UnDepartamento) :-
    trabajaEn(_, UnDepartamento),
    forall(trabajaEn(Persona, UnDepartamento), not(leGustaTrabajar(Persona, UnDepartamento))).
   

% Punto 4 
/*
reorganizar(Presupuesto, Equipo, PresupuestoSobra).
Presupuesto > PresupuestoSobra.

*/

% equipo ([integrantes], resta).

/*
equipo([kule, trisha], 10).
equipo([kyle, joshua], 45).
equipo([kyle, joshua, ian], 5).
equipo([kyle, ian], 60).
equipo([kyle, ian, sherry], 0).

posiblesEquipos([], []).

posiblesEquipos([_ | RestoEquipo], PosiblesEquipos) :-
    posiblesEquipos(RestoEquipo, PosiblesEquipos).

posiblesEquipos([Equipo | RestoEquipo], [RestoEquipo | PosiblesEquipos]) :-
    posiblesEquipos(RestoEquipo, PosiblesEquipos).

*/

