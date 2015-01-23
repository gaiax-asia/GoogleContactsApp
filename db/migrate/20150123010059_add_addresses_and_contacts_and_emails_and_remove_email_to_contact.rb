class AddAddressesAndContactsAndEmailsAndRemoveEmailToContact < ActiveRecord::Migration
  def change
    add_column :contacts, :addresses, :text
    add_column :contacts, :phones, :text
    add_column :contacts, :emails, :text

    remove_column :contacts, :email
  end
end
