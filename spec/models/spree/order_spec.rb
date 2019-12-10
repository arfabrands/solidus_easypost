require 'spec_helper'

module Spree
  RSpec.describe Order, type: :model do
    context "free shipping" do
      let(:order) { Spree::Order.create }
      it "should qualify for free shipping if total exceeds 25" do
        order.total = 20
        expect(order.eligible_for_free_shipping?).to be false
        order.total = 25
        expect(order.eligible_for_free_shipping?).to be true
      end
    end
  end
end