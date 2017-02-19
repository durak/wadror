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
      render :index
    end

  end

end