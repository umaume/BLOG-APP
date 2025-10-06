class AddCategoryToPostsAndAddSlug < ActiveRecord::Migration[8.0]
  def change
    add_reference :posts, :category, null: true, foreign_key: true
    add_column :posts, :slug, :string
    add_index :posts, :slug, unique: true
  end
end
