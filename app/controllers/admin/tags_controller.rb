# encoding: utf-8
class Admin::TagsController < AdminController
  layout 'admin_application'

  def index
    params[:usual]||={}
    params[:accepted]||={}
    # if request via js we calculate only requested column

    unless request.xhr? && params[:usual].empty?
      frequency_usual = params[:usual][:count].present? ? params[:usual][:count] : 0

      @usual_tags = Tag.usual.page(params[:usual][:page]).per(10).
                    search(params[:usual][:search]).
                    merge( Tag.frequency_filter(frequency_usual) )
    end

    unless request.xhr? && params[:accepted].empty?
      frequency_accepted = params[:accepted][:count].present? ? params[:accepted][:count] : 0

      @accepted_tags = Tag.accepted.page(params[:accepted][:page]).per(10).
                        search(params[:accepted][:search]).
                        merge( Tag.frequency_filter(frequency_accepted) )
    end
    params[:usual].slice!(:search)
    params[:accepted].slice!(:search)
  end

  def edit
    @tag = Tag.color.find(params[:id])
  end

  def new
    @tag = Tag.new
    render :edit
  end

  def create
    if Tag.create(params[:acts_as_taggable_on_tag])
      redirect_back
    else
      redirect_back "!Error"
    end
  end

  def update
    tag = Tag.color.find(params[:id])
    if tag.update_attributes(params[:acts_as_taggable_on_tag])
      redirect_back
    else
      redirect_back "!Error"
    end
  end

  def destroy
    tag = Tag.find(params[:id])
    render json: tag.to_json(only: 'color') if tag.destroy
  end

  def accept
    tag = Tag.find(params[:id])
    if tag.update_attributes(accepted: !tag.accepted)
      redirect_to action: 'index', accepted: {change: true}, usual: {change: true}
    else
      redirect_back "!Erorr"
    end
  end

end
