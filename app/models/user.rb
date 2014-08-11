class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :statuses
  has_many :user_friendships
  has_many :friends, -> { where(user_friendships: { state: "accepted" }) }, 
                          through: :user_friendships
  has_many :pending_user_friendships, -> { where state: "pending" },
                                            class_name: 'UserFriendship',
                                            foreign_key: :user_id
  has_many :pending_friends,  through: :pending_user_friendships, 
                              source: :friend
  has_many :requested_user_friendships, -> { where state: "requested" },
                                            class_name: 'UserFriendship',
                                            foreign_key: :user_id
  has_many :requested_friends,  through: :requested_user_friendships, 
                              source: :friend
  has_many :blocked_user_friendships, -> { where state: "blocked" },
                                            class_name: 'UserFriendship',
                                            foreign_key: :user_id
  has_many :blocked_friends,  through: :blocked_user_friendships, 
                              source: :friend
  has_many :accepted_user_friendships, -> { where state: "accepted" },
                                            class_name: 'UserFriendship',
                                            foreign_key: :user_id
  has_many :accepted_friends,  through: :accepted_user_friendships, 
                              source: :friend


   validates 	:first_name, :last_name, :profile_name, presence: true
   validates	:profile_name, 
   					uniqueness: true,
   					format: {
   						with: /\A[a-zA-Z0-9_\-]+\z/,
   						message: "Username must be formatted correctly."
   					}


  def to_param
    profile_name
  end

	def full_name
   		first_name + " " + last_name
	end

  def has_blocked?(other_user)
    blocked_friends.include?(other_user)
  end

	         
end
