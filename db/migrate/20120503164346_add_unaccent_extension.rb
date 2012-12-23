class AddUnaccentExtension < ActiveRecord::Migration
  def up
    execute <<-SQL
      CREATE EXTENSION unaccent;
    SQL
  end

  def down
    execute <<-SQL
      DROP EXTENSION unaccent;
    SQL
  end
end
