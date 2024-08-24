class CreateChanges < ActiveRecord::Migration[6.1]
  def change
    create_table :changes do |t|
      t.integer :user_id, null: false
      t.string :field, null: false
      t.string :old_value
      t.string :new_value
      t.datetime :changed_at, null: false

      t.timestamps
    end

    add_index :changes, :user_id
    add_index :changes, [:user_id, :field, :changed_at]
  end
end
