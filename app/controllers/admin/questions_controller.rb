class Admin::QuestionsController < AdminController

  respond_to :js, :html
  # GET /admin/questions
  # GET /admin/questions.json
  def index
    @search = Question.search(params[:search])
    @questions = @search.page(params[:page]).per(5)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @questions }
    end
  end

  def recommend
    @question = Question.find(params[:id])
    @question.recommend!
    respond_to do |format|
      format.html { redirect_to admin_questions_url }
      format.json { head :no_content }
    end
  end
  def unrecommend
    @question = Question.find(params[:id])
    @question.unrecommend!
    respond_to do |format|
      format.html { redirect_to admin_questions_url }
      format.json { head :no_content }
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = Question.find(params[:id])
    respond_with(@question) do |format|
      format.js { render :layout => false }
    end
  end

  def update
    @question = Question.find(params[:id])

    respond_to do |format|
      if @question.update_attributes(params[:question])
        format.html { redirect_to admin_question_categories_path, notice: 'Question succesfully updated' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.js { render action: 'edit', layout: false }
      end
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy

    respond_to do |format|
      format.html { redirect_to admin_question_categories_url }
      format.json { head :no_content }
    end
  end
end
