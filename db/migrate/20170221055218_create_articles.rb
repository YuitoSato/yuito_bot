class CreateArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :articles do |t|
      t.string   :title
      t.string   :url
      t.text     :content
      t.time     :published_at

      t.timestamps
    end
  end
end
