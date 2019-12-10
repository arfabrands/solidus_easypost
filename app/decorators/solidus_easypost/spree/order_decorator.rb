# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module OrderDecorator

      # To implement in host app
      def eligible_for_free_shipping?
        false
      end

      ::Spree::Order.prepend self
    end
  end
end