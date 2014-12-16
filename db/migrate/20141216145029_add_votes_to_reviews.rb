class AddVotesToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews, :votes, :integer
  end
end
