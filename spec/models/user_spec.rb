require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:classifieds) }
  it { should validate_presence_of(:firstname) }
  it { should validate_presence_of(:lastname) }
  it { should validate_presence_of(:username) }
  it { should validate_uniqueness_of(:username) }
  it { should have_secure_password }
  it { should validate_presence_of(:password) }
end
