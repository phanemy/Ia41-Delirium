:- module( a_star1, [
	a_star/7,
	sortList/2,
	heuristie/4
] ).
:- use_module(library(lists)).

% predicat afin de savoir si une case est un obstacle ou non
isObstacle(CGE, T) :- CGE =:= 1, isObstacle1(T).
isObstacle(CGE, T) :- CGE =:= 0, isObstacle1(T).
isObstacle(CGE, T) :- CGE =:= 0, isObstacleExit(T).

isObstacleExit(21).
isObstacle1(3).
isObstacle1(4).
isObstacle1(5).
isObstacle1(6).
isObstacle1(7).

isObstacle1(24).
isObstacle1(25).
isObstacle1(26).
isObstacle1(27).
isObstacle1(28).
isObstacle1(29).


%////////////////////////////////////fonction util/////////////////////////

%permet d'afficher la liste L sous la forme d'une carte de largeur Size utiliser lors du debeugage 
afficheL(L,Size):-afficheL(L,Size,Size).
afficheL([],_,_).
afficheL(L,Size,0):- nl,afficheL(L,Size,Size),!.
afficheL([T|R],Size,S):-write(T),write(' '),S1 is S-1,afficheL(R,Size,S1),!.

%Calcul la longueur N1 (nb de colone) de la liste.
longueurMap([],0).
longueurMap([_|R],N1):- longueurMap(R,N),
						N1 is N + 1.

