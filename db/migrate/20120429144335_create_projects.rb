class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.integer :code
      t.string :name, :limit => 24
      t.text :description
      t.string :website, :limit => 2000

      t.timestamps
    end
  end
end
