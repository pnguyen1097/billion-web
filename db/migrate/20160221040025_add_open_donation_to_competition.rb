class AddOpenDonationToCompetition < ActiveRecord::Migration
  def change
    add_column :competitions, :open_donation, :boolean, null: false, default: true
  end
end
