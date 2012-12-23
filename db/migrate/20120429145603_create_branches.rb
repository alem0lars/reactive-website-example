class CreateBranches < ActiveRecord::Migration
  def change
    create_table :branches do |t|
      t.string :name, :limit => 128
      t.references :project

      t.timestamps
    end
  end
end
