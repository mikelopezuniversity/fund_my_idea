class AddFieldToProjects < ActiveRecord::Migration[6.0]
  def change
    add_column :projects, :expires_at, :datetime, default: DateTime.now + 30.days
  end
end
