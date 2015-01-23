class ContactsController < ApplicationController
  def index
    @contacts = current_user.contacts
  end

  def edit
    @contact = Contact.find(params[:id])
  end
end
