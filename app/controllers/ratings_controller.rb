class RatingsController < ApplicationController
  def index
    @ratings = Rating.recent 3
    @breweries_top = Brewery.top 3
    @beers_top = Beer.top 3
    @styles_top = Style.top 3
    @users_top = User.top_raters 3

    #turha, tapahtuu aina automaattisesti railsissa: metodi index renderöi aina lopuksi automaatisesti index-näkymän
    render :index    # renderöin näkymätemplate /app/views/ratings/index.html
  end

  #luodaan uusi Rating-olio ja välitetään @rating-muuttujan avulla oletusarvoisesti renderöitävälle new.html.erb templatelle
  def new
    @rating = Rating.new
    #haetaan kannasta muuttujaan kaikki oluet
    @beers = Beer.all
  end

  # vanha versio ilman validointia
=begin
  def create
    rating = Rating.create params.require(:rating).permit(:score, :beer_id)
    current_user.ratings << rating

    #oletuksena täsä mentäisiin taas konvention mukaiseen html: create.html.erb
    redirect_to current_user
  end
=end


  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)


    if current_user.nil?
      redirect_to signin_path, notice: 'you should be signed in!'
    elsif @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    # vain ratingin tehnyt käyttäjä saa poistaa sen
    rating.delete if current_user == rating.user
    redirect_to :back
  end
end