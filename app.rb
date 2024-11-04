# app.rb
require 'sinatra'
require 'sqlite3'

# Skapa/anslut till en SQLite-databas
DB = SQLite3::Database.new "db/todos.db"

# Skapa tabellen om den inte redan finns
DB.execute <<-SQL
  CREATE TABLE IF NOT EXISTS todos (
    id INTEGER PRIMARY KEY,
    title TEXT,
    description TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
  );
SQL

class App < Sinatra::Base
  get '/' do
    # Hämta alla ToDos från databasen
    @todos = DB.execute("SELECT * FROM todos")
    erb :index
  end

  post '/todos' do
    # Lägg till en ny ToDo i databasen
    DB.execute("INSERT INTO todos (title, description) VALUES (?, ?)", [params[:title], params[:description]])
    redirect '/'
  end

  run! if app_file == $0
end
