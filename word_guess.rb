require 'faker'
require 'colorize'

class Game
  attr_accessor :word, :board, :attempts, :themes, :used_letters_array, :player

  def initialize player
    @player = player
    @word = ""
    @board = ""
    @attempts_left = 5
    @themes = [ "music", "color", "science" ]
    @used_letters_array = []
  end


  def get_theme_word theme
    case theme
    when "music"
      return Faker::Music.instrument
    when "color"
      return Faker::Color.color_name
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
    puts "Used letters: #{@used_letters_array.join(", ")}".bold
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

    def include_letter letter_guessed
      return used_letters_array.include?letter_guessed
    end

    def display_letter letter_guessed
        if include_letter letter_guessed
        puts "You have already tried this letter. Used letters.".red
      end
    end

    def play_game
      theme = @player.pick_theme(@themes)
      @word = get_theme_word theme
      create_board
      until @attempts_left == 0
        display_board
        letter_guessed = @player.guessed_letter(@attempts_left)
        if match_letter(letter_guessed)
          puts "Right guess! :)".magenta
          update_board(letter_guessed)
          display_letter letter_guessed
          used_letters_array << letter_guessed
        else
           display_letter letter_guessed
           if !include_letter letter_guessed
             used_letters_array << letter_guessed
            @attempts_left -= 1
          end
            puts "Sorry! wrong guess"
        end
        check_win
      end
      show_flower
      puts "Sorry, no more attempts left. You lost :(. It was #{@word}".blue
    end

    def check_win
      if @board == @word
        puts "Yay! you win :).".bold
        exit
      end
    end
end

class Player
  attr_accessor :name

  def initialize name
    @name = name
    puts "Are you game #{@name}!".bold.blue.on_white.blink
  end

  def pick_theme themes
    puts "Choose theme:"
    puts themes
    chosen_theme = gets.chomp.downcase
    until chosen_theme == themes[0] || chosen_theme == themes[1] || chosen_theme == themes[2]
      puts "That is not valid!".red
      puts "Choose theme:"
      puts themes
      chosen_theme = gets.chomp
    end
    return chosen_theme
  end

  def guessed_letter attempts_left
    puts "Please pick a letter (a-z). Your attempts_left are #{attempts_left}"
     letter = gets.chomp.downcase
    until letter =~ /^[a-zA_Z\s]$/
      puts "That is not a letter!".red
       puts "Please pick a letter (a-z). Your attempts_left are #{attempts_left}"
        letter = gets.chomp.downcase
    end
     return letter
  end


end

player_instance = Player.new("Anonymous11")
game_instance = Game.new(player_instance)
game_instance.play_game
