class BoardsController < ApplicationController
  respond_to :html, :js

  def index
    board = Board.create
    99.times do
      board.maze << '.'
      board.save
    end

    respond_to do |format|
      format.html
      format.json { render json: @resource }
    end
  end
end
