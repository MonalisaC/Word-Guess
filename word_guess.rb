require 'faker'
require 'colorize'

class Game
  attr_reader :word, :board, :attempts, :themes, :used_letters_array, :player, :image

# Constructor
  def initialize player, image
    @image = image
    @player = player
    @word = ""
    @board = ""
    @attempts_left = 5
    @themes = [ "music", "color", "science" ]
    @used_letters_array = []
  end

# Returns word based on theme
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
    @image.show_flower @used_letters_array, @attempts_left
    puts @board
  end

# Returns boolean value
  def match_letter letter_guessed
    return @word.downcase.include?letter_guessed
  end


  def update_board letter_guessed
    word_split = @word.split("")
    # Returns index number of rightly guessed letter
    get_word_index = word_split.each_index.select {|index| word_split[index].downcase == letter_guessed}
    board_split = @board.split("")
    # Fill the board with right letters
    get_word_index.each {|index_element| board_split[index_element] = word_split [index_element]}
    # Returns a joined string
    @board = board_split.join
  end

# Returns boolean value
  def include_letter letter_guessed
    return used_letters_array.include?letter_guessed
  end

  def display_letter letter_guessed
    if include_letter letter_guessed
      puts "You have already tried this letter.".red
    end
  end

  def play_game
    theme = @player.pick_theme(@themes)
    @word = get_theme_word theme
    create_board
    until @attempts_left == 0
      display_board
      letter_guessed = @player.guessed_letter(@attempts_left)
      # If lette matches output message, update board.
      if match_letter(letter_guessed)
        puts "Right guess! :)".magenta
        update_board(letter_guessed)
        # Show message
        display_letter letter_guessed
        # Guessed letters are stored in an array
        used_letters_array << letter_guessed
      else
        display_letter letter_guessed
        # If does not include letter still push the letter in used letter array and reduce the attempts_left by 1
        if !include_letter letter_guessed
          used_letters_array << letter_guessed
          @attempts_left -= 1
        end
        puts "Sorry! wrong guess"
      end
      # Declares winner
      check_win
    end
    # Display images based on attempts_left
    @image.show_flower @used_letters_array, @attempts_left
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
  attr_reader :name

  def initialize name
    @name = name
    puts "Are you game #{@name}!".bold.blue.on_white.blink
  end

# User chooses theme
  def pick_theme themes
    puts "Choose theme:"
    puts themes
    chosen_theme = gets.chomp.downcase
    # Until valid theme is entered keep asking
    until chosen_theme == themes[0] || chosen_theme == themes[1] || chosen_theme == themes[2]
      puts "That is not valid!".red
      puts "Choose theme:"
      puts themes
      chosen_theme = gets.chomp
    end
    return chosen_theme
  end

# Returns letter guessed by user
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

class Image
  attr_reader :image_type

  def initialize image_type
    @image_type = image_type
  end

  def show_flower used_letters_array, attempts_left
    # Remove duplicates and return a string of each element
    puts "Used letters: #{used_letters_array.uniq.join(", ")}".bold
    case attempts_left
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
end
image_instance = Image.new("ascii")
player_instance = Player.new("Anonymous11")
game_instance = Game.new(player_instance, image_instance)
game_instance.play_game
