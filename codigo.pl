alumno_prode('Garcia','Tejada','Loreto','y16i010').
alumno_prode('Gutierrez','Martin','Maria','y16i017').
alumno_prode('Fernandez','Garcia','Jose Carlos','y16i024').
 

natural(s(0)). %numeros naturales a partir de 1
natural(s(X)) :-
	natural(X).

nat(0). %numeros naturales a partir de 0
nat(s(X)) :-
	nat(X).

menor_igual(0,0).
menor_igual(0,s(X)):-nat(X).
menor_igual(s(X),s(Y)):- menor_igual(X,Y).

appends([],Ys,Ys).
appends([X|Xs],Ys,[X|Zs]):-
	appends(Xs,Ys,Zs).

recorrerColor(C,[pieza(_,_,_,C)|_]).


recorrerColor(C,[pieza(_,_,_,Yc)|Yz]):-	
	C\=Yc,
	recorrerColor(C,Yz).

par(0).
par(s(s(X))):-
	par(X).

numeroClavos([],X):-
	par(X).

numeroClavos([b|Y],Z):-
	numeroClavos(Y,Z).

numeroClavos([X|Y],Z):-
	color(X),
	numeroClavos(Y,s(Z)).

	
color(r).
color(a).
color(v).
color(am).

%Creacion de pieza
%pieza(X,Y,Z,color(C)).

esTorre([pieza(X,Y,Z,C)]):-
	natural(X),
	natural(Y),
	natural(Z),
	color(C).

esTorre([pieza(Xs,Ys,Zs,Cs),pieza(Xt,Yt,Zt,Ct)|Xl]):-
	natural(Xs), natural(Ys), natural(Zs), color(Cs),
	natural(Xt), natural(Yt), natural(Zt), color(Ct),
	menor_igual(Xs,Xt),
	menor_igual(Zs,Zt),
	esTorre([pieza(Xt,Yt,Zt,Ct)|Xl]).

alturaTorre([pieza(X,Y,Z,C)],s(0)):-
	esTorre([pieza(X,Y,Z,C)]).

alturaTorre([(pieza(X,Y,Z,C))|Xs],s(A)):-
	esTorre([(pieza(X,Y,Z,C))|Xs]),
	alturaTorre(Xs,A).

coloresTorre([pieza(X,Y,Z,C)],[C]):-
		esTorre([pieza(X,Y,Z,C)]).
	
coloresTorre([pieza(X,Y,Z,C)|Xs],[C|Cs]) :-
	esTorre([pieza(X,Y,Z,C)|Xs]),
	coloresTorre(Xs,Cs).
	

coloresIncluidos([pieza(Xs,Ys,Zs,Cs)],[pieza(Xt,Yt,Zt,Ct)|Tt]):-
	esTorre([pieza(Xs,Ys,Zs,Cs)]),
	esTorre([pieza(Xt,Yt,Zt,Ct)]),
	recorrerColor(Cs,[pieza(Xt,Yt,Zt,Ct)|Tt]).

coloresIncluidos([pieza(Xs,Ys,Zs,Cs)|Ts],[pieza(Xt,Yt,Zt,Ct)|Tt]):-
	esTorre([pieza(Xs,Ys,Zs,Cs)|Ts]),
	esTorre([pieza(Xt,Yt,Zt,Ct)|Tt]),
	recorrerColor(Cs,[pieza(Xt,Yt,Zt,Ct)|Tt]),
	coloresIncluidos(Ts,[pieza(Xt,Yt,Zt,Ct)|Tt]).

esEdificioPar([[X|Xs]]):-
	numeroClavos([X|Xs],0).
esEdificioPar([[X|Xs]|Ys]):-
	numeroClavos([X|Xs],0),
	esEdificioPar(Ys).
