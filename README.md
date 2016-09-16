# Domino
A Haskell program to "read a map" of domino pips, and translate this to a map containing the dominoes.


This is my implementation for the final assignment of the 'Functional Programming" subcourse in the Module "De kritische software engineer".

My solution works as follows:

At the start of the algorithm, the function 'nextStep' is called. This does 2 things:
First, it calls the function goRight, and after this function returns, it calls goDown. This is done because even if we have found a solution with goRight, we still want to check whether goDown yields a solution too.

The functions goRight and goDown are the powerhouses of this implementation, and they are largely similar. It is probably possible to fit both functionalities in a single function, which would mean the entire thing could be a single function, but that would make the implementation quite difficult to read.

The function goRight does the following:
First it checks if there are still any stones that have not been tried yet. If there are none, there is nothing to do and we can return.
If there are, we should take the first of the remaining values on the inputboard, and perform some checks:
  - We should check whether we are at the far right of the board, or the next value on the inputboard has already been solved (check whether there is an unsolved value next to the current field we are checking.)
  - We should check if the first stone on the stack fits the value (and its neighbour). If it doesnt, put the stone on the discard pile, and try again. But if it does we can contine!
When we find a stone that fits, we should add its number to a new solutions board (which contains all values we've found so far), and try the next step (with a smaller inputboard).

goDown does almost the same thing, but it checks the value directly below it to see if the sone fits. Of course this means ther has to be a value below it.

After a while, nextStep will be called with an empty input, because all of the input values will have been consumed. That is when we print this solution! All paths eventually meet a return statement, so after all steps have been taken and all boards have been printed we return to printSolutionsTo to wrap up.
