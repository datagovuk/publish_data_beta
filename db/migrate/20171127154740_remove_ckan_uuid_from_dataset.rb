class RemoveCKANUuidFromDataset < ActiveRecord::Migration[5.1]
  def change
    remove_column :datasets, :ckan_uuid
  end
end
