require 'action_view'
include ActionView::Helpers::NumberHelper

class Game
  attr_reader :categories

  def initialize(is_test)
    @card_1 = Card.new("What is 5 + 5?", "10", "STEM")
    @card_2 = Card.new("What is Rachels favorite animal?", "toad", "Turing Staff")
    @card_3 = Card.new("What is Mike's middle name?", "nobody knows", "Turing Staff")
    @card_4 = Card.new("What cardboard cutout lives at Turing?", "Justin Bieber", "Pop Culture")
    @cards = [@card_1, @card_2, @card_3, @card_4]
    @deck = Deck.new(@cards)
    @round = Round.new(@deck)
    @turn = 1
    @game = self
    @guess = ""
    @categories = []
    @is_test = is_test
  end

  def start
    message
  end

  def message
    until @turn == @cards.count
      if @turn == 1
        puts "Welcome! You're playing with #{@deck.cards.count} cards."
        puts "-------------------------------------------------"
        puts "This is card number #{@turn} out of #{@cards.count}."
        puts "Question: #{@cards[@turn -1 ].question}"
        @turn += 1
        @guess = gets.chomp
        @round.take_turn(@guess)
      elsif @turn <= @cards.count
        puts "#{@round.turns.last.feedback}"
        @round.take_turn(@guess)
      else
        puts "#{@round.turns.last.feedback}"
        puts "****** Game over! ******"
        puts "You had #{@round.number_correct} out of #{@cards.count} for a total score of #{number_to_percentage(@round.percent_correct, :precision => 0)}."
        #determines which categories exist in deck
        @round.turns.each do |turn|
          if @categories.include? turn.card.category
          else
            @categories << turn.card.category
          end
        end
        #reports on score for each category
      @categories.each do |category|
          puts "#{category} - #{number_to_percentage(@round.percent_correct_by_category(category), :precision => 0)} correct"
        end
      end
    end
  end
end