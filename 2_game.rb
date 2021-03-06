require_relative "0_card"
require_relative "1_board"
require_relative "3_human_player"
require_relative "4_ai_player"

class Game
    def initialize(num_pairs, player_type = "human")
        @board = Board.new(num_pairs)
        @board.populate
        @board.get_legal_guesses
        @player = player_type == "human" ? HumanPlayer.new : AiPlayer.new(@board)
        @last_guess = []
        @turns_left = num_pairs * 4
    end

    attr_accessor :board, :last_guess

    def get_guess
        @last_guess.empty? ? @player.make_first_guess : @player.make_second_guess
    end

    def playable_guess?(guess_pos)
        unless @board.legal_guesses.include?(guess_pos)
            puts "That card is already face up, please choose another one"
            sleep(1)
            return false
        end
        true
    end

    def game_over?
        if @turns_left <= 0
            puts "\nNo more turns left! You lose!"
            return true
        end

        puts "\nGame Over!" if @board.won?
        puts
        @board.won?
    end

    def refresh
        system("clear")
        puts "\nYou have #{@turns_left} turns remaining"
        puts
        @board.render
    end

    def get_valid_move
        valid_move = false
        until valid_move
            self.refresh
            guess_pos = self.get_guess
            valid_move = self.playable_guess?(guess_pos)
        end
        guess_pos
    end

    def update_last_guess(guess_pos)
        if @last_guess.empty?
            @last_guess = guess_pos
            return true
        end
        false
    end

    def process_wrong_guesses(guess_pos)
        @board.hide(@last_guess)
        @board.hide(guess_pos)
        @last_guess = []
    end

    def process_correct_guesses(guess_pos)
        card = @board[guess_pos]
        @board.pair_found(card)
        @last_guess = []
    end    

    def play
        turns_left = @turn_limit
        until self.game_over?
            guess_pos = self.get_valid_move

            @board.reveal(guess_pos)
            self.refresh
            unless self.update_last_guess(guess_pos)
                if @board[@last_guess] == @board[guess_pos]
                    puts "\nCorrect!"
                    sleep(1)
                    self.process_correct_guesses(guess_pos)
                else
                    puts "\nWrong guess, try again!"
                    sleep(1)
                    self.process_wrong_guesses(guess_pos)
                    @turns_left -= 1
                end
            end 
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    system("clear")

    puts "Welcome to Memory Puzzle!\n"
    puts "Select player type between human or computer (h/c):"
    player_type = gets.chomp.downcase == "h" ? "human" : "ai"
    puts "Enter the number of pairs to find:"
    num_pairs = gets.chomp.to_i
    memory_game = Game.new(num_pairs, player_type)
    puts "\nGreat! Take a good look at the cards before beginning:"
    memory_game.board.hint
    sleep(6)
    system("clear")
    memory_game.play
end
