class AuthorsController < ApplicationController
  # GET /authors/1
  # GET /authors/1.xml
  def show
    @author = Author.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @author }
      format.json { render :json => @author }
    end
  end
end
