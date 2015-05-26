class SearchController < ApplicationController
  authorize_resource

  respond_to :html

  def search
    @results = Search.search(params[:query], params[:search_option])
    respond_with @results
  end
end
