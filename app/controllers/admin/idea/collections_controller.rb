# encoding: utf-8
class Admin::Idea::CollectionsController < AdminController
  layout 'admin_application'

  before_filter :find_collection, except: [:index, :new, :create]

  def index
    @collections = ::Idea::Collection.all
  end

  def new
    @collection = ::Idea::Collection.new
  end

  def create
    @collection = ::Idea::Collection.new(params[:idea_collection])
    if @idea_collection.save
      redirect_to admin_idea_collection_path(@collection)
    else
      render :new
    end
  end

  def show
    @ideas = @collection.ideas.ordered.page(params[:page])
  end

  def edit
    if params.has_key? :list
      @ideas = @collection.ideas.where(id: params[:list])
    else
      @ideas = @collection.ideas
    end
  end

  def update
    @collection_form = IdeaCollectionForm.new(@collection)

    respond_to do |format|
      if @collection_form.submit(params[:idea_collection])
        format.html { redirect_to admin_idea_collection_path(@collection) }
        format.js { render js: "window.location = '#{@collection_form.redirect_url}';" }
      else
        format.html { render :edit }
        format.js { render js: 'alert("no no no no");' }
      end
    end
  end

  def destroy
    @collection.destroy
    redirect_to :back
  end

  private
  def find_collection
    @collection = ::Idea::Collection.find(params[:id])
  end
end
