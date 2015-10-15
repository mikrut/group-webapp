class SearchController < ApplicationController
  def find
    @query = nil
    @results = []
    if params.has_key? :q
      @query = params[:q]
      @results = ThinkingSphinx.search params[:q]
    end
  end
end
