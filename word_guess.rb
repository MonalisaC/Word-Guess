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

end
game = Game.new
