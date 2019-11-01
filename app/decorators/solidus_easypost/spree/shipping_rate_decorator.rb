# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module ShippingRateDecorator
      def name
        read_attribute(:name) || super
      end

      ::Spree::ShippingRate.prepend self
    end
  end
end
