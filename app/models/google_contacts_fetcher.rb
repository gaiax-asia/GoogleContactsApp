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
      phones = (contact['gd$phoneNumber'] || []).inject({}) do |old, current|
        key = current['rel'].split('#')[1]
        val = current['$t']
        old[key] = val; old
      end

      addresses = (contact['gd$structuredPostalAddress'] || []).inject({}) do |old, current|
        key = current['rel'].split('#')[1]
        val = current['gd$formattedAddress']['$t']
        old[key] = val; old
      end

      positions = (contact['gd$organization'] || {} ).inject({}) do |old, current|
        key = current['gd$orgName']['$t']
        val = current['gd$orgTitle']['$t']
        old[key] = val; old
      end

      @user.contacts.create(emails:     contact['gd$email'].map{|c| c['address']},
                           phones:      phones.empty? ? nil : phones,
                           addresses:   addresses.empty? ? nil : addresses,
                           positions:   positions.empty? ? nil : positions,
                           gcontact_id: contact['link'][0]['href'].split('/').last,
                           fullname:    contact['gd$name'] && contact['gd$name']['gd$fullName'] && contact['gd$name']['gd$fullName']['$t'])
    end
  end
end
