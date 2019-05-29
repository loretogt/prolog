alumno_prode('Garcia','Tejada','Loreto','y16i010').
alumno_prode('Gutierrez','Martin','Maria','y16i017').
alumno_prode('Fernandez','Garcia','Jose Carlos','y16i024').


menor(A,B,Comp,M):-
    functor(X,Comp,2),  %creas un functor Comp
    arg(1,X,A),         %añades en la primera posicion el elemento A
    arg(2,X,B),         %añades en la primera posicion el elemento A
    call(X) -> M is A ;  M is B.    %llamamos al functor, si da cierto entonces el A el que cumple Comp y es lo que se devuelve en M, sino es B.


menor_o_igual(A,B):-
	functor(A,NomA,AriA),               %sacamos el nombre y la aridad de A
	functor(B,NomB,AriB),               %sacamos el nombre y la aridad de A
	((NomA\=NomB -> NomA@<NomB);        %si los nombres son distintos
	((AriA\=AriB -> AriA<AriB));        %si las aridades son distintas
	menor_bucle(A,B,1,AriA)).           %si los nombres y las aridades son distintas llamamos al predicado auxiliar

menor_bucle(_,_,N1,N):-                 %caso límite en el que el contador a pasado a la aridad de los elementos
	N1 is N+1,!.

menor_bucle(A,B,N,F):-
	arg(N,A,ValorA),                                %sacamos el valor que tiene A el la posicion N
	arg(N,B,ValorB),                                %sacamos el valor que tiene B el la posicion N
	N1 is N+1,                                      %incrementamos en uno el contador
	((var(ValorA)-> menor_bucle(A,B,N1,F));         %si el valor de A es una variable libre llamamos recursivamente al metodo (ya que todo es igual a una var libre)
	    ((var(ValorB)-> menor_bucle(A,B,N1,F)));    %si el valor de B es una variable libre llamamos recursivamente al metodo
	(ValorA@<ValorB;                                %si ninguna de las dos son variables libres comprobamos que A sea menor que b
	ValorA==ValorB -> menor_bucle(A,B,N1,F))).      %si no es menor entonces comprobamos que sean iguales, y si es así llamamos recursivamente al metodo


lista_hojas([],[]).                                 %caso base, en el que las dos listas sean vacias

lista_hojas([X|Xs],[tree(X,void,void)|Ys]):-        %el elemetento cabeza de la primera lita se convierte en tree(cabeza,void,void) en la segunda
	lista_hojas(Xs,Ys).                             %llamamos de forma recursiva con el resto de la lista


hojas_arbol([tree(X,Y,Z)],_,tree(X,Y,Z)):-!.        %caso limite en el que solo tienes un elemento en la lista, y por tanto ese es el Arbol que te piden

hojas_arbol([tree(X,Xizq,Xder),tree(Y,Yizq,Yder)],Comp,Arbol):-                                %si solo te quedan dos elementos en la lista
	menor(X,Y,Comp,M),                                                                         %comprobamos cual es menor cumpliendo la condicion de comp
	(Xizq==void->(hojas_arbol([tree(M,tree(Y,Yizq,Yder),tree(X,Xizq,Xder))],Comp,Arbol))       %si el primer elemento su hijo izquierdo es void, entonces eran elementos impares
	hojas_arbol([tree(M,tree(X,Xizq,Xder),tree(Y,Yizq,Yder))],Comp,Arbol)).                    %sino era un numero par de elementos, y el orden con el que se llama recursivamente cambia

hojas_arbol([tree(X,void,void),tree(Y,Yizq,Yder)|Ys],Comp,Arbol):-          %si tenemos mas de dos elementos de la lista, el primero sus hijos son void
	Yizq\=void,                                                             %pero el segundo elemento no son void (por tanto es el ultimo elemento cuando hay un num impar)
	Yder\=void,
	append([tree(Y,Yizq,Yder)],Ys,Zs),                                      %se concatena el segundo elemento de la lista, con el cuerpo de la lista
	append(Zs,[tree(X,void,void)],Zss),                                     %se concatena a lo obtenido anteriormente el ultimo elemento (el que no tiene par)
	hojas_arbol(Zss,Comp,Arbol).                                            %se llama recursivamente con la nueva lista

hojas_arbol([tree(X,Xizq,Xder),tree(Y,Yizq,Yder)|Ys],Comp,Arbol):-          %caso en el que tiene más de dos elementos y no se trata del que no tiene par
	menor(X,Y,Comp,M),                                                      %comprobamos cual cumple comp, de los dos primeros elementos de la lista
	append(Ys,[tree(M,tree(X,Xizq,Xder),tree(Y,Yizq,Yder))],Z),             % se contatena al resto de la lista, el nuevo tree donde la cabeza es el menor de los hijos
	hojas_arbol(Z,Comp,Arbol).                                              %se llama recursivamente con esta nueva lista creada

