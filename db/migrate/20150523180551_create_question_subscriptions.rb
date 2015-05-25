class CreateQuestionSubscriptions < ActiveRecord::Migration
  def change
    create_table :question_subscriptions do |t|
      t.references :question, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    add_index :question_subscriptions, [:question_id, :user_id], unique: true
  end
end
