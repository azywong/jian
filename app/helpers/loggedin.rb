helpers do
  def logged_in?
    if session[:id]
      @user = User.find(session[:id])
    else
      nil
    end
  end
end