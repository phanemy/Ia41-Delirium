/*


  Définition de l'IA du mineur

  Le prédicat move/12 est consulté à chaque itération du jeu.

  best_choice_list  renvoi no.
  
*/


:- module( decision, [
	init/1,
	move/12
] ).
:- use_module(library(lists)).
:- use_module(a_star).
:- use_module(prediction).
% :- set_prolog_stack(global, limit(100 000 000 000 000 000 )).

init(_).
% init(_) :- initialisationListe(X).

%move( +L,+LP, +X,+Y,+Pos, +Size, +CanGotoExit, +Energy,+GEnergy, +VPx,+VPy, -ActionId )


% Mouvement aléatoire avec prédicat move/12
 %move( L,_, _,_,_, _, _, _,_, _,_, Action ) :- Action is random( 5 ), write(Action), write(L), nl.
 %move( Action ) :- Action is 1+random( 4 ), write(Action),nl.

% Algo normal
 move(L,_,_,_,Pos,Size,CGE,_,_,_,_,Action):-  length(L,T), T < 500, secureList(L, Size, S), best_way_list(S,Pos,Size,Study,CGE),best_choice(Study,Pos,Choix), a_star(S,Pos,Choix,Size,Action,_,CGE),!
 .

% Algo simplifié pour les grandes maps
 move(L,_,_,_,Pos,Size,CGE,_,_,_,_,Action):- length(L,T), T >= 500, CGE == 0, secureList(L, Size, S), best_way(S,Pos,Size,Study,CGE), best_choice(Study,Pos,Choix), a_star(S,Pos,Choix,Size,Action,_,CGE),! .
 move(L,_,_,_,Pos,Size,CGE,_,_,_,_,Action):- length(L,T), T >= 500, CGE == 1, secureList(L, Size, S), best_way_list(S,Pos,Size,Study,CGE), best_choice(Study,Pos,Choix), a_star(S,Pos,Choix,Size,Action,_,CGE),! .


%%%%%%%%%%%%%%%%%%%%%%%%%%% Thomas WADEL %%%%%%%%%%%%%%%%%%%%%%%%%%%


