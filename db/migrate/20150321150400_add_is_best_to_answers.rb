class AddIsBestToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :is_best, :boolean, default: false
    update "UPDATE answers SET is_best = FALSE WHERE is_best IS NULL"
  end
end
