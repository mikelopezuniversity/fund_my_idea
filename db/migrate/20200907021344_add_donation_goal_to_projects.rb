class AddDonationGoalToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :donation_goal, :decimal, default: 0
  end
end
