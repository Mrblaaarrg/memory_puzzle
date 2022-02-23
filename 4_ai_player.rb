class AiPlayer
    def initialize(board)
        @board = board
        @known_cards = {}
    end

    def make_guess
        if @known_cards.empty?
            guess_pos = @board.legal_guesses.sample
        end
        guess_pos
    end
end