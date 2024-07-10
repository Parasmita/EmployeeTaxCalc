class CreateEmployees < ActiveRecord::Migration[7.0]
  def change
    create_table :employees do |t|
      t.string :firstname
      t.string :lastname
      t.string :email
      t.string :phonenumber
      t.date :dOj
      t.float :salary

      t.timestamps
    end
  end
end
