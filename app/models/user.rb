class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  has_many :posts, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable


  def self.find_or_create_from_auth_hash(auth_hash)
    find_by_auth_hash(auth_hash) || create_from_auth_hash(auth_hash)
  end

  def facebook
    @facebook ||= Koala::Facebook::API.new(oauth_token)
  end

  def get_profile_info
    self.facebook.get_object('me')
  end

  def get_location
    h = get_profile_info["location"]
    return h["name"]
  end

  def get_books
    self.facebook.get_connection('me','books')
  end

  def get_profile_picture
    self.facebook.get_picture(uid)
  end

  def self.find_by_auth_hash(auth_hash)
    where(
      provider: auth_hash.provider,
      uid: auth_hash.uid
    ).first
  end

  def self.create_from_auth_hash(auth_hash)
    create(
    provider: auth_hash.provider,
    uid: auth_hash.uid,
    email: auth_hash.info.email,
    name: auth_hash.info.name,
    oauth_token: auth_hash.credentials.token,
    oauth_expires_at: Time.at(auth_hash.credentials.expires_at)
    )
  end

  def password_required?
    super && provider.blank?
  end

  def update_with_password(params, *options)
    if encrypted_password_field.blank?
      update_attributes(params, *options)
    else
      super
    end
  end

end
