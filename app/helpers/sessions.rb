helpers do
  def logged_in?
    if session[:id]
      @user = User.find(session[:id])
    else
      nil
    end
  end

  def connected?
    if session[:access_token]
      @access_token = session[:access_token]
    else
      nil
    end
  end
end