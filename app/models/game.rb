class Game < ApplicationRecord
  validates :score, format: { with: /\A\d+\z/, message: "Integer only. No sign allowed." }
end
