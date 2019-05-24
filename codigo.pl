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
	NomA\=NomB -> NomA@<NomB;        %si los nombres son distintos
	AriA\=AriB -> AriA<AriB.         %si las aridades son distintas
	
	








