:- module( prediction, [
	saveT/1,
	secureList/3,
	initialisationListe/1
] ).

initialisationListe(_) :- saveT([]).

%------------Rochers------------

isFallableRock([3|R], Size) :- S is Size - 1, nth0(S, R, 0).
isFallableRock([3|R], Size) :- S is Size - 1, nth0(S, R, 22).

rockPosition([], _, []).
rockPosition(T, Size, T) :- length(T, Longueur), (Longueur - 1) < Size, !.
rockPosition([T|R], Size, S) :- isFallableRock([T|R], Size), Size2 is Size * 2, modifElem([T|S1], Size2, 4, S), rockPosition(R, Size, S1), !.
rockPosition([T|R], Size, [T|S]) :- rockPosition(R, Size, S), !.

modifElem([], _, _, []).
modifElem([21|R], 0, _, [21|R]).
modifElem([_|R], 0, Nouv, [Nouv|R]).
modifElem([T|R], Index, Nouv, S) :- N1 is Index - 1, modifElem(R, N1, Nouv, S1), append([T], S1, S).

%------------Monstres-----------

saveT(L) :- nb_setval(monstre, L).

isMob(24).
isMob(25).
isMob(26).
isMob(27).
isMob(28).
isMob(29).

oldDirection(L, _, MobPosition, 'gauche') :- G is MobPosition + 1, compar(L, MobPosition, G), !.
oldDirection(L, _, MobPosition, 'droite') :- D is MobPosition - 1, compar(L, MobPosition, D), !.
oldDirection(L, Size, MobPosition, 'bas') :- B is MobPosition - Size, compar(L, MobPosition, B), !.
oldDirection(L, Size, MobPosition, 'haut') :- H is MobPosition + Size, compar(L, MobPosition, H), !.
oldDirection(_, _, _, 'pasBouge').

compar(L, X, Y) :- nth0(X, L, D), nb_getval(monstre, Old), nth0(Y, Old, D).

f('gauche', 'bas').
f('droite', 'haut').
f('bas', 'droite').
f('haut', 'gauche').
f(_, 'pasBouge').

newDirection(T, Size, MobPosition, OldDirect, NewDirect) :- f(OldDirect, NewDirect), getIndexDirection(NewDirect, Size, MobPosition, NewPos), nth0(NewPos, T, 0), !.
newDirection(T, Size, MobPosition, OldDirect, OldDirect) :- getIndexDirection(OldDirect, Size, MobPosition, NewPos), nth0(NewPos, T, 0), !.
newDirection(T, Size, MobPosition, OldDirect, NewDirect) :- f(OldDirect, NewDirect1), f(NewDirect1, NewDirect), getIndexDirection(NewDirect, Size, MobPosition, NewPos), nth0(NewPos, T, 0), !.
newDirection(T, Size, MobPosition, OldDirect, NewDirect) :- f(OldDirect, NewDirect1), f(NewDirect1, NewDirect2), f(NewDirect2, NewDirect), getIndexDirection(NewDirect, Size, MobPosition, NewPos), nth0(NewPos, T, 0), !.
newDirection(_, _, _, _, 'pasBouge').

getIndexDirection('gauche', _, OldPos, Pos) :- Pos is OldPos - 1, !.
getIndexDirection('droite', _, OldPos, Pos) :- Pos is OldPos + 1, !.
getIndexDirection('bas', Size, OldPos, Pos) :- Pos is OldPos + Size, !.
getIndexDirection('haut', Size, OldPos, Pos) :- Pos is OldPos - Size, !.
getIndexDirection(_, _, OldPos, OldPos).

mobPosition([], _, []).
mobPosition(T, Size, S) :- mobPosition(T, Size, 0, S).
mobPosition(T, _, Long, T) :- length(T, Long), !.
mobPosition([], _, _, []) :- !.
mobPosition(T, Size, Index, S) :- I is Index + 1, nth0(Index, T, E), isMob(E), mobPosition(T, Size, I, S1), oldDirection(T, Size, Index, OldDirect), newDirection(T, Size, Index, OldDirect, NewDirect), 
			getIndexDirection(NewDirect, Size, Index, NewIndex), alentourMob(S1, Size, NewIndex, S), !.
mobPosition(T, Size, Index, S) :- I is Index + 1, mobPosition(T, Size, I, S).

modifMonstre(S1, Index, S1) :- nth0(Index, S1, X), isMob(X).
modifMonstre(S1, Index, S) :- modifElem(S1, Index, 4, S).

alentourMob(L, Size, Index, S) :- alentourMob(L, Size, Index, S, 1).
alentourMob(L, Size, Index, S, 1) :- alentourMob(L, Size, Index, S1, 2), I is Index + 1, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 2) :- alentourMob(L, Size, Index, S1, 3), I is Index - 1, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 3) :- alentourMob(L, Size, Index, S1, 4), I is Index + Size + 1, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 4) :- alentourMob(L, Size, Index, S1, 5), I is Index + Size - 1, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 5) :- alentourMob(L, Size, Index, S1, 6), I is Index - Size + 1, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 6) :- alentourMob(L, Size, Index, S1, 7), I is Index - Size - 1, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 7) :- alentourMob(L, Size, Index, S1, 8), I is Index + Size, modifMonstre(S1, I, S).
alentourMob(L, Size, Index, S, 8) :- I is Index - Size, modifMonstre(L, I, S).

%--------Appel pour les deux fonctions-----------------------------

secureList(L, Size, S) :- rockPosition(L, Size, S1), mobPosition(S1, Size, S), saveT(L).