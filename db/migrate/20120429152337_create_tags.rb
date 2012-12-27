class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name, :limit => 128
      t.references :tagged_output
      t.references :output

      t.timestamps
    end
  end
end
