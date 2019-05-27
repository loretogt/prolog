alumno_prode('Garcia','Tejada','Loreto','y16i010').
alumno_prode('Gutierrez','Martin','Maria','y16i017').
alumno_prode('Fernandez','Garcia','Jose Carlos','y16i024').


menor(A,B,Comp,M):-
    functor(X,Comp,2),
    arg(1,X,A),
    arg(2,X,B),
    call(X) -> M is A ;  M is B. 


menor_o_igual(A,B):-
	functor(A,NomA,AriA), 
	functor(B,NomB,AriB),
	((NomA\=NomB -> NomA@<NomB);        %si los nombres son distintos
	((AriA\=AriB -> AriA<AriB));         %si las aridades son distintas
	menor_bucle(A,B,1,AriA)).  

menor_bucle(_,_,N1,N):-
	N1 is N+1,!.

menor_bucle(A,B,N,F):-
	arg(N,A,ValorA),
	arg(N,B,ValorB),
	N1 is N+1,
	((var(ValorA)-> menor_bucle(A,B,N1,F));
	    ((var(ValorB)-> menor_bucle(A,B,N1,F)));
	(ValorA@<ValorB;
	ValorA==ValorB -> menor_bucle(A,B,N1,F))).


lista_hojas([],[]).

lista_hojas([X|Xs],[tree(X,void,void)|Ys]):-
	lista_hojas(Xs,Ys).




