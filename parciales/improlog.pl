% base de concocimiento 
% integrantes 
integrante(sophieTrio, sophie, violin).
integrante(sophieTrio, santi, guitarra).
integrante(vientosDelEste, lisa, saxo).
integrante(vientosDelEste, santi, voz).
integrante(vientosDelEste, santi, guitarra).
integrante(jazzmin, santi, bateria).

% nivel que tiene 
nivelQueTiene(sophie, violin, 5).
nivelQueTiene(santi, guitarra, 2).
nivelQueTiene(santi, voz, 3).
nivelQueTiene(santi, bateria, 4).
nivelQueTiene(lisa, saxo, 4).
nivelQueTiene(lore, violin, 4).
nivelQueTiene(luis, trompeta, 1).
nivelQueTiene(luis, contrabajo, 4).

% instrumentos 
instrumento(violin, melodico(cuerdas)).
instrumento(guitarra, armonico).
instrumento(bateria, ritmico).
instrumento(saxo, melodico(viento)).
instrumento(trompeta, melodico(viento)).
instrumento(contrabajo, armonico).
instrumento(bajo, armonico).
instrumento(piano, armonico).
instrumento(pandereta, ritmico).
instrumento(voz, melodico(vocal)).

/*
integrante(Grupo, Persona, InstrumentoDelIntegrante).
nivelQueTiene(Persona, Instrumento, Nivel). % nivel de improvisacion (1-5)
instrumento(Instrumento, Tipo). % tipo = Cuerdas, viento, etc.
*/

% Punto 1

tieneBuenaBase(Grupo) :-
    integrante(Grupo, PersonaQueTocaRitmico, InstrumentoRitimico),
    integrante(Grupo, PersonaQueTocaArmonico, InstrumentoArmonico),
    PersonaQueTocaArmonico \= PersonaQueTocaRitmico,
    instrumento(InstrumentoRitimico, ritmico),
    instrumento(InstrumentoArmonico, armonico).

% Punto 2 

seDestaca(PersonaDestacada, Grupo) :-
nivelConElQueToca(PersonaDestacada, Grupo, Nivel),
forall((nivelConElQueToca(OtraPersona, Grupo, OtroNivel), OtraPersona \= PersonaDestacada), Nivel >=  OtroNivel + 2 ).

nivelConElQueToca(Persona, Grupo, Nivel) :-
    integrante(Grupo, Persona, Instrumento),
    nivelQueTiene(Persona, Instrumento, Nivel). 

% Punto 3 

grupo(vientosDelEste, bigBand).
grupo(sophieTrio, formacion([contrabajo, guitarra, violin])).
grupo(jazzmin, formacion([bateria, bajo, trompeta, piano, guitarra])).

% Punto 4

hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, bigBand),
    esDeViento(Instrumento),
    not(alguienTocaEseInstrumento(Grupo, Instrumento)).

hayCupo(Grupo, Instrumento) :-
    grupo(Grupo, TipoDeGrupo),
    TipoDeGrupo \= bigBand,
    sirveInstrumento(TipoDeGrupo, Instrumento),
    not(alguienTocaEseInstrumento(Grupo, Instrumento)).
    
alguienTocaEseInstrumento(Grupo, Instrumento) :-
    integrante(Grupo, _, Instrumento).

esDeViento(Instrumento) :-
    instrumento(Instrumento, melodico(viento)).

sirveInstrumento(bigBand, Instrumento) :-
    esDeViento(Instrumento).
sirveInstrumento(bigBand, bateria).
sirveInstrumento(bigBand, bajo).
sirveInstrumento(bigBand, piano).    

sirveInstrumento(formacion(InstrumentosBuscados), Instrumento) :-
    member(Instrumento, InstrumentosBuscados).

% Punto 5

puedeIncorporarse(Grupo, Persona, Instrumento) :-
    hayCupo(Grupo, Instrumento), 
    grupo(Grupo, TipoDeGrupo),
    nivelQueTiene(Persona, Instrumento, Nivel),
    not(alguienTocaEseInstrumento(Grupo, Instrumento)),
    nivelMinimo(TipoDeGrupo, NivelEsperado),
    Nivel >= NivelEsperado.

nivelMinimo(formacion(Instrumentos), NivelMinimo) :-
    length(Instrumentos, CantidadDeInstrumentos), 
    NivelMinimo is 7 - CantidadDeInstrumentos.

nivelMinimo(bigBand, 1).

% Punto 6 

seQuedoEnBanda(Persona) :-
not(integrante(Grupo, _,_)),
not(nivelQueTiene(Persona,_,_)),
not(puedeIncorporarse(Grupo, Persona, _)).

% Punto 7 

puedenTocar(Grupo) :-
    grupo(Grupo, bigBand),
    tieneBuenaBase(Grupo),
    findall(Persona, ((integrante(Grupo, Persona, Instrumento), esDeViento(Instrumento))), Personas),
    length(Personas, CantidadDePersonas), 
    CantidadDePersonas >= 5.

puedenTocar(Grupo) :-
grupo(Grupo, formacion(Instrumentos)),
forall(member(Instrumento, Instrumentos), alguienTocaEseInstrumento(Grupo, Instrumento)).

