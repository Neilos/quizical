class GamesController < ApplicationController
  
  def index
  end

  def create
    game = Game.new
    game.save
    session[:game_id] = game.id
    session[:question_number] = 1
    redirect_to new_response_path
  end

  def new
  end

end
