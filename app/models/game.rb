class Game < ApplicationRecord
  validates :score, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }

  after_create :initialize_frames

  def initialize_frames
    self.frames = Array.new(10){Array.new(3)}
    self.throw_counter = 0
    self.frame_counter = 0
    self.score = 0

    self.save
  end

  def throw(throw_score)
    puts 'game over' if game_over?
    game_score(throw_score)
  end

  def game_score(throw_score)
    add_score_to_frame(throw_score)
    add_to_overall_score(throw_score)
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

  def current_frame
    self.frames[frame_counter]
  end

  def previous_frame
    self.frames[frame_counter-1]
  end

  def two_frames_ago
    self.frames[frame_counter-2]
  end

  def add_score_to_frame(throw_score)
    validate(throw_score)
    increase_throw_counter

    if last_frame_spare_or_strike(current_frame)
      current_frame[2] = throw_score.to_i
      puts 'game over'
    end

    if empty?(current_frame)
      current_frame[0] = throw_score.to_i
      if current_frame[0].to_i == 10
        puts 'strike'
        increase_throw_counter unless last_frame?
      end
    elsif current_frame != self.frames[9]
      if throw_score.to_i > 10 - current_frame[0].to_i
        self.throw_counter = 1
        self.save

        raise Exception.new("Pin number cannot exceed #{10 - current_frame[0].to_i}")
      end
      current_frame[1] = throw_score.to_i
    end

    if previous_frame.any? && strike?(previous_frame)
      previous_frame[1].nil? ? previous_frame[1] = throw_score.to_i : previous_frame[2] = throw_score.to_i
    end
    if previous_frame.any? && spare?(previous_frame)
      previous_frame[2] = throw_score.to_i unless current_frame[1].present?
    end
    if two_frames_ago.any? && strike?(two_frames_ago) && strike?(previous_frame)
      two_frames_ago[2] = throw_score.to_i
    end
  end

  def last_frame_spare_or_strike(frame)
    last_frame? && frame[1].present? && (strike?(frame) || spare?(frame))
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

  def add_to_overall_score(throw_score)
    self.score = self.frames.flatten.compact.map{|el| el.to_i }.sum
    self.save
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
      raise Exception.new('Throw score cannot be a non-integer symbol')
    elsif throw_score.to_i < 0
      raise Exception.new('Throw score cannot be less than 0')
    elsif throw_score.to_i > 10
      raise Exception.new('Throw score cannot be more than 10')
    end
  end
end
