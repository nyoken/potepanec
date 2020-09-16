require 'rails_helper'

RSpec.feature "login", type: :feature do
  let!(:products) { create_list(:product, 8) }
  let!(:user) { create(:user, email: "test@example.com", password: "testuser") }

  # ユーザー登録をテスト
  scenario "Registerate new user then login" do
    visit potepan_root_path

    # アカウント作成をクリック
    click_on "アカウント作成"

    # パスワードミス
    within("div#signup") do
      fill_in "spree_user[email]", with: "user@example.com"
      fill_in "spree_user[password]", with: "i_am_user"
      fill_in "spree_user[password_confirmation]", with: "i_am_not_user"
      click_on "新規作成"
    end
    expect(page).to have_content "Invalid email or password."
    expect(current_url).to eq potepan_root_url

    # アカウント作成をクリック
    click_on "アカウント作成"

    # パスワードOK
    within("div#signup") do
      fill_in "spree_user[email]", with: "user@example.com"
      fill_in "spree_user[password]", with: "i_am_user"
      fill_in "spree_user[password_confirmation]", with: "i_am_user"
      click_on "新規作成"
    end
    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_url).to eq potepan_root_url
    expect(page).to have_content "ログアウト"
  end

  scenario "login and logout" do
    visit potepan_root_path

    # ログインをクリック
    click_on "ログイン", match: :first

    # メールアドレスミス
    within("div#login") do
      fill_in "spree_user[email]", with: "not_test@example.com"
      fill_in "spree_user[password]", with: "testuser"
      click_on "ログイン"
    end
    expect(page).to have_content "Invalid email or password."
    expect(current_url).to eq potepan_root_url

    # ログインをクリック
    click_on "ログイン", match: :first

    # パスワードミス
    within("div#login") do
      fill_in "spree_user[email]", with: "test@example.com"
      fill_in "spree_user[password]", with: "not_testuser"
      click_on "ログイン"
    end
    expect(page).to have_content "Invalid email or password."
    expect(current_url).to eq potepan_root_url

    # ログインをクリック
    click_on "ログイン", match: :first

    # メールアドレス&パスワードOK
    within("div#login") do
      fill_in "spree_user[email]", with: "test@example.com"
      fill_in "spree_user[password]", with: "testuser"
      click_on "ログイン"
    end
    expect(page).to have_content "Logged in successfully"
    expect(current_url).to eq potepan_root_url

    # ログアウトをクリック
    click_on "ログアウト"
    expect(page).to have_content "Signed out successfully."
    expect(current_url).to eq potepan_root_url
    expect(page).to have_content "ログイン"
  end
end
