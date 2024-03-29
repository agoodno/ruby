class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :order
  
  def self.from_cart_item(cart_item)
    li = self.new
    li.product_id = cart_item.product
    li.quantity = cart_item.quantity
    li.total_price = cart_item.price
    li
  end
  
end
