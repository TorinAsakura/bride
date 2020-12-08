#encoding: utf-8
class BackgroundPropertiesController < ApplicationController
  respond_to :json

  def index
    @styles = BackgroundProperty.active.popular.mini_site.ordered
    per = 10
    if (@type = params[:type]).present?
      case @type
      when 'headers'
        @styles = @styles.headers
        per = 5
      when 'backgrounds'
        @styles = @styles.backgrounds
        per = 12
      else
      end
    end
    @styles = @styles.page(params[:page]).per(per).decorate

    respond_with(@styles) do |format|
      c = @styles.current_page
      t = @styles.total_pages
      pages = {current: c,total: t}
      pages[:prev] = c-1 if c>1
      pages[:next] = c+1 if c<t
      format.json {render json: {status: :ok, html: {
          list: render_to_string(partial: 'background_property', collection: @styles, formats: [:html], layout: false),
          pages: pages
      }}}
    end
  end
end