%calcul la hauteur (nb de ligne) de la map L
calculHauteur(Size,L,Height):-	longueurMap(L,N),
								Height is (N // Size)-1.

%decomposition(+Node,+Size,-X,-Y) retourne la cecomposition dans les coordonée
%X,Y de la valeur Node, qui est l'indice dans la carte de largeur Size
decomposition(Node,Size,X,Y):- X is Node mod Size, Y is Node // Size.

%heuristie(+ActualNode,+FinalNode,+Size,-Val) retourne Val qui est la distance Manathan
%separant ActualNode de FinalNode dans la carte de largeur Size
heuristie(ActualNode,FinalNode,Size,Val) :- decomposition(ActualNode,Size,Xa,Ya),
											decomposition(FinalNode,Size,Xf,Yf),
											X is Xa - Xf, 
											Y is Ya - Yf,
											Val is abs(Y) + abs(X).

%fonction utile au debeugage elle affiche les deux liste global utiliser dans le a star.
etat(O):- nb_getval(openList,O),nb_getval(closedList,C),write(O),nl,write(C),nl,nl.

											
%le predicat retourne l'acttion conseiller Dir a réaliser pour aller vers 
%l'objectif ainsi que le chemin pour y aller Chemin, il initialise les liste et lance les different predicat
%Les parametre sont la carte L, la case actuel ActualNode, la case cible FinalNode
%La largeur de la carte Size,
a_star(L,ActualNode,FinalNode,Size,Dir,Chemin, CGE):-addToOpen(ActualNode,FinalNode,Size),
													nb_setval(closedList,[]),
													calculHauteur(Size,L,Height),
													a_starRec(L,ActualNode,FinalNode,Size,Height,X,CGE),
													extractPath(ActualNode,FinalNode,L,Size,Height,Chemin,CGE),
													returnDir(Chemin,L,Size,Dir),
													nb_setval(openList,[]),
													nb_setval(closedList,[]),!.
%appeler si le A* ne reussi pas
a_star(L,ActualNode,FinalNode,Size,0,[[-1,-1,-1]],CGE).



%predicat recursif du A*
a_starRec(L,ActualNode,FinalNode,Size,Height,X,CGE):-	extractBestFromOpen3([N,C,H|R]),%on prend le meilleur node
														addToClosed([N,C,H]),%On l'ajoute a la closedList
														N =\= FinalNode,%on check si on a atteint l'arrivé
														getVoisin(L ,FinalNode, [N,C,H], Size, Height,CGE),%on ajoute ces voisin a l'openList
														a_starRec(L,N,FinalNode,Size,Height,X,CGE),!.%on recommence											
%appeler si N ==FinalNode														
a_starRec(L,ActualNode,FinalNode,Size,Height,X,CGE):-	X is FinalNode.	


%getVoisin(+L,+FinalNode,+[Node,Cout,Distance],+Size,+Vpy) ajoute dans l'openList
%les node entourant N qui sont accessible											
getVoisin(L ,FinalNode, [N,C,H|R], Size,Height,CGE) :- %Height is (Vpy * 2),
											% calculHauteur(Size,L,Height),
											Vh is N - Size,
											Vb is N  + Size,
											Vg is N - 1,
											Vd is N + 1,
											existeOnMapH([N,C,H], Vh , Size, Height,FinalNode,L,CGE),
											existeOnMapB([N,C,H], Vb, Size, Height,FinalNode,L,CGE),
											existeOnMapG([N,C,H], Vg, Size, Height,FinalNode,L,CGE),
											existeOnMapD([N,C,H], Vd, Size, Height,FinalNode,L,CGE).
											
% verifie que Node et bien dans la carte (pas en dessous)
existeOnMapB([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- T is Size * (Height + 1), Node >=	T,!.
existeOnMapB([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- isAccessible(L,Node,[N,C,H], Node, Size, Height,FinalNode,CGE).

% verifie que Node et bien dans la carte (pas en dessus)
existeOnMapH([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- Node < 0,!.
existeOnMapH([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- isAccessible(L,Node,[N,C,H], Node, Size, Height,FinalNode,CGE).

%  verifie que Node et bien dans la carte (pas trop a droite)
existeOnMapD([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- decomposition(N, Size, Xa, Yv),
														decomposition(Node, Size,Xn, Yn),
														X is Xa +1,
														Xn =\= X,!.
existeOnMapD([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- isAccessible(L,Node,[N,C,H], Node, Size, Height,FinalNode,CGE).

% verifie que Node et bien dans la carte (pas tropa  gauche)
existeOnMapG([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):-	decomposition(N, Size, Xa, Yv),
														decomposition(Node, Size,Xn, Yn),
														X is Xa -1,
														Xn =\= X, !.
existeOnMapG([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- Node < 0,!.
existeOnMapG([N,C,H|_], Node, Size, Height,FinalNode,L,CGE):- isAccessible(L,Node,[N,C,H], Node, Size, Height,FinalNode,CGE).

%verifie que l'indice N dans la map[T|R] et accessible et n'est pas deja dans 
%une liste globale
isAccessible([T|R],N,[NodeParent,C,H|_], Node, Size, Height,FinalNode,CGE):- N >= 0, N1 is N - 1, isAccessible(R,N1,[NodeParent,C,H], Node, Size, Height,FinalNode,CGE),!.
isAccessible([T|_],0,[NodeParent,C,H|_], Node, Size, Height,FinalNode,CGE):- not(isObstacle(CGE, T)),isNotInList(Node),addToOpen(Node,[NodeParent,C,H],FinalNode,Size),!.
isAccessible([T|_],0,[NodeParent,C,H|_], Node, Size, Height,FinalNode,CGE).
%not(isObstacle(T)),isNotInList(Node),

%ajoute un etat N aprés l'avoir calculé grace a l'état précédent

addToOpen(N,[An,Cout,_],FinalNode,Size):- 	nb_getval(openList,L),
											heuristie(N,FinalNode,Size,H),
											C is Cout + 1,
											append([[N,C,H]],L,T),
											nb_setval(openList,T).



%ajout du premier element a l'opelListe											
addToOpen(ActualNode,FinalNode,Size):-	heuristie(ActualNode,FinalNode,Size,H),
										nb_setval(openList,[[ActualNode,0,H]]).	
										
%ajoute un etat a la closedList									
% danger si closed n'est pas defini
addToClosed(State):-nb_getval(closedList,L),
					append([State],L,T),
					nb_setval(closedList,T).
		
		
%retourne X l'élément ayant la plus faible heuristie dans l'openList,
% solution non retenu
extractBestFromOpen1(X):-nb_getval(openList,L),
						extractBestFromOpen1(X,L),
						subtract(L,[X],T),
						nb_setval(openList,T).
						
%prend le dernier ajouter dans la liste						
extractBestFromOpen1(T,[T]).
%on descend tout au fond de la liste et on remonte en comparant
extractBestFromOpen1(X,[[Ne,Ce,He]|R]):-	extractBestFromOpen1([Na,Ca,Ha],R),
											Ve is Ce + He,
											Va is Ca + Ha,
											Va >= Ve,
											append([Ne,Ce,He],[],X),!.
extractBestFromOpen1(X,[[Ne,Ce,He]|R]):-	extractBestFromOpen1(X,R),!.

%version 2 de l'algo un peut plus rapide mais pas retenu
extractBestFromOpen2([], R, R). %end
extractBestFromOpen2([[Ne,Ce,He]|Xs], [Na,Ca,Ha], R):- 	Ve is Ce + He,
														Va is Ca + Ha,
														Va >= Ve, 
														extractBestFromOpen3(Xs, [Ne,Ce,He], R). %WK is Carry about
extractBestFromOpen2([[Ne,Ce,He]|Xs], [Na,Ca,Ha], R):- 	Ve is Ce + He,
														Va is Ca + Ha,
														Va < Ve,
														extractBestFromOpen3(Xs, [Na,Ca,Ha], R).
extractBestFromOpen2(R):- 	nb_getval(openList,[[Ne,Ce,He]|Xs]),
							extractBestFromOpen3(Xs, [Ne,Ce,He], R),
							subtract([[Ne,Ce,He]|Xs],[R],T),
							nb_setval(openList,T).
											

%version trois de l'algo, verison al plus rapide et solution retenu
extractBestFromOpen3(X):-
						nb_getval(openList,L),
						extractBestFromOpen3(X,L),
						subtract(L,[X],T),
						nb_setval(openList,T).
												
extractBestFromOpen3(X,L):- 	sortList(L,[X|R]),!.

extractBestFromOpen3(X,[X|R]).

%predicat definissant l'ordre
ordreOpen(<,[_,Ce,He],[_,Ca,Ha]):-Ve is Ce + He,
							Va is Ca + Ha,
							Va >= Ve.
ordreOpen(>,[_,Ce,He],[_,Ca,Ha]):-Ve is Ce + He,
							Va is Ca + Ha,
							Va < Ve.
							
%predicat triant la liste en fonctiant de l'ordre definie precédement
sortList(X,R):-predsort(ordreOpen,X,R).


%verifie si L'indice Node et deja dans une des liste
isNotInList(Node):- nb_getval(openList,O),nb_getval(closedList,C),not(member([Node,_,_],O)),not(member([Node,_,_],C)).

%returnDir(+Path,+Map,-Dir)
returnDir([[Na,_,_],[Nv,_,_]|R],L,Size,Dir):-	Nt is Na +1,
												Nv =:= Nt,
												Dir is 1,!.
											
returnDir([[Na,_,_],[Nv,_,_]|R],L,Size,Dir):-	Nt is Na - 1,
												Nv =:= Nt,
												Dir is 3,!.
											
returnDir([[Na,_,_],[Nv,_,_]|R],L,Size,Dir):-	Nt is Na + Size,
												Nv =:= Nt,
												Dir is 4,!.
											
returnDir([[Na,_,_],[Nv,_,_]|R],L,Size,Dir):-	Dir is 2.

%verifie si Node appartient a closedList et retourne son état si il y est
isOnClosed(Node,State):-nb_getval(closedList,L),isOnClosed(Node,State,L),!.
isOnClosed(Node,[N,C,H],[[N,C,H|_]|_]):- N =:= Node,!.
isOnClosed(Node,State,[_|R]):-isOnClosed(Node,State,R).

extractPath(ActualNode,ActualNode,L,Size,Height,[[NS,CS,HS]],CGE):-isOnClosed(ActualNode,[NS,CS,HS]),!.%nl,write(42),nl,!.

extractPath(ActualNode,FinalNode,L,Size,Height,Y,CGE):-	isOnClosed(FinalNode,[NS,CS,HS]),%write(FinalNode + ' a '),
													nb_getval(closedList,List),subtract(List,[[NS,CS,HS]],Temp),nb_setval(closedList,Temp),
													getBestVoisinClosed([N,C,H],[NS,CS,HS],L,Size,Height,CGE),%write(N + ' a '),
													%write( Y +'     ' + N),nl,%!.
													extractPath(ActualNode,N,L,Size,Height,X,CGE),append(X,[[NS,CS,HS]],Y),!.%,write(Y),nl,nl,!.
													
getBestVoisinClosed(NewNode,[NS,CS,HS],L,Size,Height,CGE):-	nb_setval(voisinList,[]),
														getVoisin(L,NS,Size,Height,CGE),
														extractBestFromVoisin(NewNode),!.

getVoisin(L ,Node, Size,Height,CGE) :-%Height is (Vpy * 2),
								%calculHauteur(Size,L,Height),
								Vh is Node - Size,
								Vb is Node  + Size,
								Vg is Node - 1,
								Vd is Node + 1,
								existeOnMapH(Node, Vh , Size, Height,L,CGE),
								existeOnMapB(Node, Vb, Size, Height,L,CGE),
								existeOnMapG(Node, Vg, Size, Height,L,CGE),
								existeOnMapD(Node, Vd, Size, Height,L,CGE).
%cas n'existe pas en bas 
existeOnMapB(Node, Vb , Size, Height,L,CGE):- T is Size * (Height + 1), Vb >=	T,!.
existeOnMapB(Node, Vb , Size, Height,L,CGE):- isAccessible(Vb, Vb , Size, Height,L,CGE).

% cas n'existe pas en Haut                                   
existeOnMapH(Node, Vh , Size, Height,L,CGE):- Vh < 0,!.
existeOnMapH(Node, Vh , Size, Height,L,CGE):- isAccessible(Vh, Vh , Size, Height,L,CGE).

% cas n'existe pas a droite
existeOnMapD(Node, Vd , Size, Height,L,CGE):- decomposition(Node, Size, Xa, Yv),
														decomposition(Vd, Size,Xn, Yn),
														X is Xa +1,
														Xn =\= X,!.
existeOnMapD(Node, Vd , Size, Height,L,CGE):- isAccessible(Vd, Vd , Size, Height,L,CGE).

% cas n'existe pas a gauche
existeOnMapG(Node, Vg , Size, Height,L,CGE):-	decomposition(Node, Size, Xa, Yv),
														decomposition(Vg, Size,Xn, Yn),
														X is Xa -1,
														Xn =\= X, !.
existeOnMapG(Node, Vg , Size, Height,L,CGE):- Vg < 0,!.
existeOnMapG(Node, Vg , Size, Height,L,CGE):- isAccessible(Vg, Vg , Size, Height,L,CGE).

%on verifie si le voisin est accessible suivant ces condition
isAccessible(Node,V,Size,Height,[T|R],CGE):- V >= 0, V1 is V - 1, isAccessible(Node,V1,Size,Height,R,CGE),!.
isAccessible(Node,0,Size,Height,[T|_],CGE):- not(isObstacle(CGE, T)),nb_getval(voisinList,L),isOnClosed(Node,State),append([State],L,Temp),nb_setval(voisinList,Temp),!.
isAccessible(Node,0,Size,Height,[T|_],CGE).

%on extrait le meilleur voisin de la liste voisinList
extractBestFromVoisin(X):-	nb_getval(voisinList,L),
							extractBestFromVoisin(X,L).
												
extractBestFromVoisin(X,L):-sortListVoisin(L,[X|R]),!.

extractBestFromVoisin(X,[X|R]).

%predicat definissant l'ordre pour les voisin
predVoisin(<,[_,Ce,He],[_,Ca,Ha]):-	Ce =< Ca.
predVoisin(>,[_,Ce,He],[_,Ca,Ha]):-	Ce > Ca.
%predicat triant la liste en fonctiant de l'ordre definie precédement
sortListVoisin(X,R):-predsort(predVoisin,X,R).