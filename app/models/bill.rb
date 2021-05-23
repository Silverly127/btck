class Bill < ApplicationRecord
	belongs_to :administrator
	belongs_to :user
	has_many :billdetails
end
