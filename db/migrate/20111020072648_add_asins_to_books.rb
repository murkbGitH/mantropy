class AddAsinsToBooks < ActiveRecord::Migration
  def self.up
    add_column :books, :asin, :string
    add_column :books, :label, :string
  end

  def self.down
    remove_colmun :books, :asin
    remove_colmun :books, :label
  end
end
