class RemoveExpiresAtFromProjects < ActiveRecord::Migration[6.0]
  def change
    remove_column :projects, :expires_at, :datetime
  end
end
