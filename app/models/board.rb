class Board < ActiveRecord::Base
  attr_reader :maze_array, :moves

  def make_maze(maze_string)
    @maze_array = []
    10.times do
      row = maze_string.slice!(0..9)
      @maze_array << row.chars
    end
    @maze_array
  end

  def run
    ## do these need to be global?
    $moves_counter = 0
    $recursion_counter = 0

    @visited_spots = []
    @width = @maze_array[0].length - 1
    @height = @maze_array.length - 1

    @starting_point = find_start(0)
    @moves = [@starting_point]
    @current_location = @starting_point
    @finishing_point = find_finish(0)
    possible_moves = check_neighbors(find_neighbors)
    move_player(possible_moves)
  end

  def space(y, x)
    if @maze[y][x] == 'o'
      return "starting"
    elsif @maze[y][x] == '#'
      return "wall"
    elsif visited?(y, x)
      return "visited"
    elsif @maze[y][x] == '*'
      return "finished"
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
    @maze_array[@current_location[:y]][@current_location[:x]] == '*'
  end

  def find_start(y)
    x = 0
    @maze_array[y].each do |spot|
      if spot == "o"
        @current_location = {:y => y, :x => x}
        ## can I just return @current_location? Don't need to return 'key'?
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
    left = { direction: "left", y: @current_location[:y], x: @current_location[:x] -1 }
    right = { direction: "right", y: @current_location[:y], x: @current_location[:x] + 1 }
    up = { direction: "up", y: @current_location[:y] - 1, x: @current_location[:x] }
    down = { direction: "down", y: (@current_location[:y] + 1), x: @current_location[:x] }

    if space(left[:y], left[:x]) == 'finished'
      neighbors = [left]
    elsif space(right[:y], right[:x]) == 'finished'
      neighbors = [right]
    elsif space(up[:y], up[:x]) == 'finished'
      neighbors = [up]
    elsif space(down[:y], down[:x]) == 'finished'
      neighbors = [down]
    else
      neighbors << left unless @current_location[:x] == 0
      neighbors << right unless @current_location[:x] == @width
      neighbors << up unless @current_location[:y] == 0
      neighbors << down unless @current_location[:y] == @height
    end

    return neighbors
  end

  def check_neighbors(neighbors)
    counter = 0
    while counter < neighbors.length
      y = neighbors[counter][:y]
      x = neighbors[counter][:x]
      if space(y, x) == "wall" || space(y, x) == "visited"
        neighbors.delete_at(counter)
        counter -= 1
      elsif space(y, x) == "finish"
        neighbors = neighbors[counter]
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
    counter = 0
    while counter < possible_moves.length
      old_location = @current_location
      @maze_array[@current_location[:y]][@current_location[:x]] = '.'
      @current_location = {
                            y: possible_moves[counter][:y],
                            x: possible_moves[counter][:x]
                          }
      @maze_array[@current_location[:y]][@current_location[:x]] = 'o' if !finished?

      @visited_spots << @current_location
      last_move = possible_moves[counter][:direction]
      @moves << @current_location
      possibilities = check_neighbors(find_neighbors)
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
end
