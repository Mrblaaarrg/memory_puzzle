class Card
    def initialize(value)
        @value = value
        @facing_up = false
    end

    attr_reader :value, :facing_up

    def display
        @facing_up ? @value.to_s : "#" 
    end

    def reveal
        @facing_up = true unless @facing_up
    end

    def hide
        @facing_up = false if @facing_up
    end

    def ==(other_card)
        self.value == other_card.value
    end
end