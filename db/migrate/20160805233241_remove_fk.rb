class RemoveFk < ActiveRecord::Migration
  def change
    remove_column :posts, :sub_id, :integer
  end
end
