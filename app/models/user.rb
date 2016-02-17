class User < ActiveRecord::Base
  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify

  has_secure_password
  validates :password, length: {minimum: 6}, on: :create
  validates :first_name, presence: true, on: :create
  validates :last_name, presence: true, on: :create
  validates :email, presence: true, uniqueness: true,
            format:  /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            on: :create

   def full_name
     "#{first_name} #{last_name}".titleize
   end

   def send_password_reset
     generate_token(:password_reset_token)
     self.password_reset_sent_at = Time.zone.now
     save!
     UserMailer.password_reset(self).deliver_now
   end

   def generate_token(column)
     begin
       self[column] = SecureRandom.urlsafe_base64
     end while User.exists?(column => self[column])
   end
end
