class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  enum role: [:user, :vip, :admin]
  after_initialize :set_default_role, :if => :new_record?

  

  #   Then you can call:

  # user.admin?
  # user.admin!
  # user.role
  # user.user?
  # user.vip?

  def set_default_role
    self.role ||= :admin
  end


  has_one_attached :avatar
  has_many :links
  has_many :posts
  acts_as_voter

  attr_writer :login
  def login
    @login || self.username || self.email
  end
    
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :authentication_keys => {email: true, login: false}
    
  # For more security..
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      if conditions[:username].nil?
        where(conditions).first
      else
        where(username: conditions[:username]).first
      end
    end
  end

  validates :username, presence: :true, uniqueness: { case_sensitive: false }
  



# validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true



  def validate_username
    if User.where(email: username).exists?
      errors.add(:username, :invalid)
    end
  end

  

  # validates :name, presence: true

end


