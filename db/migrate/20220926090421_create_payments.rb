class CreatePayments < ActiveRecord::Migration[7.0]
  def change
    create_table :payments do |t|
      t.integer :amount 
      t.integer :phone_number 
      t.boolean :state, default: false 
      t.string :response 
      t.string :CheckoutRequestID 
      t.string :MerchantRequestID 
      
      t.timestamps
    end
  end
end
