class CreateAuthorsBooks < ActiveRecord::Migration
  def self.up
    create_table :authors_books do |t|
      t.string :role
      t.references :author
      t.references :book

      t.timestamps
    end
  end

  def self.down
    drop_table :authors_books
  end
end
