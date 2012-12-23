class CreateDependencies < ActiveRecord::Migration
  def change
    create_table :dependencies do |t|
      t.string :name, :limit => 128
      t.string :url, :limit => 2000
      t.string :stage, :limit => 64
      t.references :project

      t.timestamps
    end
  end
end
