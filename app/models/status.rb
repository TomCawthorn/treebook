class Status < ActiveRecord::Base

	belongs_to :user

	validates :user_id, presence: true
	validates :content, presence: true, length: { minimum: 2 }

end
