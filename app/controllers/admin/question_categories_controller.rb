# encoding: utf-8
class Admin::QuestionCategoriesController < AdminController
  respond_to :js, :html

  def index
    @question_categories = QuestionCategory.all
    @question_category = @question_categories.detect {|cat| cat.id == params[:question_category_id].to_i}
    if params.has_key?(:question_category_id)
      @questions = Question.where(:question_category_id => params[:question_category_id]).page(params[:page]).per(5)
    else
      @questions = Question.page(params[:page]).per(5)
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  def show
    @question_categories = QuestionCategory.all
    @question_category = @question_categories.find {| cat | cat.id == params[:id].to_i }
  end

  def new
    @question_category = QuestionCategory.new
    respond_with(@question_category) do |format|
      format.js { render :layout => false}
    end
  end

  def edit
    @question_category = QuestionCategory.find(params[:id])
    respond_with(@question_category) do |format|
      format.js { render :layout => false }
    end
  end

  def create
    @question_category = QuestionCategory.new(params[:question_category])
    respond_to do |format|
      if @question_category.save
        format.html { redirect_to admin_question_categories_path, notice: 'Категория успешно создана' }
        format.js { render :text => "window.location = '#{admin_question_categories_path}'", notice: 'Категория успешно создана' }
      else
        format.html { render :new }
        format.js { render action: 'new', layout: false }
      end
    end
  end

  def update
    @question_category = QuestionCategory.find(params[:id])

    respond_to do |format|
      if @question_category.update_attributes(params[:question_category])
        format.html { redirect_to admin_question_category_path(@question_category ), notice: 'Категория успешно обновлена' }
        format.js { render :text => "window.location = '#{admin_question_category_path(@question_category )}'", notice: 'Категория успешно обновлена' }
      else
        format.html { render :edit }
        format.js { render action: 'edit', layout: false }
      end
    end
  end

  def destroy
    @question_category = QuestionCategory.find(params[:id])
    @question_category.destroy

    respond_to do |format|
      format.html { redirect_to admin_question_categories_path }
      format.json { head :no_content }
    end
  end

  def destroy_question
    @question = Question.fing(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to admin_question_categories_path }
      format.json { head :no_content }
    end
  end

end
