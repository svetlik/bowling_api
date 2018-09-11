class Game < ApplicationRecord
  after_create :initialize_frames

  def initialize_frames
    self.frames = Array.new(10){Array.new(3)}
    self.throw_counter = 0
    self.frame_counter = 0
    self.score = 0

    self.save
  end

  def throw(throw_score)
    raise(GameOverError, "Game has already ended.") if game_over?
    game_score(throw_score)
  end

  def game_score(throw_score)
    add_score_to_frame(throw_score)
    add_to_overall_score(throw_score)
  end

  def add_score_to_frame(throw_score)
    validate(throw_score)
    increase_throw_counter

    if last_frame_spare_or_strike(current_frame)
      current_frame[2] = throw_score.to_i
    end

    if empty?(current_frame)
      current_frame[0] = throw_score.to_i
      increase_throw_counter if current_frame[0].to_i == 10
    elsif current_frame != self.frames[9]
      check_for_invalid_second_throw_score(throw_score)
      current_frame[1] = throw_score.to_i
    else
      current_frame[1].present? ? current_frame[2] = throw_score.to_i : current_frame[1] = throw_score.to_i
    end

    update_previous_frames(throw_score)
  end

  def check_for_invalid_second_throw_score(throw_score)
    if throw_score.to_i > 10 - current_frame[0].to_i
      self.throw_counter = 1
      self.save

      raise(PinsExceedValidAmountError, "Pin number cannot exceed #{10 - current_frame[0].to_i}")
    end
  end

  def add_to_overall_score(throw_score)
    self.score = self.frames.flatten.compact.map{|el| el.to_i }.sum
    self.save
  end

  def increase_throw_counter
    if self.throw_counter == 2
      self.throw_counter = 1
      move_frame(1) unless last_frame?
    else
      self.throw_counter += 1
    end
    self.save
  end

  def move_frame(num)
    self.frame_counter += num
    self.save
  end

  def last_frame_spare_or_strike(frame)
    last_frame? && frame[1].present? && (strike?(frame) || spare?(frame))
  end

  def update_previous_frames(throw_score)
    if previous_frame.any? && strike?(previous_frame)
      previous_frame[1].nil? ? previous_frame[1] = throw_score.to_i : (previous_frame[2] = throw_score.to_i unless current_frame[2].present?)
    end
    if previous_frame.any? && spare?(previous_frame)
      update_score_if_applicable_for(previous_frame, throw_score)
    end
    if two_frames_ago.any? && strike?(two_frames_ago) && strike?(previous_frame)
      update_score_if_applicable_for(two_frames_ago, throw_score)
    end
  end

  def update_score_if_applicable_for(frame, throw_score)
    frame[2] = throw_score.to_i unless current_frame[1].present?
  end

  def current_frame
    self.frames[frame_counter]
  end

  def previous_frame
    self.frames[frame_counter-1]
  end

  def two_frames_ago
    self.frames[frame_counter-2]
  end

  def empty?(frame)
    frame[0].nil?
  end

  def last_frame?
    current_frame == self.frames[9]
  end

  def strike?(frame)
    frame[0] == '10'
  end

  def spare?(frame)
    frame[0].to_i + frame[1].to_i == 10
  end

  def game_over?
    last_frame? &&
    (third_throw_present?(current_frame) ||
      (two_throws_present?(current_frame) && open?(current_frame))
    )
  end

  def two_throws_present?(frame)
    [frame[0], frame[1]].all?
  end

  def third_throw_present?(frame)
    frame[2].present?
  end

  def open?(frame)
    frame[0].to_i + frame[1].to_i < 10
  end

  def validate(throw_score)
    if ((/\A\d+\z/) =~ throw_score) != 0
      raise(InvalidInputError, 'Throw score cannot be a non-integer symbol')
    elsif throw_score.to_i < 0
      raise(InvalidInputError, 'Throw score cannot be less than 0')
    elsif throw_score.to_i > 10
      raise(InvalidInputError, 'Throw score cannot be more than 10')
    end
  end
end

class PinsExceedValidAmountError < StandardError
end

class InvalidInputError < StandardError
end

class GameOverError < StandardError
end
