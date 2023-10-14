# frozen_string_literal: true

require "rails_helper"

describe "トップ画面のテスト" do
  before do
    visit root_path
  end

  context "表示の確認" do
    it 'トップ画面が"/"であるか' do
      expect(current_path).to eq("/")
    end
  end
end