class User < ActiveRecord::Base
  has_many :requested_contacts, foreign_key: :requested_id, class_name: 'Contact'
  has_many :accepted_contacts, foreign_key: :acceptor_id, class_name: 'Contact'
  has_many :contacts, through: :accepted_contacts, source: :requester
end
