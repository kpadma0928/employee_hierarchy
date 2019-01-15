class CreateEmployeesTable < ActiveRecord::Migration[5.1]
  def change
    create_table :employees do |t|
      t.integer :reporter_id
      t.string :name
      t.integer :salary
      t.integer :rating
      t.string :designation
      t.string :emp_code
      t.boolean :active, default: true
    end
  end
end
