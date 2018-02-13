require 'faker'
require 'colorize'

class Game
  attr_reader :word, :board, :attempts, :themes

  def initialize
    @word = ""
    @board = ""
    @attempts_left = 5
    @themes = [ "music", "food", "science" ]
  end

  def get_theme_word theme
    case theme
    when "music"
      return Faker::Music.instrument
    when "food"
      return Faker::Food.ingredient
    when "science"
      return Faker::Science.element
    end
  end

  def create_board
    word_size = @word.length
    @board = "-" * word_size
  end

  def display_board
    show_flower
    puts @board
  end
end
game = Game.new
