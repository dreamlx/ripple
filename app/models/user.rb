class User < ActiveRecord::Base
  validates :nickname, presence: true
  validates :nickname, uniqueness: true
  validates :name, presence: true
  has_secure_password

  has_many :records

  before_create :generate_authentication_token

  def reset_auth_token
    reset_auth_token!
  end

  private
    def generate_authentication_token
      loop do
        self.authentication_token = SecureRandom.base64(64)
        break if !User.find_by(authentication_token: authentication_token)
      end
    end

    def reset_auth_token!
      generate_authentication_token
      save
    end
end
