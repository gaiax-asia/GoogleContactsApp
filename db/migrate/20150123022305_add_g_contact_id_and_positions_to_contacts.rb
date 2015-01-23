class AddGContactIdAndPositionsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :gcontact_id, :string
    add_column :contacts, :positions, :text
  end
end
