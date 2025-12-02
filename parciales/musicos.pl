% base de conocimiento -> el parcial de la otra comision 

% punto 1 
cancion(mumbai, 2, 28).
cancion(toroRoto, 3, 7).
cancion(hashtagJetas, 2, 29).
cancion(putita, 3, 49).

musicos(mumbai, [caco, patriel]).
musicos(toroRoto, [patriel, caco, nathyPeluso]).
musicos(hashtagJetas, [caco, patriel]).
musicos(putita, [babasonicos]).

/* Justificacion: elijo la segunda opcion porque estan 
delegados los musicos asi no esta todo en un solo predicado
lo cual la segunda es mas declarativa y expresiva  
y es mas facil de manejar mas adelante
*/

% punto 2
esMusico(Musico) :-
    musicos(_, Musicos), 
    member(Musico, Musicos).

participa(Musico, Cancion) :-
   musicos(Cancion, Musicos), 
   member(Musico, Musicos).

% punto 3 
/* al ser un universo cerrado no esta en la base de conocimiento 
no es necesario agregarlo, cuando se haga la consulta dara false 
y cumple la regla.
*/

% punto 4 
nuncaTocoConPatriYCaco(Musico) :-
    findall(Cancion, participa(Musico, Cancion), Canciones), 
    length(Canciones, 0).

% verifica que el musica nunca participo en ninguna cancion 

nuncaTocoConPatriYCaco(Musico) :-
    esMusico(Musico),
    Musico \= caco,
    Musico \= patriel,
    not((
        participa(Musico, Cancion),
        participa(patriel, Cancion),
        participa(caco, Cancion)
    )).

% verifica que el musico no participa con patriel y caco en una cancion 

% punto 5

sabeDeMusica(Musico) :-
    esMusico(Musico), 
    tieneHitazo(Musico), % se puede delegar o expresar de otra forma 
    findall(Cancion, participa(Musico, Cancion), Canciones), 
    length(Canciones, CantidadDeParticipaciones), 
    CantidadDeParticipaciones >= 2.

tieneHitazo(Musico) :-
    participa(Musico, Cancion), 
    hitazo(Cancion). % no esta definido 

% ----------------------------------------------------

sabeDeMusica(Musico) :-
    esMusico(Musico), 
    participoEnDos(Musico),
    tieneHitazo(Musico).

% delego
participoEnDos(Musico) :-
    esMusico(Musico), 
    participa(Musico, Cancion1), 
    participa(Musico, Cancion2),
    Cancion1 \= Cancion2.

tieneHitazo(Musico) :-
    esMusico(Musico), 
    hitazo(Cancion).

hitazo(Cancion).

% punto 6 

esDiscoCorto(Disco) :-
forall(disco(Disco, Cancion), duraMenosdeTres(Cancion, 3)). % si paso el disco es completamente inversible

duraMenosdeTres(Cancion, Tiempo) :-
    cancion(Cancion, Minutos, Segundos), 
    Minutos < 3. 

disco(Disco, Cancion).


% punto 7 
/* el polimorfismo es cuando un mismo predicado 
puede usarse con distintos tipos de terminos */

/* los terminos que hacen que sea polimorfico es recital, 
   tambien hay logica repetida y se podria expresar de otra forma
*/
% recital(Anio, Tipo).
costo(Teatro, Costo).
cantidadGente(Anio, Festival, Escenario, Cantidad).

recital(2024, estadio(oldBoys, 30000, 30)).
recital(2024, teatro(granRes)).
recital(2024, festival(locaPaliza, eshnaider, 2)).
recital(2025, festival(locaPaliza, brava, 1)).

recaudacion(Anio, Recaudado):-
    recital(Anio, Tipo), 
    recaudadoSegunTipo(Anio, Tipo, Recaudado).

recaudadoSegunTipo(_, estadio(Anio, CantidadDeGente, PrecioDeEntrada), Monto) :-
    Monto is CantidadDeGente * PrecioDeEntrada.

recaudadoSegunTipo(_, teatro(granRes), 10000).

recaudadoSegunTipo(_, teatro(Teatro), Monto) :-
    costo(Teatro, Costo),
    Monto is 100000 - Costo.

recaudadoSegunTipo(Anio, festival(Festival, Escenario, _), Monto) :-
    cantidadGente(Anio, Festival, Escenario, Cantidad),
    Monto is 5000 * Cantidad.

% punto 8 

recital(2012, salaDeEnsayo).

recaudadoSegunTipo(_, salaDeEnsayo, 0).

% punto 9 
invito(caco, emiliaViernes).
invito(caco, tiny).
invito(patriel, hellMusic).
invito(emiliaViernes, marioBecerro).
invito(emiliaViernes, cuqui).
invito(marioBecerro, gRey).

inivitadosPor(UnaPersona, OtraPersona) :-
    invito(UnaPersona, OtraPersona).

inivitadosPor(UnaPersona, OtraPersona) :-
    invito(UnaPersona, TerceraPersona), 
    inivitadosPor(TerceraPersona, OtraPersona).

cantidadDeInvitados(Persona, Cantidad) :-
    findall(OtraPersona, inivitadosPor(Persona,OtraPersona), Invitados),
    length(Invitados, Cantidad).

