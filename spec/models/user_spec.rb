require 'rails_helper'

RSpec.describe User, type: :model do

  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end
  # 名がなければ無効な状態であること
  it "is invalid without a first name" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end
  # 姓がなければ無効な状態であること
  it "is invalid without a last name" do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end
  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "aron@example.com")
    user = FactoryBot.build(:user, email: "aron@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  # ユーザーのフルネームを文字列として返すこと
  it "returns a user's full name as a string" do
    user = User.new(
      first_name: "John",
      last_name: "Doe",
      email: "johndoe@example.com",
    )
    expect(user.name).to eq "John Doe"
  end
end