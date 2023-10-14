# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Userモデルのテスト", type: :model do
  describe "バリデーションのテスト" do
    subject { user.valid? }

    let!(:other_user) { create(:user) }
    let(:user) { build(:user) }

    context "nameカラム" do
      it "空欄でないこと" do
        user.name = ""
        is_expected.to eq false
      end

      it "20文字以下であること: 20文字OK" do
        user.name = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end

      it "20文字以下であること: 21文字×" do
        user.name = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end

      it "一意性であること" do
        user.name = other_user.name
        is_expected.to eq false
      end
    end

    context "hobbyカラム" do
      it "50文字以下であること: 50文字OK" do
        user.hobby = Faker::Lorem.characters(number: 50)
        is_expected.to eq true
      end

      it "50文字以下であること: 51文字×" do
        user.hobby = Faker::Lorem.characters(number: 51)
        is_expected.to eq false
      end
    end

    context "introductionカラム" do
      it "100文字以下であること: 100文字OK" do
        user.introduction = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end

      it "100文字以下であること: 101文字×" do
        user.introduction = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe "アソシエーションのテスト" do
    context "PostHobbyモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:post_hobbies).macro).to eq :has_many
      end
    end

    context "Commentモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

    context "Favoriteモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context "GroupUserモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:group_users).macro).to eq :has_many
      end
    end

    context "Chatモデルとの関係" do
      it "1:Nとなっている" do
        expect(User.reflect_on_association(:chats).macro).to eq :has_many
      end
    end
  end
end
