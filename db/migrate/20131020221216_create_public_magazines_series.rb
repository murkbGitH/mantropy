class CreatePublicMagazinesSeries < ActiveRecord::Migration
  def up
    create_table :magazines_series do |t|
      t.string :placed
      t.references :magazine
      t.references :serie
    end
  end

  def down
    drop_table :magazines_series
  end
end
