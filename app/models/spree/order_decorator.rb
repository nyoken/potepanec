Spree::Order.class_eval do
  # Checkout用ページのタイトル取得用メソッド
  def checkout_title
    case state
    when "address"
      "お届け先情報"
    when "payment"
      "お支払い方法"
    when "confirm"
      "入力内容確認"
    when "complete"
      "THANKS MESSAGE"
    end
  end

  # Checkoutの進捗具合を取得するメソッド
  def payment_wizard_steps
    case state
    when "address"
      "disabled"
    when "payment"
      "active"
    when "confirm"
      "complete fullBar"
    end
  end

  # 戻るボタン用に、1つ前のstateを取得するメソッド
  def previous_checkout_state
    case state
    when "payment"
      "address"
    when "confirm"
      "payment"
    end
  end
end
