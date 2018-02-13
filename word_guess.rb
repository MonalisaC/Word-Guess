require 'faker'
require 'colorize'

class Game
  attr_accessor :word, :board, :attempts, :themes, :used_letters_array

  def initialize
    @word = ""
    @board = ""
    @attempts_left = 5
    @themes = [ "music", "food", "science" ]
    @used_letters_array = []
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
       letter = gets.chomp
       return letter
    end

    def match_letter letter_guessed
      return @word.downcase.include?letter_guessed
    end

    def update_board letter_guessed
      # @word.split("").each_index
      word_split = @word.split("")
      get_word_index = word_split.each_index.select {|index| word_split[index].downcase == letter_guessed}
      # @board.split("").each_index{}
      board_split = @board.split("")
      get_word_index.each {|index_element| board_split[index_element] = word_split [index_element]}
      @board = board_split.join
    end

    def play_game
      theme = pick_theme
      @word = get_theme_word theme
      create_board
      until @attempts_left == 0
        display_board
        letter_guessed = guessed_letter
        if match_letter(letter_guessed)
          puts "Right guess"
          update_board(letter_guessed)
          if used_letters_array.include?letter_guessed
            puts "You have already tried this letter. Used letters: #{@used_letters_array.join(", ")}".red
          end
          used_letters_array << letter_guessed
        else
          if used_letters_array.include?letter_guessed
            puts "You have already tried this letter. Used letters: #{@used_letters_array.join(", ")}".red
          else
            used_letters_array << letter_guessed
            @attempts_left -= 1
             puts "Sorry! wrong guess"
          end
        end
        check_win
      end
      puts "Sorry, no more attempts left. It was #{@word}".blue
    end

    def check_win
      if @board == @word
        puts "Yay! you win.".bold
        exit
      end
    end
end
game = Game.new
game.play_game
