# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:potions).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe 'password security' do
    it 'requires a password and confirmation' do
      user = build(:user, password: 'secret', password_confirmation: 'secret')
      expect(user).to be_valid
    end

    it 'is invalid if password and confirmation do not match' do
      user = build(:user, password: 'secret', password_confirmation: 'wrong')
      expect(user).not_to be_valid
    end

    it 'authenticates with correct password' do
      user = create(:user, password: 'secret', password_confirmation: 'secret')
      expect(user.authenticate('secret')).to eq(user)
    end

    it 'does not authenticate with incorrect password' do
      user = create(:user, password: 'secret', password_confirmation: 'secret')
      expect(user.authenticate('wrong')).to be_falsey
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:password).is_at_least(5) }
    it { should validate_length_of(:password).is_at_most(36) }
  end

  describe 'attribute validations' do
    it 'is valid with valid attributes' do
      user = build(:user)

      expect(user).to be_valid
    end

    it 'is invalid without a username' do
      user = build(:user, username: nil)

      expect(user).not_to be_valid
    end

    it 'is invalid without a password' do
      user = build(:user, password: nil)

      expect(user).not_to be_valid
    end

    it 'is invalid with a short password' do
      user = build(:user, password: 'abc')

      expect(user).not_to be_valid
    end

    it 'is invalid with a long password' do
      user = build(:user, password: 'abcabcabcabcabcabcabcabcabcabcabcabcabcabc')

      expect(user).not_to be_valid
    end
  end
end
