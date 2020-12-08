# encoding: utf-8
class CommunityQuestionAnswersController < ApplicationController
  # POST /answers
  # POST /answers.json
  def create
    @question = Question.find(params[:question_id])
    if @question.close?
      redirect_to community_question_path(params[:community_id], @question), notice: 'Вы не можите написать ответ, т.к. вопрос уже закрыт.'
    end
    @answer = @question.answers.new(params[:answer])
    @answer.user = current_user
    @answer.question = @question
    respond_to do |format|
      if @answer.save
        format.html { redirect_to community_question_path(params[:community_id], @question), notice: 'Ответ создан' }
        format.json { render json: @answer, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /answers/1
  # DELETE /answers/1.json
  def destroy
    @answer = Answer.find(params[:id])
    @answer.destroy

    respond_to do |format|
      format.html { redirect_to community_question_path(params[:community_id], params[:question_id]) }
      format.json { head :no_content }
    end
  end

  def best_answer
    @question = Question.find(params[:question_id])

    # Question id uniq! I replace this.
    #@question = current_user.communities.find(params[:community_id]).questions.find(params[:question_id])

    @answer = @question.answers.find(params[:id])
    @question.answer = @answer

    respond_to do |format|
      if @question.save
        format.html { redirect_to community_question_path(params[:community_id], @question), notice: 'Лучший ответ выбран. Вопрос закрыт.' }
        format.json { render json: @answer, status: :created, location: @answer }
      else
        format.html { render :new }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end
end
