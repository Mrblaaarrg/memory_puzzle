class HumanPlayer
    def initialize
    end

    def make_first_guess
        abc = ("a".."z").to_a
        valid_guess = false
        until valid_guess
            puts "\nEnter the position of the card you want to flip (row, column) separated by a comma (example '0,1'):"
            guess_pos = gets.chomp.downcase.split(",")
            no_letters = guess_pos.none? { |ele| abc.include?(ele) }
            if guess_pos.length == 2 and no_letters
                valid_guess = true
            else
                puts "Invalid guess, please try again"
            end
        end
        guess_pos.map(&:to_i)
    end

        def make_second_guess
        abc = ("a".."z").to_a
        valid_guess = false
        until valid_guess
            puts "\nEnter the position of the card you want to flip (row, column) separated by a comma (example '0,1'):"
            guess_pos = gets.chomp.downcase.split(",")
            no_letters = guess_pos.none? { |ele| abc.include?(ele) }
            if guess_pos.length == 2 and no_letters
                valid_guess = true
            else
                puts "Invalid guess, please try again"
            end
        end
        guess_pos.map(&:to_i)
    end
end