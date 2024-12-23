class App < Sinatra::Base
  
  def db
    return @db if @db

    @db = SQLite3::Database.new("db/todos.sqlite")
    @db.results_as_hash = true

    return @db
  end

  configure do
    enable :sessions
    set :session_secrets, SecureRandom.hex(64)
  end

  get '/' do 
    if session[:user_id]
      erb(:"admin/index")
    else
      erb(:"index")
    end
  end

  get '/admin' do
    if session[:user_id]
      erb(:"admin/index")
    else
      p "/admin : Access dnied."
      status 404
      redirect '/unauthorized'
    end
  end

  post '/login' do
    request_username =
     params[:username]
    request_plain_password = params[:password]

    user = db.execute("SELECT * FROM users WHERE username =?", request_username).first

    unless user
      p "/login : Invalid username."
      status 401
      redirect '/unauthorized'
    end

    db_id = user["id"].to_i
    db_password_hashed = user["password"].to_s

    bcrypt_db_password = BCrypt::Password.new(db_password_hashed)

    if bcrypt_db_password == request_plain_password
      session[:user_id] = db_id
      @todos = 
      redirect '/todos'
    else
      status 401
      redirect '/unauthorized'
    end
  end

  get '/unauthorized' do
    erb(:unauthorized)
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/todos' do
    @todos = db.execute('SELECT * FROM todos')
    @users = db.execute('SELECT * FROM users WHERE id = ?', session[:user_id]).first

    erb(:"admin/index")
  end

  post '/todos' do 
 
    todo_params = [params['name'], params['description'], session[:user_id]]
    db.execute("INSERT INTO todos (name, description, user_id) VALUES (?,?,?)", todo_params)

    redirect '/todos'
  end

  post '/todos/:id/delete' do | id |
    db.execute("DELETE FROM todos WHERE id =?", id).first

    redirect '/todos'
  end

  get '/todos/:id/edit' do | id |
    @todo = db.execute("SELECT * FROM todos WHERE id = ?", id).first
    erb :"edit"
  end

  post '/todos/:id/update' do |id|
    todo_params = [params['name'], params['description'], id]
    db.execute("UPDATE todos SET name = ?, description = ? WHERE id = ?", todo_params)
    redirect "/todos"
  end

end