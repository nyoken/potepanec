Spree::OptionType.class_eval do
  scope :colors, -> { find_by(presentation: 'Color').option_values }
  scope :sizes,  -> { find_by(presentation: 'Size').option_values }
end
