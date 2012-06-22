class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.column :product_id, :integer, :null => false
      t.column :order_id, :integer, :null => false
      t.column :quantity, :integer, :null => false
      t.column :total_price, :decimal, :null => false, :precision => 8, :scale => 2
    end

    execute "ALTER TABLE line_items ADD CONSTRAINT fk_line_item_products FOREIGN KEY (product_id) REFERENCES products(id)"    
    execute "ALTER TABLE line_items ADD CONSTRAINT fk_line_item_orders FOREIGN KEY (order_id) REFERENCES orders(id)"
    
  end

  def self.down
    drop_table :line_items
  end
end
