% PUNTO 1 
% vive (nombre, propiedad(atributos), zona)

vive(juan, casa(120),almagro).
vive(fer, casa(110), flores).
vive(nico, departamento(3, 2), almagro).
vive(alf, departamento(3, 1), almagro).
vive(vale, departamento(4, 1),flores).
vive(julian, loft(2000), almagro).

% vive(rocio, casa(90)). -> se quiere mudar

% PUNTO 2   

esCopado(UnaPersona) :-
    vive(UnaPersona, Propiedad, _ ),
    esCopadoSegun(Propiedad, _).
      
esCopadoSegun(casa(Metros), Metros) :-
  Metros > 100.
  
esCopadoSegun(departamento(CantidadDeAmbientes, _),CantidadDeAmbientes) :-
    CantidadDeAmbientes > 3.

esCopadoSegun(departamento(_, CantidadDeBanios), CantidadDeBanios) :-
    CantidadDeBanios > 1.

esCopadoSegun(loft(Anio), Anio) :-
    Anio > 2015.

% PUNTO 3

barrioCaro(UnBarrio) :-
    vive(Persona, UnaPropiedad, UnBarrio), 
    forall(vive(Persona, UnaPropiedad, UnBarrio), not(esBarata(UnaPropiedad))).
    
esBarata(UnaPropiedad) :-
    esBarataSegun(UnaPropiedad, _).

esBarataSegun(loft(Anio), Anio) :-
    Anio < 2005.

esBarataSegun(casa(Metros), Metros) :-
    Metros < 90.

esBarataSegun(departamento(Ambientes, _), Ambientes) :-
    Ambientes < 2.

% PUNTO 4
tasacion(juan, 150000).
tasacion(nico, 80000).
tasacion(alf, 75000).
tasacion(julian, 140000).
tasacion(vale, 95000).
tasacion(fer, 60000).

/* queremos comprar con una cantidad de plata
y saber cuanto nos quedaria queremos comprar siempre 
al menos una propiedad la plata es un argumento no inversble*/

comprarPropiedad(Persona, PosiblesPropiedades, DineroRestante) :-
    findall(Propiedad, vive(Persona, Propiedad, _), Propiedades),
    posiblesPropiedades(Propiedades, Dinero, PosiblesPropiedades), % sublista
    findall(Valor, member(Propiedad, PosiblesPropiedades), tasacionDe(Propiedad, Valor), Valores),
    sumlist(Valores, Tasacion),
    DineroRestante is Dinero - Tasacion.

tasacionDe(Propiedad, Valor) :-
    vive(Persona, Propiedad, _), 
    tasacion(Persona, Valor).

posiblesPropiedades([], _ , []).

posiblesPropiedades([Propiedad | Propiedades], Dinero, [Propiedad | Posibles]) :-
    tasacionDe(Propiedad, Valor), 
    Dinero > Valor, 
    DineroRestante is Dinero - Valor, 
    posiblesPropiedades(Propiedades, DineroRestante, Posibles).

posiblesPropiedades([_ | Propiedades], Dinero, Posibles) :-
    posiblesPropiedades(Propiedades, Dinero, Posibles).
