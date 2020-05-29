male(archie).
male(clay).
male(justin).
male(will).
male(dustin).

male(harry).

male(otis).
male(draco).

male(steve).
male(mike).
male(adam).
male(alex).
male(tony).

male(bryce).
male(porter).
male(andy).

male(montogomery).
male(jeff).
male(atkins).
male(jensen).
male(hiram).

male(chuck).
male(walker).
male(baker).
male(pratters).
male(zach).
male(dempsey).

male(tyler).
male(delacruz).
male(jughead).
male(jones).
male(reggie).
male(fred).

female(betty).
female(veronica).
female(cheryl).
female(midge).
female(penelope).

female(ethel).
female(grundy).
female(penny).

female(mary).
female(donna).
female(josie).
female(polly).
female(valerie).

child(andy, adam). 
child(andy, alex).
child(andy, midge).
child(porter, tony). 

child(donna, tony). 
child(pratters, bryce). 
child(pratters, donna).

child(ethel, bryce). 
child(ethel, donna).
child(zach, bryce). 
child(zach, donna).
child(otis, harry). 
child(alex, draco).

child(alex, veronica).
child(bryce, adam).
child(bryce, alex).
child(bryce, cheryl).

child(dempsey, bryce). 
child(dempsey, penelope).
child(steve, otis). 
child(steve, betty).
child(mike, otis).
child(mike, veronica).
child(adam, otis).
child(adam, veronica).

child(montogomery, josie). 
child(montogomery, archie).

child(baker, dustin).
child(tyler, jensen). 
child(tyler, grundy).
child(delacruz, jeff). 
child(delacruz, penny).
child(jughead, atkins). 
child(jughead, penny).
child(jones, jensen). 
child(jones, penny).

child(jeff, andy). 
child(jeff, josie).
child(jeff, clay).
child(atkins, andy).

child(atkins, josie).
child(atkins, justin).
child(jensen, andy). 
child(jensen, josie).

child(jensen, will).
child(walker, andy). 
child(walker, polly).
child(walker, dustin).
child(baker, andy). 
child(baker, polly).

child(reggie, walker). 
child(reggie, penny).
child(fred, baker). 
child(fred, penny).
child(hiram, tyler). 
child(hiram, mary).
child(chuck, hiram). 
child(chuck, valerie).

married(otis, betty).		
married(otis, veronica).
married(draco, veronica).
married(adam, cheryl).
married(adam, midge).
married(bryce, donna).
married(andy, josie).
married(andy, polly).
married(jensen, grundy).
married(jeff, penny).
married(atkins, penny).
married(jensen, penny).
married(walker, penny).
married(baker, penny).
married(tyler, mary).
married(hiram, valerie).

is_married(A, B)    :-  married(A, B).
is_married(C, D)    :-  married(D, C).
husband(E, F)       :-  male(E), married(E, F).
husband(G, H)       :-  male(G), married(H, G).
wife(I, J)          :-  female(I), married(I, J).
wife(K, L)          :-  female(K), married(L, K).
parent(X, Y) 		:- 	child(Y,X).
son(X, Y)			:- 	child(X, Y) , male(X).
daughter(X, Y)		:- 	child(X, Y) , female(X).
grandfather(M, N)	:-	male(M), child(N, O), child(O, M).
grandmother(P, Q)	:-	female(P), child(Q, R), child(R, P).
descendent(S, T)	:-	child(S, T).
descendent(U, V)	:-	child(U, W), descendent(W, V).
ancestor(Y, Z)		:-	descendent(Z, Y).