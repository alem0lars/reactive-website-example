class RemoveProjectsCode < ActiveRecord::Migration
  def change
    remove_column :projects, :code
  end
end
