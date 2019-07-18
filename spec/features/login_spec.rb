require 'rails_helper'

RSpec.feature "login", type: :feature do
  let!(:products) { create_list(:product, 8) }
  let!(:user) { create(:user, email: "test@example.com", password: "testuser") }

  # ユーザー登録をテスト
  scenario "Registerate new user then login" do
    visit potepan_root_path

    # Create an accountをクリック
    click_on "Create an account"

    # パスワードミス
    within("div#signup") do
      fill_in "Enter Email", with: "user@example.com"
      fill_in "spree_user[password]", with: "i_am_user"
      fill_in "spree_user[password_confirmation]", with: "i_am_not_user"
      click_on "Sign up"
    end
    expect(page).to have_content "Invalid email or password."
    expect(current_url).to eq potepan_root_url

    # Create an accountをクリック
    click_on "Create an account"

    # パスワードOK
    within("div#signup") do
      fill_in "Enter Email", with: "user@example.com"
      fill_in "spree_user[password]", with: "i_am_user"
      fill_in "spree_user[password_confirmation]", with: "i_am_user"
      click_on "Sign up"
    end
    expect(page).to have_content "Welcome! You have signed up successfully."
    expect(current_url).to eq potepan_root_url
    expect(page).to have_content "Log out"
  end

  scenario "login and logout" do
    visit potepan_root_path

    # Create an accountをクリック
    click_on "Log in"

    # メールアドレスミス
    within("div#login") do
      fill_in "Enter Email", with: "not_test@example.com"
      fill_in "spree_user[password]", with: "testuser"
      click_on "log in"
    end
    expect(page).to have_content "Invalid email or password."
    expect(current_url).to eq potepan_root_url

    # Create an accountをクリック
    click_on "Log in"

    # パスワードミス
    within("div#login") do
      fill_in "Enter Email", with: "test@example.com"
      fill_in "spree_user[password]", with: "not_testuser"
      click_on "log in"
    end
    expect(page).to have_content "Invalid email or password."
    expect(current_url).to eq potepan_root_url

    # Create an accountをクリック
    click_on "Log in"

    # メールアドレス&パスワードOK
    within("div#login") do
      fill_in "Enter Email", with: "test@example.com"
      fill_in "spree_user[password]", with: "testuser"
      click_on "log in"
    end
    expect(page).to have_content "Logged in successfully"
    expect(current_url).to eq potepan_root_url

    # Log outをクリック
    click_on "Log out"
    expect(page).to have_content "Signed out successfully."
    expect(current_url).to eq potepan_root_url
    expect(page).to have_content "Log in"
  end
end
