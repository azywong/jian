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

get "/oauth/connect" do
  redirect Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
end

get "/oauth/callback/" do
  response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
  session[:access_token] = response.access_token
  redirect "/nav"
end

get "/nav" do
  erb :nav
end

post '/tags' do
  redirect "/tags/#{params[:tagsearch]}"
end

get '/tags/:tagsearch' do
  @client = Instagram.client(:access_token => session[:access_token])
  @tags = @client.tag_search(params[:tagsearch])
  erb :tag
end