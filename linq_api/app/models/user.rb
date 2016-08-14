class User < ActiveRecord::Base
  has_many :requested_contacts, foreign_key: :requester_id, class_name: 'Contact'
  has_many :accepted_contacts, foreign_key: :acceptor_id, class_name: 'Contact'

  def contacts
    contacts = []
    arr = requested_contacts.pluck(:acceptor_id, :requester_id) + accepted_contacts.pluck(:acceptor_id, :requester_id)
    if !arr.blank?
      arr.flatten!.uniq!
      arr.delete(self.id)
      User.where(id: arr)
    else
      contacts
    end
  end
end
