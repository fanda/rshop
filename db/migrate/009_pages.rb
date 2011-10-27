class Pages < ActiveRecord::Migration
  def self.up
    create_table "pages", :force => true do |t|
      t.string   "title"
      t.string   "url"
      t.text     "body"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    add_index :pages, :url
  end

  def self.down
    remove_index :pages, :url
    drop_table 'pages'
  end
end
