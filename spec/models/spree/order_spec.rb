require 'spec_helper'

module Spree
  RSpec.describe Order, type: :model do
    context "free shipping" do
      let(:order) { Spree::Order.create }
      it "should not qualify for free shipping by default" do
        order.total = 20
        expect(order.eligible_for_free_shipping?).to be false
      end
      
      it "should not qualify for free shipping if total exceeds shipping threshold" do
        ClimateControl.modify FREE_SHIPPING_THRESHOLD: '25' do
          order.total = 25
          expect(order.eligible_for_free_shipping?).to be true
        end
      end

      it "knows when to use static over live rates" do
        expect(order.fetch_live_shipping_rates?).to be true
      end
    end
  end
end