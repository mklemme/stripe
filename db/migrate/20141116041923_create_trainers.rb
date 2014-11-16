class CreateTrainers < ActiveRecord::Migration
  def change
    create_table :trainers do |t|
      t.float :current_balance
      t.integer :user_id
      t.boolean :verified
      t.float :rate

      t.timestamps
    end
  end
end
