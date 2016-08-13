class User < ActiveRecord::Base
  has_many :requested_contacts, foreign_key: :acceptor_id, class_name: 'Contact'
  has_many :accepted_contacts, foreign_key: :requester_id, class_name: 'Contact'
end
