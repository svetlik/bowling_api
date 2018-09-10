class Api::GamesController < ApplicationController
  def create
    Game.destroy_all
    @game = Game.create

    render json: @game, status: :created
  end

  def show
    @game = Game.last
    game_details = {
      score: @game.score,
      frames: @game.frames,
      last_frame: @game.frame_counter,
      last_roll_score: @game.roll_score
    }

    render json: game_details, status: :ok
  end

  def update
    @game = Game.last

    @game.throw(update_params[:roll_score])

    if @game.update(update_params)
      render json: @game, status: 204
    else
      render json: { message: "Cannot find game." }, status: 404
    end
  end

  rescue InvalidInputError, PinsExceedValidAmountError => e
    render json: {message: e.message}, status: 422
  end

  private

  def update_params
    params.permit(:roll_score)
  end
