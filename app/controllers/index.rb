CALLBACK_URL = "http://localhost:9393/oauth/callback/"

Instagram.configure do |config|
  config.client_id = "bbda684a4c6041308b56b2eb99b381a4"
  config.client_secret = "c2d5fd84ed594c93b1b19a7dfb10a02a"
  # For secured endpoints only
  #config.client_ips = '<Comma separated list of IPs>'
end

get "/" do
  erb :index
end

get "/nav" do
  erb :nav
end

#------AUTHENTICATION------
get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback/" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/nav"
end

#------SESSIONS------

post '/sessions' do
  @user = User.find_by_username(params[:username])
  if @user
    if @user.password == params[:password]
      session[:id] = @user.id
      redirect '/'
    else
      redirect '/'
    end
  else
    redirect '/users/new'
  end
end

delete '/sessions/:id' do
  session.clear
  redirect '/'
end

#------USERS------
get '/users/new' do
  erb :sign_up
end

post '/users' do
  @user = User.create(params)
  redirect '/'
end

#------TAGS------
post '/tags' do
  redirect "/tags/#{params[:tagsearch]}"
end

get '/tags/:tagsearch' do
  @client = Instagram.client(:access_token => session[:access_token])
  @tags = @client.tag_search(params[:tagsearch])
  erb :tag
end

post '/tag/:name' do
  @tag = Tag.find_by_name(params[:name])
  if @tag
    # add to user's interests
  else
    # create tag
    # add to user's interests
  end
  erb :tag
end