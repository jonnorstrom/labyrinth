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
    @board.maze[params[:number].to_i] = '#'
    @board.save
    render 'index'
  end
end
