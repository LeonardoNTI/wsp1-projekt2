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
 
    todo_params = [params['name'], params['description']]
    db.execute("INSERT INTO todos (name, description) VALUES (?,?)", todo_params)

    redirect '/todo'
  end

  post '/todo/:id/delete' do | id |
    db.execute("DELETE FROM todos WHERE id =?", id).first

    redirect '/todo'
  end

  get '/todo/:id/edit' do | id |
    @todo = db.execute("SELECT * FROM todos WHERE id = ?", id).first
    erb :"edit"
  end

  post '/todo/:id/update' do |id|
    todo_params = [params['name'], params['description'], id]
    db.execute("UPDATE todo SET name = ?, description = ? WHERE id = ?", todo_params)
    redirect "/todo/#{id}"
end

end