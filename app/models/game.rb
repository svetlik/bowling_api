class Game < ApplicationRecord
  validates :score, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }

  def throw(score)
    if game_over?
      raise Exception.new('game over')
    else
      add_score_to_frame(score)
      add_score_to_overall_score(score)
    end
  end

  def add_score_to_frame(score)
    self.frames << score.to_i
  end

  def add_score_to_overall_score(score)
    self.score += score.to_i
  end

  def game_over?
    self.frames.count >= 10
  end
end
