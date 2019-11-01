# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module StockLocationDecorator
      def easypost_address
        attributes = {
          street1: address1,
          street2: address2,
          city: city,
          zip: zipcode,
          phone: phone,
          name: name,
          company: name
        }

        attributes[:state] = state ? state.abbr : state_name
        attributes[:country] = country&.iso

        ::EasyPost::Address.create attributes
      end

      ::Spree::StockLocation.prepend self
    end
  end
end
