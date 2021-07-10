class AddQualityScores < ActiveRecord::Migration[5.1]
  def change
    create_table :quality_scores do |t|
      t.references :organisation, foreign_key: true
      t.integer :highest, default: 0
      t.integer :lowest, default: 0
      t.integer :average, default: 0
      t.integer :median, default: 0
      t.integer :total, default: 0
      t.string :organisation_name
      t.string :organisation_title
      t.timestamps
    end
  end
end
