class SearchController < ApplicationController
  def find
    @results = Material.search params[:q]
  end
end
