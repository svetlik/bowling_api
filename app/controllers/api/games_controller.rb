class Api::GamesController < ApplicationController
  def create
    Game.destroy_all
    @game = Game.create

    render json: @game, status: :created
  end

  def show
    @game = Game.last

    render json: @game, status: :ok
  end

  def update
    @game = Game.last

    # if this number is a valid score for this throw
    @game.throw(update_params[:score])

    if @game.update(update_params)
      render json: @game, status: :updated
    else
      render json: { errors: @game.errors }, status: 422
    end
  end

  private

  def update_params
    params.permit(:score)
  end
end
