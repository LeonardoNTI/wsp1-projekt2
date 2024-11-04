# db/seeder.rb
require 'sqlite3'

DB = SQLite3::Database.new "db/todos.db"

# Exempel på seed-data
DB.execute("INSERT INTO todos (title, description) VALUES (?, ?)", ["Lära mig Ruby", "Kolla igenom alla viktiga delar av Ruby"])
DB.execute("INSERT INTO todos (title, description) VALUES (?, ?)", ["Bygga en webbapp", "Använda Sinatra och SQLite för att bygga en enkel webbapp"])
DB.execute("INSERT INTO todos (title, description) VALUES (?, ?)", ["Implementera CSS", "Gör designen snygg med CSS"])
DB.execute("INSERT INTO todos (title, description) VALUES (?, ?)", ["Lägga till interaktivitet", "Bygga dynamisk funktionalitet med JavaScript eller formulär i HTML"])

puts "Databasen har fyllts med seed-data!"
