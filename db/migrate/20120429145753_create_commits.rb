class CreateCommits < ActiveRecord::Migration
  def change
    create_table :commits do |t|
      t.string :digest, :limit => 512
      t.string :url, :limit => 2000
      t.datetime :timestamp

      t.timestamps
    end
  end
end
