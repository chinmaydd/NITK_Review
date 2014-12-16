class CreateReviews < ActiveRecord::Migration
  def up
    create_table :reviews do |t|
    	t.float "rating"
    	t.text "comment"
    	t.integer "user_id"
    	t.timestamps
    end
  end

  def down
  	drop_table :reviews
  end
  	
end
