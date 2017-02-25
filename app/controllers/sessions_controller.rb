class SessionsController < ApplicationController
  def new
    #renderöidään kirjautumissivu
  end

  def create
    #haetaan syötettyä usernamea vastaava käyttäjä tietokannasta
    user = User.find_by username: params[:username]

    if user && user.authenticate(params[:password])

      if user.blocked
        redirect_to :back, notice: "Your account is frozen, please contact admin."
      else
        session[:user_id] = user.id
        redirect_to user, notice: "Welcome back!"
      end

    else
      redirect_to :back, notice: "Username and/or password mismatch"
    end



=begin
    if user.nil?
      redirect_to :back, notice: "User #{params[:username]} does not exist."
    else
      #talletetaan sessioon käyttäjä id, jos käyttäjä on olemassa
      session[:user_id] = user.id
      #ohjataan käyttäjän omalle sivulle
      redirect_to user, notice: "Welcome back!"
    end
=end

  end

  def destroy
    #nollataan sessio
    session[:user_id] = nil
    redirect_to :root
  end
end