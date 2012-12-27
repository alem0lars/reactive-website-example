class AddDerivativeFieldsOnBuilds < ActiveRecord::Migration
  def change
    add_column :builds, :started_at, :datetime
    add_column :builds, :finished_at, :datetime
    add_column :builds, :status, :string
  end
end
