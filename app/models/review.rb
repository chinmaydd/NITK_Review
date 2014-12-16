class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :movie
	acts_as_votable

	validates :rating, :comment, presence: true
	validates :rating, numericality: {
		greater_than_or_equal_to: 1,
		less_than_or_equal_to: 5,
		message: "Can be any number ranging from 1-5"
	}
end