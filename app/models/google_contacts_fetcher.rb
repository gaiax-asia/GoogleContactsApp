require 'open-uri'

class GoogleContactsFetcher
  def initialize(token, user)
    @token = token
    @user  = user
  end

  def fetch
    contacts = JSON.parse(open("https://www.google.com/m8/feeds/contacts/default/full?v=3&alt=json",
                               "Authorization" => "Bearer #{@token}").read)
    contacts['feed']['entry'].each do |contact|
      @user.contacts.create(email: contact['gd$email'][0]['address'], # just the first email for brevity
                           fullname: contact['gd$name'] && contact['gd$name']['gd$fullName'] && contact['gd$name']['gd$fullName']['$t'])
    end
  end
end
