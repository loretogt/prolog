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
	(Xizq==void->(hojas_arbol([tree(M,tree(Y,Yizq,Yder),tree(X,Xizq,Xder))],Comp,Arbol));       %si el primer elemento su hijo izquierdo es void, entonces eran elementos impares
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

ordenacion(void,_,[]):- !.			%caso base del metodo

ordenacion(tree(X,void,void),_,Orden):-		%caso en el que tenemos el ultimo nodo
    append([X],Nord,Orden),			%añadimos este elemento a la lista
    ordenacion(void,_,Nord).			%llamamos al metodo ordenacion una ultima vez con void para terminar el metodo 

ordenacion(tree(X,Xizq,Xder),Comp,Orden):-	%caso en el que no es el ultimo nodo 
    append([X],Nord,Orden),			%añadimos la raiz del arbol a la lista resultado (ya que es el menor elemento )
    reflotar(tree(X,Xizq,Xder),[],Lista),	%llamamos al metodo auxiliar reflotar
    hojas_arbol(Lista,Comp,Arbol),		%llamamos a hojas arbol con el arbol principal sin el nodo con el que coincide la raiz 
    ordenacion(Arbol,Comp,Nord).		%realizamos la recursividad 

reflotar(tree(_,void,void),Ref,Lista):-		%caso base
    crearLista(Ref,Lista),!.			%llamamos al metodo auxiliar crearLista

reflotar(tree(X,tree(X,Yizq,Yder),tree(Z,Zizq,Zder)),Ref,Lista):-	%Caso en el que la raiz coincide con el hijo izquierdo 
    append(Ref,[tree(Z,Zizq,Zder)],NRef),				%añadimos a la lista Ref(lista auxiliar) el hijo derecho
    reflotar(tree(X,Yizq,Yder),NRef,Lista).				%llamamos recursivamente con el hijo izquierdo y la nueva lista creada en el paso anterior 

reflotar(tree(X,tree(Y,Yizq,Yder),tree(X,Zizq,Zder)),Ref,Lista):-	%Caso en el que la raiz coincide con el hijo derecho
    append(Ref,[tree(Y,Yizq,Yder)],NRef),				%añadimos a la lista Ref(lista auxiliar) el hijo izquierdo 
    reflotar(tree(X,Zizq,Zder),NRef,Lista).				%llamamos recursivamente con el hijo derecho y la nueva lista creada en el paso anterior

crearLista([],[]):-!.	%caso base 

crearLista([tree(X,void,void)|Xs],[tree(X,void,void)|Ys]):-	%caso en el que en ambas listas coincide el mismo nodo y este es un nodo con hijos
    crearLista(Xs,Ys).						%llamada recursiva	

crearLista([tree(_,Xizq,Xder)|Xs],Lista):-	%caso en el que no tenemos un nodo sin hijos
    append(Xs,[Xizq],List1),			%añadimos la parte izquierda a la primera lista
    append(List1,[Xder],List2),			%añadimos la parte derecha a la primera lista
    crearLista(List2,Lista).			%llamada recursiva 

ordenar([],_,[]):-!.		%caso base 

ordenar(Lista,Comp,Orden):-
	lista_hojas(Lista,ListaHojas),		%llamamos a lista_hojas para crear una lista de hojas a partir de la lista dada
	hojas_arbol(ListaHojas,Comp,Arbol),	%llamamos a hojas_arbol para crear el arbol a partir de las hojas obtenidas anteriormente
	ordenacion(Arbol,Comp,Orden).		%finalmente llamamos a ordenacion para obtener la lista ordenada 
	
