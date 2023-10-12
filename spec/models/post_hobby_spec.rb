# frozen_string_literal: true

require "rails_helper"

RSpec.describe 'PostHobbyモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { post_hobby.valid? }

    let(:user) { create(:user) }
    let!(:post_hobby) { build(:post_hobby, user_id: user.id) }

    context 'titleカラム' do
      it '空欄ではない' do
        post_hobby.title = ''
        is_expected.to eq false
      end

      it '20文字以下であるとこ: 20文字OK' do
        post_hobby.title = Faker::Lorem.characters(number: 20)
        is_expected.to eq true
      end

      it '20文字以下であること: 21文字×' do
        post_hobby.title = Faker::Lorem.characters(number: 21)
        is_expected.to eq false
      end
    end

    context 'textカラム' do
      it '空欄ではない' do
        post_hobby.text = ''
        is_expected.to eq false
      end

      it '300文字以下であること: 300文字OK' do
        post_hobby.text = Faker::Lorem.characters(number: 300)
        is_expected.to eq true
      end

      it '300文字以下であること: 301文字×' do
        post_hobby.text = Faker::Lorem.characters(number: 301)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1になっている' do
        expect(PostHobby.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Commentモデルとの関係' do
      it '1:Nになっている' do
        expect(PostHobby.reflect_on_association(:comments).macro).to eq :has_many
      end
    end

     context 'Favotriteモデルとの関係' do
      it '1:Nになっている' do
        expect(PostHobby.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

     context 'PostTagモデルとの関係' do
      it '1:Nになっている' do
        expect(PostHobby.reflect_on_association(:post_tags).macro).to eq :has_many
      end
    end

     context 'Tagモデルとの関係' do
      it '1:Nになっている' do
        expect(PostHobby.reflect_on_association(:tags).macro).to eq :has_many
      end
    end

     context 'Notificationモデルとの関係' do
      it '1:Nになっている' do
        expect(PostHobby.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end