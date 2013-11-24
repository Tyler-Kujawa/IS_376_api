class CreateSurveys < ActiveRecord::Migration
  def change
    create_table :surveys do |t|
      t.integer :question_1_rating
      t.integer :question_2_rating
      t.integer :question_3_rating
      t.integer :commitment_id
      t.integer :user_id

      t.timestamps
    end
  end
end
