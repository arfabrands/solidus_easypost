# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module OrderDecorator

      # To implement in host app
      def eligible_for_free_shipping?
        item_total >= free_shipping_threshold.to_i
      end

      def free_shipping_threshold
        ENV.fetch('FREE_SHIPPING_THRESHOLD', 1000000)
      end

      # Implement app-specific logic to defeat live rates in host app
      def fetch_live_shipping_rates?
        true
      end

      ::Spree::Order.prepend self
    end
  end
end
