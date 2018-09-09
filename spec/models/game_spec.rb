require 'rails_helper'

RSpec.describe Game, type: :model do

  let(:game) { Game.create }

  context 'new game' do

    it 'has ten frames at the start' do
      expect(game.frames.count).to eq(10)
    end

    it 'starts at frame 0' do
      expect(game.frame_counter).to eq(0)
    end

    it 'starts with score 0' do
      expect(game.score).to eq(0)
    end

    it 'ends after the last throw for the last frame' do
      #
    end
  end

  context 'input' do
    it 'does not allow a number lower than 0' do
      throw_count = '-4'
      expect{ game.throw(throw_count) }.to raise_error('Throw score cannot be a non-integer symbol')
    end

    it 'does not allow a number higher than 10' do
      throw_count = '12'
      expect{ game.throw(throw_count) }.to raise_error('Throw score cannot be more than 10')
    end

    it 'does not allow a floating point number' do
      throw_count = '4.3'
      expect{ game.throw(throw_count) }.to raise_error('Throw score cannot be a non-integer symbol')
    end

    it 'does not allow a symbol other than integers' do
      throw_count = 'f'
      expect { game.throw(throw_count) }.to raise_error('Throw score cannot be a non-integer symbol')
    end
  end

  context 'frame' do
    it 'progresses to the next one after second throw for that frame' do
      #
    end

    it 'does not progress on invalid input' do
      #
    end

    it 'result of second roll does not add up to more than 10' do
      game.throw('3')
      expect { game.throw('8') }.to raise_error('Pin number cannot exceed 7')
    end
  end

  context 'score' do
    it 'is updated after each throw' do
      game.throw('3')
      expect(game.score).to eq(3)
    end

    it "from next two throws is doubled and added to the overall score in case of a strike" do
      game.throw('10')
      game.throw('3')
      game.throw('5')
      expect(game.score).to eq(26)
    end

    it "checks that in case of a spare the next throw's score is doubled and added to the overall score" do
      game.throw('5')
      game.throw('5')
      game.throw('4')
      expect(game.score).to eq(18)
    end

    it "checks that in case of a spare at the last round, one more throw is granted" do
      9.times do
        game.throw('1')
        game.throw('2')
      end

      game.throw('5')
      game.throw('5')
      game.throw('5')

      expect(game.score).to eq(42)
    end

    it "checks that in case of a strike at the last round, one more throw is granted" do
      9.times do
        game.throw('5')
        game.throw('2')
      end

      game.throw('10')
      game.throw('4')
      game.throw('5')

      expect(game.score).to eq(82)
    end

    it "emulate sample game" do
      # frame 0
      game.throw('10')
      # frame 1
      game.throw('7')
      game.throw('3')
      # frame 2
      game.throw('9')
      game.throw('0')
      # frame 3
      game.throw('10')
      # frame 4
      game.throw('0')
      game.throw('8')
      # frame 5
      game.throw('8')
      game.throw('2')
      # frame 6
      game.throw('0')
      game.throw('6')
      # frame 7
      game.throw('10')
      # frame 8
      game.throw('10')
      # frame 9
      game.throw('10')
      game.throw('8')
      game.throw('1')

      expect(game.score).to eq(167)
    end
  end
end
