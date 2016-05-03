class InfosController < ApplicationController
  def like
  	@info = Info.find(params[:id])
  	respond_to do |format|
  		format.js
  		format.html
  	end
  end
end
