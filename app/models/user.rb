class User < ActiveRecord::Base
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  validates :session_token, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true }
  after_initialize :ensure_session_token

  has_many :subs,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :Sub

  has_many :posts,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :Post

  attr_reader :password

  def self.find_by_credentials(user_name, pw)
    user = User.find_by(username: user_name)
    return user if user && user.is_password?(pw)
    nil
  end

  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(32)
    self.save!
    self.session_token
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(32)
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)
  end

  def is_password?(pw)
    pw_digest = BCrypt::Password.new(self.password_digest)
    pw_digest.is_password?(pw)
  end

end
