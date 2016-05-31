class AddDollarToPointToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :dollar_to_point, :integer, null: false, default: 1
  end
end
