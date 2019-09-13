class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable
         
        #  , :validatable, authentication_keys: [email: true, login: false]

attr_writer :login

def login
  @login || self.username || self.email
end
  
  has_many :links
  has_many :posts

  validates :username, presence: :true, uniqueness: { case_sensitive: false }
 # Only allow letter, number, underscore and punctuation.


  def self.find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_hash).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end

  validates_format_of :username, with: /^[a-zA-Z0-9_\.]*$/, :multiline => true

validate :validate_username

def validate_username
  if User.where(email: username).exists?
    errors.add(:username, :invalid)
  end
end

  # validates :name, presence: true

end
