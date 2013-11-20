class AddRcScoreToUsers < ActiveRecord::Migration
  def change
    add_column :users, :r_c_score, :integer, :default => 0
  end
end
