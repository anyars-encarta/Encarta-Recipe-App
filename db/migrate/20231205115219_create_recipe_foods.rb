class CreateRecipeFoods < ActiveRecord::Migration[7.1]
  def change
    create_table :recipe_foods do |t|
      t.integer :quantity
      t.bigint :recipe_id
      t.bigint :food_id

      t.timestamps
    end

    add_foreign_key :recipe_foods, :recipes, column: :recipe_id
    add_foreign_key :recipe_foods, :foods, column: :food_id
  end
end
