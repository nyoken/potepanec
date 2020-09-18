class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def after_sign_in_path_for(*)
    request.referer
  end

  def after_sign_out_path_for(*)
    potepan_root_path
  end

  def set_taxonomies_and_option_types
    @taxonomies = Spree::Taxonomy.includes(:root)
    @option_types = Spree::OptionType.includes(:option_values)
  end

  def set_brands
    @brand_taxons = Spree::Taxon.where(taxonomy_id: 2).where.not(name: :Brand)
  end
end
