require "byebug"
require_relative "0_card"

class Board
    def get_grid_size(num_pairs)
        necessary_tiles = num_pairs * 2
        target_size = Integer.sqrt(necessary_tiles)
        i = target_size
        until necessary_tiles % i == 0
            i += 1
        end
        rows = necessary_tiles / i
        columns = i
        [rows, columns]
    end

    def initialize(num_pairs)
        @num_pairs = num_pairs
        grid_size = get_grid_size(num_pairs)
        @grid = Array.new(grid_size[0]) {Array.new(grid_size[1])}
        @found_pairs = Hash.new(false)
    end

    attr_reader :legal_guesses

    def [](coords)
        row, col = coords
        @grid[row][col]
    end

    def []=(coords, value)
        row, col = coords
        @grid[row][col] = value
    end

    def populate
        values = ("A".."Z").to_a[0...@num_pairs]
        values.each { |value| @found_pairs[value] = false }
        available_cards = values * 2
        available_cards.shuffle!
        @grid.length.times do |row|
            @grid.first.length.times do |column|
                self[[row, column]] = Card.new(available_cards.shift)
            end
        end
        @grid
    end

    def hint
        columns = @grid.first.length
        puts "\n  " + (0...columns).to_a.join(" ")
        @grid.each.with_index do |row, i|
            formatted_row = row
                .map { |card| card.value }
                .join(" ")
            puts i.to_s + " " + formatted_row
        end
        true 
    end
    
    def render
        columns = @grid.first.length
        puts "  " + (0...columns).to_a.join(" ")
        @grid.each.with_index do |row, i|
            formatted_row = row
                .map { |card| card.display }
                .join(" ")
            puts i.to_s + " " + formatted_row
        end
        true
    end

    def reveal(position)
        self[position].reveal
        @legal_guesses.delete(position)
        self[position].value
    end

    def hide(position)
        self[position].hide
        @legal_guesses << position
        self[position].value
    end

    def pair_found(card)
        value = card.value
        @found_pairs[value.upcase] = true if @found_pairs.has_key?(value.upcase)
    end

    def won?
        @found_pairs.values.all?
    end

    def get_legal_guesses
        @legal_guesses = []
        board_slots = @grid.length.times do |row|
            @grid.first.length.times do |column|
                pos = [row, column]
                @legal_guesses << pos unless self[pos].facing_up
            end
        end
    end
end