module Feedback
  # def feedback(code, guess) 
  #   feedback = []
  #   code_unmatched = Hash.new(0) # do we need both??
  #   guess_unmatched = Hash.new(0)

  #   code.each_with_index do |color, index|
  #     if guess[index] == color
  #       feedback << "B"
  #     elsif code_unmatched[guess[index]] > 0 
  #       feedback << "W"
  #       code_unmatched[guess[index]] -= 1
  #     elsif guess_unmatched[color] > 0 
  #       feedback << "W"
  #       guess_unmatched[color] -= 1
  #     else
  #       code_unmatched[color] += 1
  #       guess_unmatched[guess[index]] += 1
  #     end
  #   end
  #   feedback.sort.join # want placement of B's and W's to be consistent
  # end

  def feedback(code, guess) 
    # using a single hash to keep track of unmatched elements from both code and guess
    # if the code has an unmatched element, record it as +1 for key (where key is "color")
    # if guess has an unmatched element, record it as -1 for key
    # correct color, incorrect position elements are "matched" by checking the hash for 
    # occurrence of element 
    feedback = []
    unmatched = Hash.new(0) 

    code.each_with_index do |color, index|
      if guess[index] == color
        feedback << "B"
      elsif unmatched[guess[index]] > 0 # we saw an instance of guess[index] in our code some time previously
        feedback << "W"
        unmatched[guess[index]] -= 1 # remove the element that is now accounted for by a white peg
      elsif unmatched[color] < 0 # we saw an instance of code[index] in our guess some time previously
        feedback << "W"
        unmatched[color] += 1 # remove the element that is now accounted for by a white peg
      else
        unmatched[guess[index]] -= 1 # nothing we've seen matches guess[index]
        unmatched[color] += 1 # nothing we've seen matched code[index], ie. color
      end
    end
    feedback.sort.join # want placement of B's and W's to be consistent
  end
end
