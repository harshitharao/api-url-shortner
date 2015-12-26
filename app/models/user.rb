class User < ActiveRecord::Base
  require 'securerandom'

  validates :name,  presence: true, length: { maximum: 50 }

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  validates :api_token, uniqueness: true
  before_create :generate_api_token

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def generate_api_token
    begin
      self.api_token = SecureRandom.uuid.gsub(/\-/,'')
    end while self.class.exists?(api_token: api_token)
  end
end
