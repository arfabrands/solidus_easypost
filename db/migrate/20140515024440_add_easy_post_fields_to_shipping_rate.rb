# frozen_string_literal: true

class AddEasyPostFieldsToShippingRate < SolidusSupport::Migration[4.2]
  def change
    add_column :spree_shipping_rates, :name, :string
    add_column :spree_shipping_rates, :easy_post_shipment_id, :string
    add_column :spree_shipping_rates, :easy_post_rate_id, :string
    add_column :spree_shipments, :label, :string
  end
end
