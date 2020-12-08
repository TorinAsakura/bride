# encoding: utf-8
class CitiesController < ApplicationController
  skip_before_filter :authenticate_user!, only: :autocomplete

  def autocomplete
    scope = City.scoped
    scope = scope.enabled_for_firms if params[:firms_only]
    if (firm_id = params[:firm_id]).present?
      firm = Firm.find(firm_id)
      scope = scope.without_cities(firm.all_cities_ids) if firm.all_cities_ids.present?
    end
    result = (id = params[:id]).present? ? scope.find(id) : scope.search_like_name(params[:query])
    render json: result.as_json(only: :id, methods: :full_name)
  end

  def update
    current_user.client.update_attribute(:city, City.find(params[:city_id]))
    render json: {status: "success"}
  end
end