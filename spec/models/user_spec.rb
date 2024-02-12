require 'rails_helper'

RSpec.describe User, type: :model do
  context 'Creating User' do
    let(:valid_user) { build :user }
    let(:invalid_user) { build :user, username: "name with space" }
    
    it 'should be a valid user' do
      expect(valid_user.valid?).to eq(true)
    end
    
    it 'should be an invalid user' do
      expect(invalid_user.valid?).to eq(false)
      expect(invalid_user.errors[:username]).to include(": Only allow letters, numbers and underscores")
    end
    
    it 'should have a default role of "user"' do
      expect(valid_user.role).to eq("user")
    end

    it 'should have a admin role' do
      valid_user.role = 'admin'
      expect(valid_user.role).to eq('admin')
    end
  end

  context 'Validations' do
    let(:user) { build :user }

    it 'should validate presence of username' do
      user.username = nil
      expect(user.valid?).to eq(false)
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'should validate presence of email' do
      user.email = nil
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'should validate uniqueness of username' do
      user.save!
      new_user = build :user, username: user.username
      expect(new_user.valid?).to eq(false)
      expect(new_user.errors[:username]).to include("has already been taken")
    end

    it 'should validate uniqueness of email' do
      user.save!
      new_user = build :user, email: user.email
      expect(new_user.valid?).to eq(false)
      expect(new_user.errors[:email]).to include("has already been taken")
    end

    it 'should validate format of username' do
      user.username = "invalid username"
      expect(user.valid?).to eq(false)
      expect(user.errors[:username]).to include(": Only allow letters, numbers and underscores")
    end

    it 'should validate format of email' do
      user.email = "invalid_email.com"
      expect(user.valid?).to eq(false)
      expect(user.errors[:email]).to include(": Enter valid email")
    end

    it 'should validate presence of full name' do
      user.full_name = nil
      expect(user.valid?).to eq(false)
      expect(user.errors[:full_name]).to include("can't be blank")
    end

    it 'should validate length of password' do
      user.password = "short"
      expect(user.valid?).to eq(false)
      expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
    end
  end
end
