class RenameDOjToDoj < ActiveRecord::Migration[7.0]
  def change
    rename_column :employees, :dOj, :doj
  end
end
