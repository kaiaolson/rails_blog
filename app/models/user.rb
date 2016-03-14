class User < ActiveRecord::Base
  has_many :posts, dependent: :nullify
  has_many :comments, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post

  has_secure_password
  validates :password, length: {minimum: 6}, on: :create
  validates :first_name, presence: true, on: :create
  validates :last_name, presence: true, on: :create
  validates :email, presence: true, uniqueness: true,
            format:  /\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
            on: :create,
            unless: :from_oauth?

  before_create :generate_api_key
  serialize :twitter_raw_data, Hash


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

  def self.find_twitter_user(omniauth_data)
    where(provider: "twitter", uid: omniauth_data["uid"]).first
  end

  def self.create_from_twitter(twitter_data)
    name = twitter_data["info"]["name"].split(" ")
    user = User.create(provider: "twitter",
    uid: twitter_data["uid"],
    first_name: name[0],
    last_name: name[1],
    password: SecureRandom.hex(16),
    twitter_consumer_token: twitter_data["credentials"]["token"],
    twitter_consumer_secret: twitter_data["credentials"]["secret"],
    twitter_raw_data: twitter_data)
  end


  private

  def from_oauth?
    uid.present? && provider.present? && provider == "twitter"
  end

  def generate_api_key
    self.api_key = SecureRandom.hex(32)
    while User.exists?(api_key: self.api_key)
      self.api_key = SecureRandom.hex(32)
    end
  end
end
