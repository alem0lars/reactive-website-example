class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :name, :limit => 256
      t.references :build
      t.references :version_manager

      t.timestamps
    end
  end
end
