class CreateVersionManagers < ActiveRecord::Migration
  def change
    create_table :version_managers do |t|
      t.string :version, :limit => 128
      t.string :kind, :limit => 64

      t.timestamps
    end
  end
end
