class Game < ApplicationRecord
  validates :score, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }

  after_create :initialize_frames

  def initialize_frames
    self.frames = Array.new(10){Array.new(3)}
    self.throw_counter = 0
    self.current_frame = 0

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
      move_frame(1)
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

  def add_score_to_frame(throw_score)
    increase_throw_counter
    if cur_frame[0].nil?
      cur_frame[0] = throw_score.to_i
      if cur_frame[0].to_i == 10
        puts 'strike'
        increase_throw_counter
      end
    else
      cur_frame[1] = throw_score.to_i
      if cur_frame[0].to_i + cur_frame[1].to_i == 10
        puts 'spare'
      end
    end
  end

  def add_to_overall_score(throw_score)
    puts "before #{self.score}"
    self.score = self.score + throw_score.to_i
    puts "after #{self.score}"
    self.save
  end

  def game_over?
    self.current_frame >= 10
  end
end
