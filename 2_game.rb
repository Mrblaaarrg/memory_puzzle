require "byebug"
require_relative "0_card"
require_relative "1_board"
require_relative "3_human_player"
require_relative "4_ai_player"

class Game
    def initialize(num_pairs, player_type = "human")
        @board = Board.new(num_pairs)
        @board.populate
        @board.get_legal_guesses
        @player = player_type == "human" ? HumanPlayer.new : AiPlayer.new
        @last_guess = []
    end

    attr_accessor :board, :last_guess

    def get_guess
        @player.make_guess
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
        puts "\nGame Over!" if @board.won?
        puts
        @board.won?
    end

    def refresh
        system("clear")
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

    def play
        until self.game_over?
            guess_pos = self.get_valid_move

            @board.reveal(guess_pos)
            self.refresh

            if @last_guess.empty?
                @last_guess = guess_pos
            elsif @board[@last_guess] == @board[guess_pos]
                puts "\nCorrect!"
                sleep(1)
                card = @board[guess_pos]
                @board.pair_found(card)
                @last_guess = []
            else
                puts "\nWrong guess, try again!"
                sleep(1)
                @board.hide(@last_guess)
                @board.hide(guess_pos)
                @last_guess = []
            end
        end
    end
end

if __FILE__ == $PROGRAM_NAME
    system("clear")

    puts "Welcome to Memory Puzzle!\n"
    puts "Enter the number of pairs to find:"
    num_pairs = gets.chomp.to_i
    memory_game = Game.new(num_pairs)
    puts "\nGreat! Take a good look at the cards before beginning:"
    memory_game.board.hint
    sleep(6)
    system("clear")
    memory_game.play
end
