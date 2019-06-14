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
	((NomA\=NomB -> NomA@<NomB);
	((AriA\=AriB -> AriA<AriB));
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


hojas_arbol([tree(X,Y,Z)],_,tree(X,Y,Z)):-!.

hojas_arbol([tree(X,Xizq,Xder),tree(Y,Yizq,Yder)],Comp,Arbol):-
	menor(X,Y,Comp,M),
	(Xizq==void->(hojas_arbol([tree(M,tree(Y,Yizq,Yder),tree(X,Xizq,Xder))],Comp,Arbol));
	hojas_arbol([tree(M,tree(X,Xizq,Xder),tree(Y,Yizq,Yder))],Comp,Arbol)).

hojas_arbol([tree(X,void,void),tree(Y,Yizq,Yder)|Ys],Comp,Arbol):-
	Yizq\=void,
	Yder\=void,
	append([tree(Y,Yizq,Yder)],Ys,Zs),
	append(Zs,[tree(X,void,void)],Zss),
	hojas_arbol(Zss,Comp,Arbol).

hojas_arbol([tree(X,Xizq,Xder),tree(Y,Yizq,Yder)|Ys],Comp,Arbol):-
	menor(X,Y,Comp,M),
	append(Ys,[tree(M,tree(X,Xizq,Xder),tree(Y,Yizq,Yder))],Z),
	hojas_arbol(Z,Comp,Arbol).                                             

ordenacion(void,_,[]):- !.

ordenacion(tree(X,void,void),_,Orden):-
    append([X],Nord,Orden),
    ordenacion(void,_,Nord).

ordenacion(tree(X,Xizq,Xder),Comp,Orden):-
    append([X],Nord,Orden),
    reflotar(tree(X,Xizq,Xder),[],Lista),
    hojas_arbol(Lista,Comp,Arbol),
    ordenacion(Arbol,Comp,Nord).

reflotar(tree(_,void,void),Ref,Lista):-
    crearLista(Ref,Lista),!.

reflotar(tree(X,tree(X,Yizq,Yder),tree(Z,Zizq,Zder)),Ref,Lista):-
    append(Ref,[tree(Z,Zizq,Zder)],NRef),
    reflotar(tree(X,Yizq,Yder),NRef,Lista).

reflotar(tree(X,tree(Y,Yizq,Yder),tree(X,Zizq,Zder)),Ref,Lista):-
    append(Ref,[tree(Y,Yizq,Yder)],NRef),
    reflotar(tree(X,Zizq,Zder),NRef,Lista).

crearLista([],[]):-!.

crearLista([tree(X,void,void)|Xs],[tree(X,void,void)|Ys]):-
    crearLista(Xs,Ys).

crearLista([tree(_,Xizq,Xder)|Xs],Lista):-
    append(Xs,[Xizq],List1),
    append(List1,[Xder],List2),
    crearLista(List2,Lista).

ordenar([],_,[]):-!.

ordenar(Lista,Comp,Orden):-
	lista_hojas(Lista,ListaHojas),
	hojas_arbol(ListaHojas,Comp,Arbol),
	ordenacion(Arbol,Comp,Orden).
	
	
