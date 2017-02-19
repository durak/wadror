class StylesController < ApplicationController
  before_action :set_style, only: [:show]
  before_action :ensure_that_signed_in, except: [:index, :show]


  def index
    @styles = Style.all
  end


  def show

  end


  private

  def set_style
    @style = Style.find(params[:id])
  end

  def style_params
    params.require(:style).permit(:name, :description)
  end
end