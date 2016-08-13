require 'rails_helper'

describe User do
  let(:user_one) { User.create(name: "Kaitlyn", email: "test@test.com") }
  let(:user_two) { User.create(name: "Spencer", email: "test2@test.com") }

  describe "#contacts" do
    context "when a user has no contacts" do
      it "returns an empty array" do
        expect(user_one.contacts).to be_empty
      end
    end

    context "when a user accepts a contact" do
      it "returns accepted contact" do
        Contact.create(acceptor_id: user_one.id, requester_id: user_two.id)
        expect(user_one.contacts.length).to eq 1
        expect(user_two.contacts.length).to eq 1
      end
    end
  end
end
