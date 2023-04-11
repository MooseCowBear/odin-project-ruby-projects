# odin-project-ruby-projects

## Tic Tac Toe

A command line tic tac toe game. 

With tests.

## Mastermind

A command line recreation of Mastermind. 

In this rendition, there are 6 colors that are represented as digits 1 - 6. A code consists of 4 (possibly repeated) colors. Feedback is given as a string consisting of Bs and Ws (B for correct color and correct position, W for correct color). 

The codebreaker has a maximum guess limit of 12.

The computer employs Knuth's 1977 algorithm.

### Deviations from the actual board game

Unlike the board game, there is no requirement to specify the number of rounds ahead of time. Instead the player is asked at the end of each round whether they want to play again. For each round, the player chooses whether to be the codemaker or codebreaker. Scoring deviates from the board game as well. A simple report of who has won the round is given, rather than a tally based on how many guesses the codebreaker needed in order to come up with the correct solution. 

### Knuth's algorithm

The algorithm works as follows. 

1. Create the set of possible codes.

2. Make an initial guess of the form "aabb". Here the initial computer guess is "1122" as in Knuth. 

3. If the feedback is "BBBB" the guess is correct, return. 

4. Otherwise, separate the impossible codes from the possible codes, where a possible code is one that is consistent with the feedback recieved. (For instance, were we to receive the empty string as feedback indicating that our guess contained none of the right colors we would know that the code could not contain a 1 or a 2.) 

5. Calculate which code is the "best" option for our next guess with the following procedure:

	a. Consider each possible code and the various feedback we could receive were that code to be our next guess.

	b. Score each code accoring to the fewest codes that might be eliminated from the set of possible codes. A guess x is better than a guess y if the fewest codes x could eliminate is greater than the fewest codes y could eliminate. (In other words, be risk averse.)

	c. Consider each impossible code and score it in the same way.

	d. Compare the score of the best possible code to the best impossible code, and choose the one with the better score. (If their scores are equal, choose the possible code). 

6. Repeat.
 
### Play Online

[Play on repl.it](https://replit.com/@moosecow/mastermind?v=1)

### Resources

The original Knuth paper is available [here](https://www.cs.uni.edu/~wallingf/teaching/cs3530/resources/knuth-mastermind.pdf)