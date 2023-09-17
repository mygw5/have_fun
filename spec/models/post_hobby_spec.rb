# frozen_string_literal: true

require 'rails_helper'

describe '投稿のテスト' do
  let!(:post_hobby) { create(:post_hobby, title: 'hoge', text: 'text') }
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end
    context '表示の確認' do
      it 'root_pathが"/"であるか' do
        expect(current_path).to eq('/')
      end
    end
  end

  describe '投稿画面のテスト' do
    before do
      visit new_post_hobby_path
    end
    context '表示の確認' do
      it 'new_post_hobby_pathが/post_hobbies/newであるか' do
        expect(cunrrent_path).to eq('/post_hobbies/new')
      end
      it '投稿する/下書き保存ボタンが表示されているか' do
        expect(page).to have_button '投稿する'
        expect(page).to have_botton '下書き保存'
      end
    end
    context '投稿処理のテスト' do
      it '投稿後のリダイレクト先は正しいか' do
        fill_in 'post_hobby[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'post_hobby[text', with: Faker::Lorem.characters(number:30)
        click_button '投稿する'
        expect(page).to have_current_path post_hobbies_path
      end
      it '下書き保存のリダイレクト先は正しいか' do
        click_button '下書き保存'
        expect(page).to have_current_path unpublished_post_hobbies_path
      end
    end
  end

  describe '投稿一覧のテスト' do
    before do
      visit post_hobbies_path
    end
    context '表示の確認' do
      it '投稿されたものが表示されているか' do
        expect(page).to have_content post_hobby.title
        expect(page).to have_link post_hobby.title
        expect(page).to have_content post_hobby.text
      end
    end
  end

  describe '詳細画面のテスト' do
    before do
      visit post_hobby_path(post_hobby)
    end
    context '表示の確認' do
      it '削除リンクが存在しているか' do
        expect(page).to have_link '削除する'
      end
      it '編集リンクが存在しているか' do
        expect(page).to have_link '編集する'
      end
    end
    context 'リンクの遷移先の確認' do
      it '編集の遷移先は編集画面か' do
        edit_link = find_all('a')[8]
        edit_link.click
        expect(current_path).to eq('/post_hobbies/' + post_hobby.id.to_s + '/edit')
      end
    end
    context '投稿削除のテスト' do
      it '投稿の削除' do
        expect{ post_hobby.destroy }.to change{ post_hobby.count }.by(-1)
      end
    end
  end

  describe '編集画面のテスト' do
    before do
      visit edit_post_hobby_path
    end
    context '表示の確認' do
      it '編集前のタイトルと本文がフォームに表示されている' do
        expect(page).to have_field 'post_hobby[title]', with: post_hobby.title
        expect(page).to have_field 'post_hobby[text]', with: post_hobby.text
      end
      it '投稿するボタンが表示されてる' do
        expect(page).to have_button '投稿する'
        expect(page).to have_button '非公開にする'
      end
    end
    context '更新処理に関するテスト' do
      it '更新後のリダイレクト先は正しいか' do
        fill_in 'post_hobby[title]', with: Faker::Lorem.characters(number:10)
        fill_in 'post_hobby[text]', with: Faker::Lorem.characters(number:30)
        click_button '投稿する'
        expect(page).to have_current_path post_hobby_path(post_hobby)
      end
    end
  end
end