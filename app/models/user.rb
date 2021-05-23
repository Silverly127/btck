class User < ApplicationRecord
	has_many :bills
	has_many :comments
	has_many :products, :through => :comments
end
