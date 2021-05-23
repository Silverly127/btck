class Product < ApplicationRecord
	belongs_to :category
	has_many :billdetails
	has_many :comments
	has_many :users, :through => :comments
end
