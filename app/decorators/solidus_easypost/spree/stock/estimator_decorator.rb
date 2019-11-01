# frozen_string_literal: true

module SolidusEasypost
  module Spree
    module Stock
      module EstimatorDecorator
        def shipping_rates(package, frontend_only = true)
          SolidusEasypost::Estimator.new.shipping_rates(package, frontend_only)
        end

        ::Spree::Stock::Estimator.prepend self
      end
    end
  end
end
