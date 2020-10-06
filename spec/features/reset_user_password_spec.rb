require 'rails_helper'

RSpec.feature "ResetUserPassword", type: :feature do
  background do
    ActionMailer::Base.deliveries.clear
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+(?=If\sthe)/]
  end

  let!(:store) { create(:store, mail_from_address: "store@example.com") }
  let!(:user) { create(:user, email: "test@example.com", password: "testuser") }

  scenario "パスワード再設定ページでパスワードを変更し、変更後のパスワードでログインする" do
    visit potepan_root_path
    click_on "ログイン", match: :first
    click_on "こちら", match: :first
    within("div#reset-password") do
      fill_in "spree_user[email]", with: user.email
      expect { click_button "送信" }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
    expect(page).to have_content "If an account with that email address exists, you will receive an email with instructions about how to reset your password in a few minutes."

    # 送信されたメールのURLを取得してアクセスし、メールアドレスが確認できたことを確認
    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url

    puts current_url

    # パスワード空白の場合
    within("div#edit-reset-password") do
      fill_in "spree_user[password]", with: ""
      fill_in "spree_user[password_confirmation]", with: ""
      click_button "パスワード再設定"
    end
    expect(page).to have_content "Your password cannot be blank."

    # 正規パスワードの場合
    within("div#edit-reset-password") do
      fill_in "spree_user[password]", with: "newtestuser"
      fill_in "spree_user[password_confirmation]", with: "newtestuser"
      #find('#spree_user_reset_password_token', visible: false).set(user.reset_password_token)
      click_button "パスワード再設定"
    end
    expect(page).to have_content "Your password was changed successfully. You are now signed in."
    expect(current_url).to eq potepan_root_url

    # ログアウト
    click_on "ログアウト"

    # 以前のパスワードでログイン
    within("div#login") do
      fill_in "spree_user[email]", with: user.email
      fill_in "spree_user[password]", with: "testuser"
      click_on "ログイン"
    end

    # 以前のパスワードでのログインに失敗
    within("div#login") do
      fill_in "spree_user[email]", with: user.email
      fill_in "spree_user[password]", with: "testuser"
      click_on "ログイン"
    end
    expect(page).to have_content "Invalid email or password."

    # 新しいパスワードでのログインに成功
    within("div#login") do
      fill_in "spree_user[email]", with: user.email
      fill_in "spree_user[password]", with: "newtestuser"
      click_on "ログイン"
    end
    expect(page).to have_content "Logged in successfully"
    expect(current_url).to eq potepan_root_url
  end
end
