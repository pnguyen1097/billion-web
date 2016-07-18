class AddWineToProject < ActiveRecord::Migration
  def change
    add_column :projects, :wine, :boolean, default: false, null: false
  end
end
