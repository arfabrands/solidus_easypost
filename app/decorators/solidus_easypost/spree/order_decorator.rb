# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module OrderDecorator

      # To implement in host app
      def eligible_for_free_shipping?
        total >= free_shipping_threshold
      end

      def free_shipping_threshold
        ENV.fetch('FREE_SHIPPING_THRESHOLD', 1000000)
      end

      ::Spree::Order.prepend self
    end
  end
end