class StoreController < ApplicationController

  def index
    @products = Product.find_products_for_sale
    @cart = find_cart
  end
  
  def add_to_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}" )
      redirect_to_index "Invalid product"
    else
      @cart = find_cart
      @current_item = @cart.add_product(product)
      redirect_to_index unless request.xhr?
    end
  end
  
  def remove_from_cart
    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}" )
      redirect_to_index "Invalid product"
    else
      @cart = find_cart
      @current_item = @cart.remove_product(product)
      redirect_to_index unless request.xhr?
    end
  end
  
  def empty_cart
    session[:cart] = nil
    @cart = find_cart
    redirect_to_index unless request.xhr?
  end

  def checkout
    @cart = find_cart
    if @cart.items.empty?
      redirect_to_index("Your cart is empty") unless request.xhr?
    else
      @order = Order.new
    end
  end
  
  def save_order
    @cart = find_cart
    @order = Order.new(params[:order])
    @order.add_line_items_from_cart(@cart)
    if @order.save
      session[:cart] = nil
      redirect_to_index("Thank you for your order")
    else
      render :action => :checkout
    end
  end
  
  private  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg if msg
    redirect_to :action => :index
  end
  
  private
  def find_cart
    session[:cart] ||= Cart.new
  end
  
end
