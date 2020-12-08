class AddInfoToClients < ActiveRecord::Migration
  def change
    add_column :clients, :activities, :text
    add_column :clients, :interests, :text
    add_column :clients, :favorite_music, :text
    add_column :clients, :favorite_films, :text
    add_column :clients, :favorite_shows, :text
    add_column :clients, :favorite_books, :text
    add_column :clients, :favorite_games, :text
    add_column :clients, :favorite_quotes, :text
    add_column :clients, :about, :text
  end
end
