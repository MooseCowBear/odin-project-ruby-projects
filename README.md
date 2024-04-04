# odin-project-ruby-projects

## Tic Tac Toe

A command line tic tac toe game. 

With tests.

## Mastermind

A command line, OOP recreation of Mastermind. 

In this rendition, there are 6 colors that are represented as digits 1 - 6. A code consists of 4 (possibly repeated) colors. Feedback is given as a string consisting of Bs and Ws (B for correct color and correct position, W for correct color). 

The codebreaker has a maximum guess limit of 12.

The computer employs Knuth's 1977 algorithm.

The main method for getting the next computer guess: 

```
def make_guess(prev_feedback)
  update_codes(prev_feedback) if prev_feedback

  return guess if impossible_codes.length == 0

  best_pos = best_guess_from(possible_codes)
  best_impos = best_guess_from(impossible_codes)

  if best_impos.score < best_pos.score
    self.guess = best_impos.guess
  else 
    self.guess = best_pos.guess
  end

  guess 
end
```

The method to get the best scoring code from a set of codes: 

```
def best_guess_from(codes)
  min_score = 1296
  best_guess = nil

  codes.each do |code|
    score = score(code)
    if score < min_score
      min_score = score
      best_guess = code
    end
  end
  Guess.new(best_guess, min_score)
end
```

The method for determining the score of a code, ie. its worst outcome, ie. the greatest number of codes it can't eliminate: 

```
def score(hypothetical_guess)
  outcome_tallies = Hash.new(0)

  possible_codes.each do |code|
    outcome_tallies[feedback(code, hypothetical_guess)] += 1
  end
  outcome_tallies.values.max 
end
```

### Resources

The original Knuth paper is available [here](https://www.cs.uni.edu/~wallingf/teaching/cs3530/resources/knuth-mastermind.pdf)