class CreateOutputs < ActiveRecord::Migration
  def change
    create_table :outputs do |t|
      t.string :name, :limit => 128
      t.text :content
      t.string :content_kind, :limit => 64
      t.references :action

      t.string :type

      t.timestamps
    end
  end
end
