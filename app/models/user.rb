class User < ActiveRecord::Base
  has_many :repositories
  has_many :issues, through: :repositories
  before_save :normalize_phone_number
  # validates :url, uniqueness: true, presence: true, format: {with: /https:\/\/github.com/, message: "must be a valid github url"}

  validates :phone_number, format: { with: /\d{3}-\d{3}-\d{4}/ }, allow_nil: true

  def self.find_or_create_from_omniauth(auth)
    User.find_or_create_by(github_uid: auth['uid']).tap do |u|
      u.github_username = auth['info']['nickname']
      u.email = auth['info']['email']
      u.avatar_url = auth['info']['image']
      u.name = auth['info']['name']
      u.save
    end
  end

  def normalize_phone_number
    phone_number = nil if phone_number.blank?
  end
end
