helpers do
  def logged_in?
    if session[:id]
      @user = User.find_by_id(session[:id])
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