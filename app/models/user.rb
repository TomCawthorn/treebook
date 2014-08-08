class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

   has_many :statuses
   has_many :user_friendships
   has_many :friends, through: :user_friendships

   validates 	:first_name, :last_name, :profile_name, presence: true
   validates	:profile_name, 
   					uniqueness: true,
   					format: {
   						with: /\A[a-zA-Z0-9_\-]+\z/,
   						message: "Username must be formatted correctly."
   					}


	def full_name
   		first_name + " " + last_name
	end

	         
end
