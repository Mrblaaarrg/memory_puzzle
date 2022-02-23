class AiPlayer
    def initialize(board)
        @board = board
        @known_cards = Hash.new { |h, k| h[k] = [] }
        @previous_guess = []
    end

    def get_fresh_guess(guess_pool)
        guess_pos = guess_pool.sample
        guessed_card = @board[guess_pos].value
        @known_cards[guessed_card] << guess_pos
        @previous_guess = guess_pos
        guess_pos
    end

    def known_pairs
        @known_cards.values.select do |positions|
            positions.length == 2 && positions.any? { |pos| @board.legal_guesses.include?(pos) }
        end
    end

    def get_guess_pool
        explored_cards = []
        @known_cards.values.each { |coords| explored_cards += coords }
        @board.legal_guesses.reject { |pos| explored_cards.include?(pos) }
    end

    def make_first_guess
        if !self.known_pairs.empty?
            guess_pos = self.known_pairs[0][0]
            @previous_guess = guess_pos
        else
            guess_pos = self.get_fresh_guess(self.get_guess_pool)
        end
        guess_pos
    end

    def make_second_guess
        if !self.known_pairs.empty?
            packed_pos = self.known_pairs[0].reject { |pos| pos == @previous_guess }
            guess_pos = packed_pos[0]
        else
            guess_pos = self.get_fresh_guess(self.get_guess_pool)
        end
        @previous_guess = []
        guess_pos
    end
end