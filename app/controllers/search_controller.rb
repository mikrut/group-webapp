class SearchController < ApplicationController
  def find
    @query = nil
    @results = []
    if params.key? :q
      @query = params[:q]
      @results = ThinkingSphinx.search @query
    end
  end

  def find_helper
    @query = nil
    @results = []
    if params.key? :q
      @query = params[:q]
      @results = ThinkingSphinx.search(@query, star: true, ranker: :sph04).collect(&:title)
    end
    render json: [
      @query,
      @results
    ]
  end
end
