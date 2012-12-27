class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name, :limit => 128
      t.datetime :started_at
      t.datetime :finished_at
      t.text :description
      t.string :status, :limit => 9 # calculated from the available statuses which is the limit
      t.references :step

      t.timestamps
    end
  end
end
