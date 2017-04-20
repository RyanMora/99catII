class User < ActiveRecord::Base
  validates :user_name, :session_token, :password_digest,
    presence: true, uniqueness: true
  # TODO: validate password length
  after_initialize :ensure_session_token

  has_many :cats,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Cat

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= User.generate_session_token
  end

  def reset_session_token!
    self.session_token = User.generate_session_token
    self.save!
    self.session_token
  end

  def password=(password)
    @password = password #for password length validation
    self.password_digest = BCrypt::Password.create(password)

  end

  def is_password?(password)
    self.password_digest.is_password?(password)
  end

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    return user if user && BCrypt::Password.new(user.password_digest).is_password?(password)
    nil
  end
end
