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

  def pick_theme
    puts "Choose theme:"
    puts @themes
    chosen_theme = gets.chomp
    return chosen_theme
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

  def show_flower
    case @attempts_left
    when 5
      puts """
      (@)(@)(@)(@)(@)
        ,\,\,|,/,/,
           _\|/_
          |_____|
           |   |
           |___|
      """.yellow
    when 4
      puts """
      (@)(@)(@)(@)
       ,\,\,|,/,/,
          _\|/_
         |_____|
          |   |
          |___|
      """.magenta
    when 3
      puts """
       (@)(@)(@)
      ,\,\,|,/,/,
       _\|/_
      |_____|
       |   |
       |___|
      """.green
    when 2
      puts """
       (@)(@)
    ,\,\,|,/,/,
       _\|/_
      |_____|
       |   |
       |___|
      """.blue
    when 1
      puts """
        (@)
      ,\,\,|,/,/,
         _\|/_
        |_____|
         |   |
         |___|
      """.light_red
    when 0
      puts """
      Game Over
        ,\,\,|,/,/,
           _\|/_
          |_____|
           |   |
           |___|
      """.red
    end
  end

    def guessed_letter
      puts "Please pick a letter (a-z). Your attempts_left are #{@attempts_left}"
      return guessed_letter = gets.chomp
    end

    def match_letter
      return @word.include?guessed_letter
    end
    def play_game
      theme = pick_theme
      @word = get_theme_word theme
      create_board
    end

end
game = Game.new
