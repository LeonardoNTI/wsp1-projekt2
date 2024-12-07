require 'sqlite3'

class Seeder
  
  def self.seed!
    drop_tables
    create_tables
    populate_tables
  end

  def self.drop_tables
    db.execute('DROP TABLE IF EXISTS todos')
  end

  def self.create_tables
    db.execute('CREATE TABLE todos (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT NOT NULL,
                description TEXT)')
  end

  def self.populate_tables
   db.execute('INSERT INTO todos (name, description) VALUES ("Inköpslista", "Gå till affären och köp, mjölk, ägg, äpplen, lingon, apelsin och aprekos för mormors specialpaj")')
  end

  private
  def self.db
    return @db if @db
    @db = SQLite3::Database.new('db/todos.sqlite')
    @db.results_as_hash = true
    @db
  end
end


Seeder.seed!