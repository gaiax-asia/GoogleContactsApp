class Contact < ActiveRecord::Base
  belongs_to :user
  validates :user_id, presence: true

  serialize :phones
  serialize :addresses
  serialize :emails
  serialize :positions
end
