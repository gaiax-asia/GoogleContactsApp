class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:google_oauth2]

  has_many :contacts, dependent: :destroy

  def self.find_for_google_oauth2(access_token, logged_user)
    data = access_token.info
    user = User.where(email: data['email']).first

    unless user
      user = User.create(firstname: data['firstname'], lastname: data['lastname'], 
                         email: data['email'], password: Devise.friendly_token)
      #fetch contacts
      fetcher = GoogleContactsFetcher.new(access_token['credentials']['token'], user)
      fetcher.fetch
    end
    user
  end
end
