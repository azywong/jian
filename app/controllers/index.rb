get "/" do
  @client = Instagram.client(:access_token => session[:access_token])
  @media = @client.media_popular
  if logged_in?
    @tags = @usertags.uniq.map do |tag|
      @client.tag_search(tag)
    end
  else
    @tags = []
  end
  erb :index
end

#------AUTHENTICATION------
get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback/" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/"
end

#------SESSIONS------

post '/sessions' do
  @user = User.find_by_username(params[:username])
  if @user
    if @user.password == params[:password]
      session[:id] = @user.id
    end
    redirect '/'
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
get '/tags' do
  erb :tracking
end

post '/tags' do
  redirect "/tags/#{params[:tagsearch]}"
end

get '/tags/:tagsearch' do
if logged_in?
  @client = Instagram.client(:access_token => session[:access_token])
  @tags = @client.tag_search(params[:tagsearch])
  usertags = User.find_by_id(session[:id]).tags
  @usertags = usertags.map { |tag| tag.name }
end
  erb :tag
end

post '/users/:id/tag/:name' do
  tag = Tag.find_by_name(params[:name])
  user = User.find_by_id(session[:id])
  # FIND OR CREATE !!!!
  if tag != nil
    user.tags << tag
  else
    tag = Tag.create(name: params[:name])
    user.tags << tag
  end
  params[:url].to_json
end

delete '/users/:id/tag/:name' do
  user = User.find_by_id(session[:id])
  tags = user.tags.where(name:params[:name]).destroy_all
  params[:url].to_json
end


#------IMAGES------
get '/images' do
  client = Instagram.client(:access_token => session[:access_token])
  @media = client.media_popular
  erb :browse
end

get '/users/:id/images' do
  if logged_in?
    @client = Instagram.client(:access_token => session[:access_token])
    @tags = @usertags.uniq.map do |tag|
      @client.tag_search(tag)
    end
    erb :feed
  end
end