% exemple -> move([5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5],_,_,_,16,5,_,_,_,_,_,Action).
% move([5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 22, 3, 6, 2, 2, 2, 1, 1, 3, 1, 6, 1, 1, 6, 2, 1, 1, 1, 1, 3, 6, 3, 1, 2, 6, 2, 6, 1, 1, 3, 3, 2, 1, 1, 1, 3, 1, 1, 5, 5, 1, 1, 6, 6, 2, 1, 1, 1, 2, 3, 6, 1, 1, 1, 1, 1, 3, 1, 6, 6, 6, 6, 1, 6, 6, 2, 6, 1, 1, 6, 6, 6, 1, 1, 1, 6, 2, 1, 5, 5, 2, 1, 2, 6, 6, 6, 3, 6, 6, 6, 6, 1, 6, 1, 6, 6, 6, 1, 2, 1, 6, 1, 1, 1, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 6, 1, 6, 6, 1, 1, 3, 1, 1, 1, 1, 1, 6, 1, 1, 1, 6, 1, 6, 1, 6, 6, 1, 1, 1, 1, 1, 1, 6, 1, 1, 6, 1, 1, 1, 6, 6, 1, 5, 5, 1, 1, 3, 1, 3, 1, 1, 1, 1, 6, 6, 6, 6, 1, 6, 2, 1, 1, 3, 1, 6, 1, 0, 3, 6, 6, 6, 1, 1, 1, 3, 6, 3, 1, 1, 6, 6, 1, 5, 5, 1, 2, 3, 1, 6, 6, 1, 1, 6, 6, 2, 3, 3, 1, 6, 3, 2, 1, 6, 1, 6, 1, 6, 6, 6, 6, 6, 1, 1, 6, 6, 6, 6, 6, 1, 6, 6, 1, 5, 5, 1, 6, 6, 2, 6, 2, 1, 1, 1, 1, 1, 6, 6, 1, 6, 6, 6, 1, 6, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 6, 1, 1, 6, 1, 1, 5, 5, 1, 6, 1, 2, 1, 1, 2, 3, 6, 1, 1, 6, 1, 1, 6, 6, 6, 1, 6, 1, 6, 1, 6, 6, 6, 6, 6, 1, 6, 1, 1, 6, 1, 1, 1, 6, 1, 1, 5, 5, 1, 1, 1, 6, 1, 1, 6, 3, 6, 3, 1, 6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 1, 1, 1, 1, 6, 6, 1, 1, 1, 1, 1, 1, 1, 1, 5, 5, 1, 6, 6, 6, 1, 6, 6, 6, 6, 6, 1, 6, 6, 1, 2, 1, 3, 6, 2, 6, 2, 1, 6, 6, 1, 3, 6, 1, 6, 6, 6, 6, 1, 6, 6, 6, 6, 6, 5, 5, 1, 6, 6, 6, 1, 1, 1, 1, 3, 6, 1, 1, 1, 1, 3, 1, 6, 6, 6, 6, 6, 2, 1, 1, 2, 6, 1, 1, 1, 6, 3, 1, 1, 1, 3, 0, 0, 1, 5, 5, 2, 1, 1, 1, 1, 3, 3, 1, 1, 6, 1, 1, 3, 1, 6, 1, 1, 6, 1, 1, 3, 6, 3, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 1, 1, 1, 5, 5, 6, 3, 3, 1, 6, 6, 6, 1, 1, 6, 3, 6, 6, 1, 1, 1, 1, 2, 2, 1, 1, 3, 6, 2, 1, 1, 1, 1, 3, 6, 6, 3, 1, 1, 1, 6, 2, 2, 5, 5, 6, 6, 6, 1, 6, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 6, 6, 1, 1, 1, 0, 6, 1, 1, 1, 3, 3, 6, 6, 6, 6, 1, 1, 3, 6, 2, 5, 5, 1, 3, 1, 1, 1, 1, 1, 1, 6, 6, 1, 1, 6, 6, 1, 1, 3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 3, 3, 3, 6, 6, 2, 2, 1, 6, 6, 6, 6, 5, 5, 2, 6, 6, 6, 1, 1, 6, 1, 1, 6, 6, 1, 6, 1, 1, 3, 6, 1, 3, 6, 6, 1, 6, 6, 6, 1, 6, 6, 6, 6, 6, 6, 1, 1, 1, 1, 1, 1, 5, 5, 1, 1, 3, 1, 1, 2, 6, 2, 1, 1, 1, 1, 1, 1, 1, 6, 6, 1, 6, 6, 1, 1, 6, 2, 6, 1, 1, 1, 1, 6, 6, 1, 1, 6, 3, 1, 1, 21, 5, 5, 2, 1, 1, 1, 1, 6, 6, 6, 6, 1, 3, 1, 1, 6, 1, 1, 1, 1, 1, 1, 1, 1, 6, 2, 6, 3, 1, 1, 1, 2, 6, 1, 3, 6, 6, 1, 1, 2, 5, 5, 2, 2, 6, 6, 1, 1, 1, 1, 1, 2, 2, 2, 1, 6, 3, 1, 6, 6, 3, 3, 1, 1, 6, 2, 6, 6, 6, 1, 1, 1, 6, 1, 6, 6, 1, 1, 3, 6, 5, 5, 2, 6, 6, 6, 1, 6, 6, 1, 1, 6, 6, 6, 1, 6, 6, 1, 2, 6, 6, 6, 1, 1, 6, 3, 6, 3, 1, 1, 2, 1, 1, 1, 1, 1, 1, 3, 6, 6, 5, 5, 1, 1, 6, 6, 1, 3, 6, 1, 1, 2, 3, 1, 1, 3, 1, 1, 1, 2, 2, 6, 1, 1, 6, 1, 1, 1, 1, 3, 6, 1, 1, 6, 6, 6, 6, 6, 6, 2, 5, 5, 3, 1, 1, 1, 1, 3, 6, 3, 1, 2, 3, 3, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1, 6, 1, 6, 1, 3, 3, 6, 3, 1, 1, 1, 1, 1, 0, 2, 2, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],_,_,_,16,5,_,_,_,_,_,Action).
% best_choice([-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],8,Choix).

isDiamond(2).
isExit(21).

