class Board < ActiveRecord::Base


  def make_maze(maze_string)
    @maze_array = []
    10.times do
      row = maze_string.slice(0..9)
      @maze_array << row.chars
    end
  end





  # def initialize
  #   @starting_point = {y: 0, x: 0}
  #   @finishing_point = {y: 0, x: 0}
  #   @current_location = @starting_point
  #   @maze = [[][][]]
  #   @visited_spots = []
  #   $moves_counter = 0
  #   $recursion_counter = 0
  # end

  def run
    read_maze
    @starting_point = find_start(0)
    @finishing_point = find_finish(0)
    possible_moves = check_neighbors(find_neighbors)
    move_player(possible_moves)
  end

  def read_maze
    @width = @maze_array[0].length - 1
    @height = @maze_array.length - 1
  end

  def space(y, x)
    if @maze_array[y][x] == 'o'
      return "starting"
    elsif @maze_array[y][x] == '#'
      return "wall"
    elsif visited?(y, x)
      return "visited"
    else
      return "open"
    end
  end

  def visited?(y, x)
    @visited_spots.each do |spot|
      return true if spot == {y: y, x: x}
    end
    false
  end

  def finished?
    @maze_array[@current_location[:y]][current_location[:x]] == '*'
  end

  def find_start(y)
    x = 0
    @maze_array[y].each do |spot|
      if spot == "o"
        @current_location = {:y => y, :x => x}
        key = {:y => y, :x => x}
        return key
      else
        x += 1
      end
    end
    find_start(y + 1)
  end

  def find_finish(y)
    x = 0
    @maze_array[y].each do |spot|
      if spot == "*"
        key = {:y => y, :x => x}
        return key
      else
        x += 1
      end
    end
    find_finish(y + 1)
  end

  def find_neighbors
    neighbors = []
    if @current_location[:x] == 0
    else
      left = { direction: "left", y: @current_location[:y], x: @current_location[:x] -1 }
      neighbors << left
    end

    if @current_location[:x] == @width
    else
      right = { direction: "right", y: @current_location[:y], x: @current_location[:x] + 1 }
      neighbors << right
    end

    if @current_location[:y] == 0
    else
      up = { direction: "up", y: @current_location[:y] - 1, x: @current_location[:x] }
      neighbors << up
    end

    if @current_location[:y] == @height
    else
      down = { direction: "down", y: @current_location[:y] + 1, x: @current_location[:x] }
      neighbors << down
    end
    neighbors
  end

  def check_neighbors(neighbors)
    counter = 0
    while counter < neighbors.length
      y = neighbors[counter][:y]
      x = neighbors[counter][:x]
      if space(y, x) == "wall" || space(y, x) == "visited"
        neighbors.delete_at(counter)
        counter -= 1
      end
      counter += 1
    end
    neighbors
  end

  def opposite_direction(direction)
    case direction
    when 'left' then return 'right'
    when 'right' then return 'left'
    when 'up' then return 'down'
    when 'down' then return 'up'
    end
  end

  def move_player(possible_moves)
    return "YOU DIDN'T DIE TODAY" if finished?
    # p possible_moves
    counter = 0
    while counter < possible_moves.length


      # p "Old location:"
      old_location = @current_location
      @maze_array[@current_location[:y]][current_location[:x]] = '.'
      # p old_location
      # p "New location:"
      @current_location = {
                            y: possible_moves[counter][:y],
                            x: possible_moves[counter][:x]
                          }
      @maze_array[@current_location[:y]][current_location[:x]] = 'o' if !finished?
      reset_screen
      puts pretty_board(@maze_array)
      sleep(0.08)
      # p @current_location
      @visited_spots << @current_location
      last_move = possible_moves[counter][:direction]
      # p last_move
      # p "Possibilities:"
      possibilities = check_neighbors(find_neighbors)
      # p possibilities
      possibilities.each_with_index do |possibility, index|
        if possibility[:direction] == opposite_direction(last_move)
          possibilities.delete_at(index)
        end
      end
      $moves_counter += 1
      move_player(possibilities)
      return "YOU DIDN'T DIE TODAY" if finished?
      counter += 1
    end
    $recursion_counter += 1
  end

  def reset_screen
    clear_screen
    move_to_home
  end

  def clear_screen
    print "\e[2J"
  end

  def move_to_home
    print "\e[H"
  end

  def pretty_board(maze_array)
    string = ""
    maze_array.each do |row|
      string << "#{row.join('')}\n"
    end
    string << "Moves: #{$moves_counter}\n"
    string << "Recursions: #{$recursion_counter}"
    string
  end
end
