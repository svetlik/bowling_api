require 'rails_helper'

RSpec.describe :games, type: :request do
  context 'POST /games' do
    it 'creates a game' do
      post api_games_path
      expect(response).to have_http_status(201)
    end
  end

  context 'GET /games/:id' do
    let(:game) { Game.create }

    it 'shows game info' do
      get api_game_path
      expect(response).to have_http_status(200)
      # check response
    end
  end

  context 'PUT /games/:id' do
    let(:game) { Game.create }

    it 'updates game score' do
      put api_game_path("roll_score" => "3")
      expect(response).to have_http_status(204)
      expect(Game.last.score).to eq 3
    end

    it 'should return error on invalid input' do

    end
  end
end
