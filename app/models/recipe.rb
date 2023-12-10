class Recipe < ApplicationRecord
  belongs_to :user
  belongs_to :inventory, optional: true
  has_many :recipe_foods
  has_many :foods, through: :recipe_foods
end
