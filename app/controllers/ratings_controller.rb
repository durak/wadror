class RatingsController < ApplicationController
  def index
    @ratings = Rating.all
    #turha, tapahtuu aina automaattisesti railsissa: metodi index renderöi aina lopuksi automaatisesti index-näkymän
    render :index    # renderöin näkymätemplate /app/views/ratings/index.html
  end

  #luodaan uusi Rating-olio ja välitetään @rating-muuttujan avulla oletusarvoisesti renderöitävälle new.html.erb templatelle
  def new
    @rating = Rating.new
    #haetaan kannasta muuttujaan kaikki oluet
    @beers = Beer.all
  end

  def create
    Rating.create params.require(:rating).permit(:score, :beer_id)
    #oletuksena täsä mentäisiin taas konvention mukaiseen html: create.html.erb
    redirect_to ratings_path
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete
    redirect_to ratings_path
  end
end