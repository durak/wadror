class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # helper-metodi, jotta saadaan näkymiin käyttöön
  helper_method :current_user

  # Koska kaikki kontrollerit perivät tämän luokan, tulee metodi niiden käyttöön
  # ja koska se on määritelty helper-metodiksi, se on nyt kaikkien näkymienkin käytössä
  def current_user
    return nil if session[:user_id].nil?
    User.find(session[:user_id])
  end

end
