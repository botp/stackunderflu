class VotesController < ApplicationController
  def create
    type = params[:voteable_type]

    if type == 'Question'
      @question = Question.find(params[:question_id])
      voteable = @question
      voteable.votes.create(:user_id => self.current_user.id, :vote_value => params[:vote_value])
      flash[:notice] = "Done."

      respond_to do |format|
        format.html { redirect_to question_path(@question) }
        format.js
      end

    elsif type == 'Answer'
      @question = Question.find(params[:question_id])
      @answer = Reply.find(params[:answer_id])
      voteable = @answer

      @answer.votes.create(:user_id => self.current_user.id, :vote_value => params[:vote_value])

      flash[:notice] = "Done."

      respond_to do |format|
        format.html { redirect_to question_path(@question) }
        format.js
      end

    else
      flash[:notice] = "Gawas"
      respond_to do |format|
      format.html { redirect_to questions_path }
      format.js
      end
    end

  end

  def destroy
    vote = Vote.find(params[:id])
    if vote.voteable_type ==  'Question' 
      @question = vote.voteable

      respond_to do |format|
        format.html { redirect_to(question_path(@question)) }
        format.js 
      end

    elsif vote.voteable_type == 'Reply'
      @answer = vote.voteable
      @question = @answer.repliable

      respond_to do |format|
        format.html { redirect_to(question_path(@question)) }
        format.js 
      end
    else

    
    end
    vote.destroy
  end
end
