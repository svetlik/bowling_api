class Api::GamesController < ApplicationController
  def create
    @game = Game.create

    render json: @game, status: :created
  end

  def show
    @game = Game.find(params[:id])

    render json: @game, status: :ok
  end

  def update
    debugger
    @game = Game.find(params[:id])

    # if this number is a valid score for this throw
    if @game.update(update_params)
      render json: @game, status: :updated
    else
      render json: { errors: @game.errors }, status: 422
    end
  end

  private

  def update_params
    params.require(:game).permit(:score)
  end
end
