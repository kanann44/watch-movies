class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|
      t.string :title
      t.string :movie_image
      t.text :comment

      t.timestamps
    end
  end
end
