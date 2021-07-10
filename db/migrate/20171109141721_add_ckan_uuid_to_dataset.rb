class AddCKANUuidToDataset < ActiveRecord::Migration[5.1]
  def change
    add_column :datasets, :ckan_uuid, :string
  end
end
