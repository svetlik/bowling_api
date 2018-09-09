class Game < ApplicationRecord
  validates :score, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }

  after_create :initialize_frames

  def initialize_frames
    self.frames = Array.new(10){Array.new(3)}
    self.throw_counter = 0
    self.current_frame = 0
    self.score = 0

    self.save
  end

  def throw(throw_score)
    if game_over?
      raise Exception.new('game over')
    else
      game_score(throw_score)
    end
  end

  def game_score(throw_score)
    add_score_to_frame(throw_score)
    add_to_overall_score(throw_score)
  end

  def increase_throw_counter
    if self.throw_counter == 2
      self.throw_counter = 1
      move_frame(1) unless cur_frame == self.frames[9]
    else
      self.throw_counter += 1
    end
    self.save
  end

  def move_frame(num)
    self.current_frame += num
    self.save
  end

  def cur_frame
    self.frames[current_frame]
  end

  def prev_frame
    self.frames[current_frame-1]
  end

  def prev_prev_frame
    self.frames[current_frame-2]
  end

  def add_score_to_frame(throw_score)
    validate(throw_score)
    increase_throw_counter
    if last_frame? && !cur_frame[1].nil? && (cur_frame[0].to_i == 10 || cur_frame[0] + cur_frame[1] == 10)
      debugger
      cur_frame[2] = throw_score.to_i
      puts 'game over'
    end
    if cur_frame[0].nil?
      cur_frame[0] = throw_score.to_i
      if cur_frame[0].to_i == 10
        puts 'strike'
        increase_throw_counter unless cur_frame == self.frames[9]
      end
    else
      if throw_score.to_i > 10 - cur_frame[0].to_i && cur_frame != self.frames[9]
        self.throw_counter = 1
        self.save

        raise Exception.new("Pin number cannot exceed #{10 - cur_frame[0].to_i}")
      end
      cur_frame[1] = throw_score.to_i
      if cur_frame[0].to_i + cur_frame[1].to_i == 10
        puts 'spare'
      end
    end

    if prev_frame.any? && prev_frame[0] == '10'
      prev_frame[1].nil? ? prev_frame[1] = throw_score.to_i : prev_frame[2] = throw_score.to_i
    end
    if prev_frame.any? && prev_frame[0].to_i + prev_frame[1].to_i == 10
      prev_frame[2] = throw_score.to_i
    end
    if prev_prev_frame.any? && prev_prev_frame[0] == '10' && prev_frame[0] == '10'
      prev_prev_frame[2] = throw_score.to_i
    end
  end

  def last_frame?
    cur_frame == self.frames[9]
  end

  def add_to_overall_score(throw_score)
    self.score = self.frames.flatten.compact.map{|el| el.to_i }.sum
    self.save
  end

  def game_over?
    cur_frame == self.frames[9] && (cur_frame[2].present? || ([cur_frame[0], cur_frame[1]].all? && cur_frame[0].to_i + cur_frame[1].to_i < 10))
  end

  def validate(throw_score)
    raise Exception.new('invalid input') unless ((/\A\d+\z/) =~ throw_score) == 0 && (1..10).include?(throw_score.to_i)
  end
end
