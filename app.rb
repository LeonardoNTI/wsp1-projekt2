class App < Sinatra::Base
  
  def db
    return @db if @db

    @db = SQLite3::Database.new("db/todos.sqlite")
    @db.results_as_hash = true

    return @db
  end

  get '/' do 
    redirect('/todo')
  end

  get '/todo' do
    @todos = db.execute('SELECT * FROM todos')
    erb(:"index")
  end

  post '/todo/add' do 
    name = params["name"]
    description = params["desription"]

  end


end