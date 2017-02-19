# tämä rivi tarvitaan jotta api toimii herokussa ja travisissa
require 'beermapping_api'

class PlacesController < ApplicationController

  def index


  end

  def search
    @places = BeermappingApi.places_in(params[:city])
    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      session[:city] = params[:city]
      @weather = ApixuWeather.weather_in(session[:city])
      render :index
    end
  end

  def show
    city = session[:city]
    id = params[:id]

    @place = BeermappingApi.place(city, id).first
    if @place.nil?
      redirect_to places_path, notice: "No location found"
    end
  end

end