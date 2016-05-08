class BoardsController < ApplicationController
  respond_to :html, :js

  def index
    @board = Board.create
    99.times do
      @board.maze << '.'
      @board.save
    end
  end

  def update
    @board = Board.find(params[:id])
    type = case params[:type]
           when 'path' then '.'
           when 'maze-walker' then 'o'
           when 'finish-line' then '*'
           when 'wall' then '#'
           end
    @board.maze[params[:number].to_i] = type
    @board.save
    render 'index'
  end

  def show
    @board = Board.find(params[:id])
    @board.make_maze(@board.maze)
    @board.run
    @board.moves.shift
    @all_moves = @board.moves

    respond_to do |format|
      format.json { render :json => { moves: @all_moves} }
    end
  end
end