%best_way_list(Map,ActualNode,Size,Study)
best_way_list(Map,ActualNode,Size,Study,CGE):- best_way_list(Map,Map,ActualNode,Size,Study,0,CGE).
best_way_list(_,[],_,_,[],N,_).
best_way_list(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- 	CGE = 0,
															isDiamond(Pos),
															N1 is N+1,
															a_star(Map,ActualNode,N,Size,_,X,CGE),
															etude(X,Note),
															best_way_list(Map,R,ActualNode,Size,Study,N1,CGE),
															append([Note],Study,StudBis),!.
														
best_way_list(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- 	CGE = 0,
															not(isDiamond(Pos)),
															N1 is N+1,
															best_way_list(Map,R,ActualNode,Size,Study,N1,CGE),
															append([-1],Study,StudBis).

best_way_list(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- 	CGE = 1,
															isExit(Pos),
															N1 is N+1,
															a_star(Map,ActualNode,N,Size,_,X,CGE),
															etude(X,Note),
															best_way_list(Map,R,ActualNode,Size,Study,N1,CGE),
															append([Note],Study,StudBis),!.
														
best_way_list(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- 	CGE = 1,
															not(isExit(Pos)),
															N1 is N+1,
															best_way_list(Map,R,ActualNode,Size,Study,N1,CGE),
															append([-1],Study,StudBis).



best_way(Map,ActualNode,Size,PosDiam,CGE):- best_way(Map,Map,ActualNode,Size,PosDiam,0,CGE).

best_way(_,[],_,_,[],_,_).
best_way(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- 		CGE = 0,
														isDiamond(Pos),
														N1 is N+1,
														heuristie(ActualNode,N,Size,Note),
														best_way(Map,R,ActualNode,Size,Study,N1,CGE),
														append([Note],Study,StudBis),!.

best_way(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- CGE == 0,
														not(isDiamond(Pos)),
														N1 is N+1,
														best_way(Map,R,ActualNode,Size,Study,N1,CGE),
														append([-1],Study,StudBis).	


best_way(Map,[Pos|R],ActualNode,Size,StudBis,N,CGE):- CGE == 1,
														best_way_list(Map,ActualNode,Size,StudBis,CGE).



% etude(X,Y) X la liste
%			 Y le coup
etude([X],Note):- cout(X,Note).
etude([_|R],Note):- etude(R,Note).

cout([_,X,_],X).

% order_ways(L,Cost,Pos)
order_ways(L,Cost,Pos):- order_ways(L,Cost,Pos,0).
order_ways([],[],[],_).
order_ways([X|R],CostB,PosB,N):-	X \= -1,
									N1 is N+1,
									order_ways(R,Cost,Pos,N1),
									append([N],Pos,PosB),
									append([X],Cost,CostB).
order_ways([X|R],Cost,Pos,N):-	X == -1,
								N1 is N+1,
								order_ways(R,Cost,Pos,N1).

% exemple -> order_ways([-1,-1,-1,-1,-1,-1,4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],Cost,Pos).



best_choice(L,_,PositionFutur):- order_ways(L,Costs,PosListe), msort(Costs,[Min|_]), Costs \= [], nth0(Ind,Costs,Min), nth0(Ind,PosListe,PositionFutur).
best_choice(L,PositionActuel,PositionActuel):- order_ways(L,Costs,_), sortList(Costs,[Min|_]), Costs == [].



% exemple -> best_choice([-1,-1,-1,-1,-1,-1,4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1],Pos).


% MapTest : [5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5]
% a_star(L,ActualNode,FinalNode,Size,Dir)
% a_star([5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5],16,6,5,Dir).
% Dir = [[16, 0, 2], [17, 1, 3], [12, 2, 2], [7, 3, 1], [6, 4, 0]].

% etude([[6, 0, 2], [7, 1, 3], [12, 2, 2], [17, 3, 1], [16, 4, 0]],X).
% X = 4.

% best_way_list([5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5],16,5,Study).
% best_way_list([5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5],[5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5],16,5,Study,0).
% Study = [-1,-1,-1,-1,-1,-1,4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]

% best_way_list([5,5,5,5,5,5,2,1,1,5,5,4,1,1,5,5,22,1,1,5,5,5,5,5,5],16,5,[-1,-1,-1,-1,-1,-1,4,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]).


