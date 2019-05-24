alumno_prode('Garcia','Tejada','Loreto','y16i010').
alumno_prode('Gutierrez','Martin','Maria','y16i017').
alumno_prode('Fernandez','Garcia','Jose Carlos','y16i024').
 
nat(0). %numeros naturales a partir de 0
nat(s(X)) :-
	nat(X).

menor_igual(0,0).
menor_igual(0,s(X)):-nat(X).
menor_igual(s(X),s(Y)):- menor_igual(X,Y).

menor_que(0,s(X)):-nat(X).
menor_que(s(X),s(Y)):- menor_que(X,Y).

sumaAltura(0,X,X).
sumaAltura(s(X),T,s(A)):-
	sumaAltura(X,T,A).

recorrerColor(C,[pieza(_,_,_,C)|_]).


recorrerColor(C,[pieza(_,_,_,Yc)|Yz]):-	
	C\=Yc,
	recorrerColor(C,Yz).

par(0).
par(s(s(X))):-
	par(X).

numeroClavos([],X):-
	par(X).

numeroClavos([X|Y],Z):-
	color(X),
	numeroClavos(Y,s(Z)).

numeroClavos([b|Y],Z):-
	numeroClavos(Y,Z).


recorrerClavos([],[],X,Y):-
	menor_que(X,Y).
recorrerClavos([b|Y],[b|T],Z,W):-
	recorrerClavos(Y,T,Z,W).
recorrerClavos([b|Y],[U|T],Z,W):-
	color(U),
	recorrerClavos(Y,T,Z,s(W)).
recorrerClavos([X|Y],[b|T],Z,W):-
	color(X),
	recorrerClavos(Y,T,s(Z),W).
recorrerClavos([X|Y],[U|T],Z,W):-
	color(X),
	color(U),
	recorrerClavos(Y,T,s(Z),s(W)).
	
color(r).
color(a).
color(v).
color(am).

esTorre([pieza(_,_,_,C)]):-
	color(C).

esTorre([pieza(Xs,_,Zs,Cs),pieza(Xt,_,Zt,Ct)|Xl]):-
	color(Cs), color(Ct),
	menor_igual(Xs,Xt),
	menor_igual(Zs,Zt),
	esTorre([pieza(Xt,_,Zt,Ct)|Xl]).

alturaTorre([],0).	
alturaTorre([(pieza(X,Y,Z,C))|Xs],A):-
	esTorre([(pieza(X,Y,Z,C))|Xs]),
	sumaAltura(Y,T,A),
	alturaTorre(Xs,T).

coloresTorre([],[]).
coloresTorre([pieza(X,Y,Z,C)|Xs],[C|Cs]) :-
	esTorre([pieza(X,Y,Z,C)|Xs]),
	coloresTorre(Xs,Cs).
	

coloresIncluidos([],[pieza(Xt,Yt,Zt,Ct)|Tt]):-
	esTorre([pieza(Xt,Yt,Zt,Ct)|Tt]).

coloresIncluidos([pieza(Xs,Ys,Zs,Cs)|Ts],[pieza(Xt,Yt,Zt,Ct)|Tt]):-
	esTorre([pieza(Xs,Ys,Zs,Cs)|Ts]),
	esTorre([pieza(Xt,Yt,Zt,Ct)|Tt]),
	recorrerColor(Cs,[pieza(Xt,Yt,Zt,Ct)|Tt]),
	coloresIncluidos(Ts,[pieza(Xt,Yt,Zt,Ct)|Tt]).

esEdificioPar([]).
esEdificioPar([[X|Xs]|Ys]):-
	numeroClavos([X|Xs],0),
	esEdificioPar(Ys).


esEdificioPiramide([[_|_]|[]]).
esEdificioPiramide([[X|Xs],[Y|Ys]|Zt]):-
	recorrerClavos([X|Xs],[Y|Ys],0,0),
	esEdificioPiramide([[Y|Ys]|Zt]).
