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
        allow(ENV).to receive(:[]).with('FREE_SHIPPING_THRESHOLD').and_return(25)
        order.total = 25
        expect(order.eligible_for_free_shipping?).to be true
      end
    end
  end
end