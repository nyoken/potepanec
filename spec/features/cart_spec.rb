# require 'rails_helper'
#
# RSpec.feature "cart", type: :feature do
#   let!(:store) { create(:store) }
#   let!(:taxon) { create(:taxon) }
#   let!(:product) { create(:product, taxons: [taxon]) }
#   let!(:country) { create(:country, states_required: true) }
#   let!(:state) { create(:state, country: country) }
#   let!(:shipping_method) { create(:shipping_method) }
#   let!(:stock_location) { create(:stock_location) }
#   let!(:payment_method) { create(:check_payment_method) }
#   let!(:ups) { create(:shipment) }
#   let!(:zone) { create(:zone) }
#   let!(:check) { create(:check_payment_method) }
#   let!(:credit_card) { create(:credit_card_payment_method) }
#
#   # ユーザー登録をテスト
#   scenario "add products to cart then update then destroy" do
#     visit potepan_product_path(product.id)
#
#     # quantity = 1 を選択
#     select "1", from: "quantity"
#
#     # カートに入れる をクリック
#     click_on "カートに入れる"
#
#     # カートページに遷移したことを確認
#     expect(current_url).to eq potepan_cart_url
#
#     # 追加したorderを取得
#     order = Spree::Order.last
#
#     # カートに追加した商品を取得
#     line_item = order.line_items.first
#
#     # 商品の情報が表示されていることを確認
#     within("div.cartListInner") do
#       expect(page).to have_content product.name
#       expect(page).to have_content product.display_price
#       expect(line_item.quantity).to eq 1
#       expect(page).to have_content order.display_total
#     end
#
#     # 個数を1つ増やす
#     fill_in "order_line_items_attributes_0_quantity", with: 2
#
#     # アップデート をクリック
#     click_on "アップデート"
#
#     # line_itemを再読み込み
#     line_item.reload
#
#     # 商品の情報が表示されていることを確認
#     within("div.cartListInner") do
#       expect(line_item.quantity).to eq 2
#       expect(page).to have_content order.display_total
#     end
#
#     # バツボタン をクリック
#     within("div.cartListInner") do
#       click_on "×"
#     end
#
#     # 商品の情報が表示されていないことを確認
#     within("div.cartListInner") do
#       expect(page).not_to have_content product.name
#     end
#     expect(page).to have_content "カートは空です。"
#   end
#
#   # 現金で購入
#   scenario "buy by check" do
#     visit potepan_product_path(product.id)
#
#     # quantity = 1 を選択
#     select "1", from: "quantity"
#
#     # カートに入れる をクリック
#     click_on "カートに入れる"
#
#     # カートページに遷移したことを確認
#     expect(current_url).to eq potepan_cart_url
#
#     # 追加したorderを取得
#     order = Spree::Order.last
#
#     # カートに追加した商品を取得
#     line_item = order.line_items.first
#
#     # 購入する をクリック
#     click_on "購入する"
#
#     # アドレス入力ページに遷移することを確認
#     expect(current_url).to eq potepan_checkout_state_url("address")
#
#     # ウィザード表示を確認
#     within(".progress-wizard") do
#       within("div.complete") do
#         expect(page).to have_content "お届け先情報"
#       end
#       within("div.disabled", match: :first) do
#         expect(page).to have_content "お支払い方法"
#       end
#     end
#
#     # フォームが埋まっていないと先に進まないことを確認
#     click_on "次へ"
#     expect(current_url).to eq potepan_update_checkout_url("address")
#
#     # フォームを埋める
#     fill_in "order_ship_address_attributes_lastname", with: "Depp"
#     fill_in "order_ship_address_attributes_firstname", with: "Johnny"
#     fill_in "order_email", with: "test@example.com"
#     fill_in "order_ship_address_attributes_zipcode", with: "123-4567"
#     select state, from: "order_ship_address_attributes_state_id"
#     fill_in "order_ship_address_attributes_city", with: "LA"
#     fill_in "order_ship_address_attributes_address1", with: "1-1-1"
#     fill_in "order_ship_address_attributes_phone", with: "08012345678"
#
#     # 次へ をクリック
#     click_on "次へ"
#
#     # 支払い情報入力ページに遷移することを確認
#     expect(current_url).to eq potepan_checkout_state_url("payment")
#
#     # ウィザード表示を確認
#     within(".progress-wizard") do
#       within("div.complete") do
#         expect(page).to have_content "お届け先情報"
#       end
#       within("div.active") do
#         expect(page).to have_content "お支払い方法"
#       end
#       within("div.disabled") do
#         expect(page).to have_content "入力内容確認"
#       end
#     end
#
#     # checkで購入
#     choose "Check", match: :first
#
#     # 次へ をクリック
#     click_on "次へ"
#
#     # 支払い情報入力ページに遷移することを確認
#     expect(current_url).to eq potepan_checkout_state_url("confirm")
#
#     # ウィザード表示を確認
#     within(".progress-wizard") do
#       within("div.complete", match: :first) do
#         expect(page).to have_content "お届け先情報"
#       end
#     end
#
#     expect(page).to have_content order.name
#     expect(page).to have_content order.ship_address
#     expect(page).to have_content order.email
#
#     # 購入確定 をクリック
#     click_on "購入確定"
#     order.reload
#
#     # 支払い情報入力ページに遷移することを確認
#     mail = Spree::OrderMailer.confirm_email(order)
#     expect(mail.subject).to eq("#{order.store.name} Order Confirmation ##{order.number}")
#     expect(mail.to).to eq([order.email])
#     expect(mail.from).to eq([order.store.mail_from_address])
#
#     # 支払い情報入力ページに遷移することを確認
#     expect(current_url).to eq potepan_order_url(order.number)
#
#     expect(page).to have_content "Your order has been processed successfully"
#     expect(page).to have_content "ご注文ありがとうございます。"
#     expect(page).to have_content order.email
#     expect(page).to have_content order.number
#   end
#
#   # クレジットカードで購入
#   scenario "buy by credit card" do
#     visit potepan_product_path(product.id)
#
#     # quantity = 1 を選択
#     select "1", from: "quantity"
#
#     # カートに入れる をクリック
#     click_on "カートに入れる"
#
#     # カートページに遷移したことを確認
#     expect(current_url).to eq potepan_cart_url
#
#     # 追加したorderを取得
#     order = Spree::Order.last
#
#     # カートに追加した商品を取得
#     line_item = order.line_items.first
#
#     # 購入する をクリック
#     click_on "購入する"
#
#     # アドレス入力ページに遷移することを確認
#     expect(current_url).to eq potepan_checkout_state_url("address")
#
#     # フォームを埋める
#     fill_in "order_ship_address_attributes_lastname", with: "Depp"
#     fill_in "order_ship_address_attributes_firstname", with: "Johnny"
#     fill_in "order_email", with: "test@example.com"
#     fill_in "order_ship_address_attributes_zipcode", with: "123-4567"
#     select state, from: "order_ship_address_attributes_state_id"
#     fill_in "order_ship_address_attributes_city", with: "LA"
#     fill_in "order_ship_address_attributes_address1", with: "1-1-1"
#     fill_in "order_ship_address_attributes_phone", with: "08012345678"
#
#     # 次へ をクリック
#     click_on "次へ"
#
#     # 支払い情報入力ページに遷移することを確認
#     expect(current_url).to eq potepan_checkout_state_url("payment")
#
#     # credit cardで購入
#     choose "Credit Card", match: :first
#
#     # フォームが埋まっていないと先に進まないことを確認
#     click_on "次へ"
#     expect(current_url).to eq potepan_update_checkout_url("payment")
#
#     # フォームを埋める
#     fill_in "name_on_card_#{credit_card.id}", with: "Johnny Depp"
#     fill_in "card_number", with: "1234567898765432"
#     select "03", from: "payment_source_#{credit_card.id}_month"
#     select "2025", from: "payment_source_#{credit_card.id}_year"
#     fill_in "card_code_#{credit_card.id}", with: "123"
#
#     # 次へ をクリック
#     click_on "次へ"
#
#     # 支払い情報入力ページに遷移することを確認
#     expect(current_url).to eq potepan_checkout_state_url("confirm")
#
#     expect(page).to have_content order.name
#     expect(page).to have_content order.ship_address
#     expect(page).to have_content order.email
#
#     # 購入確定 をクリック
#     click_on "購入確定"
#     order.reload
#
#     # 支払い情報入力ページに遷移することを確認
#     expect(current_url).to eq potepan_order_url(order.number)
#
#     expect(page).to have_content "Your order has been processed successfully"
#     expect(page).to have_content "ご注文ありがとうございます。"
#     expect(page).to have_content order.email
#     expect(page).to have_content order.number
#   end
# end
