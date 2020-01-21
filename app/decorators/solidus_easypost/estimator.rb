# frozen_string_literal: true

module SolidusEasypost
  class Estimator

    def shipping_rates(package, _frontend_only = true)
      if package.order.fetch_live_shipping_rates?
        live_shipping_rates(package, _frontend_only = true)
      else
        static_shipping_rates(package)
      end
    end

    def live_shipping_rates(package, _frontend_only = true)
      shipment = package.easypost_shipment
      rates = shipment.rates.sort_by { |r| r.rate.to_i }
      available_to_users = package.order.channel != 'spree'

      shipping_rates = []

      if rates.any?
        rates.each do |rate|
          spree_rate = ::Spree::ShippingRate.new(
            name: "#{rate.carrier} #{rate.service}",
            cost: rate.rate,
            easy_post_shipment_id: rate.shipment_id,
            easy_post_rate_id: rate.id,
            shipping_method: find_or_create_shipping_method(rate, available_to_users)
          )

          shipping_rates << spree_rate if spree_rate.shipping_method.available_to_users?
        end

        # Sets cheapest rate to be selected by default
        if shipping_rates.any?
          shipping_rates.min_by(&:cost).selected = true
        end

        shipping_rates
      else
        []
      end
    end

    def static_shipping_rates(package)
      shipping_rates = []

      method_name = static_shipping_method_name(package)
      shipping_rates << ::Spree::ShippingRate.new(
        name: method_name.humanize,
        cost: flat_rate_cost(package),
        shipping_method: find_or_create_static_shipping_method(method_name)
      )

      # Sets cheapest rate to be selected by default
      if shipping_rates.any?
        shipping_rates.min_by(&:cost).selected = true
      end

      shipping_rates
    end

    private

    # Cartons require shipping methods to be present, This will lookup a
    # Shipping method based on the admin(internal)_name. This is not user facing
    # and should not be changed in the admin.
    def find_or_create_shipping_method(rate, available_to_users)
      method_name = "#{rate.carrier} #{rate.service}"
      ::Spree::ShippingMethod.find_or_create_by(admin_name: method_name) do |r|
        r.name = method_name
        r.available_to_users = available_to_users
        r.code = rate.service
        r.calculator = ::Spree::Calculator::Shipping::FlatRate.create
        r.shipping_categories = [::Spree::ShippingCategory.first]
      end
    end

    def find_or_create_static_shipping_method(name)
      ::Spree::ShippingMethod.find_or_create_by(admin_name: name) do |r|
        r.name = name.humanize
        r.available_to_users = true
        r.code = name
        r.calculator = ::Spree::Calculator::Shipping::FlatRate.create
        r.shipping_categories = [::Spree::ShippingCategory.first]
      end
    end

    def static_shipping_method_name(package)
      package.order.eligible_for_free_shipping? ? "free_shipping" : "standard_shipping"
    end

    def flat_rate_cost(package)
      if package.order.eligible_for_free_shipping?
        0.0
      else
        ENV.fetch('STANDARD_SHIPPING_RATE', 5.0)
      end
    end
  end
end
