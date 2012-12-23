class CreateBuilds < ActiveRecord::Migration
  def change
    create_table :builds do |t|
      t.references :branch
      t.references :commit

      t.timestamps
    end
  end
end
