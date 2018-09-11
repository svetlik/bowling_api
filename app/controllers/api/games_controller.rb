class Api::GamesController < ApplicationController
  def create
    @game = Game.create

    render json: { id: @game.id } , status: :created
  end

  def show
    @game = Game.find(params[:id])
    game_details = {
      id: @game.id,
      score: @game.score,
      frames: @game.frames,
      current_frame: @game.frame_counter+1,
      last_roll_score: @game.roll_score
    }

    render json: game_details, status: :ok
  end

  def update
    begin
    @game = Game.find(params[:id])

    @game.throw(update_params[:roll_score])

    if @game.update(update_params)
      render json: { message: "Game score has been updated successfully."}, status: :ok
    else
      render json: { message: "Game failed to update." }, status: :not_found
    end

    rescue GameOverError, InvalidInputError, PinsExceedValidAmountError => e
      render json: {message: e.message}, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.permit(:roll_score)
  end
end
