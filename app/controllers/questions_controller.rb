class QuestionsController < ApplicationController
  before_action :require_login
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  # GET /questions
  # GET /questions.json
  def index
    @questions = Question.all
  end

  # GET /questions/1
  # GET /questions/1.json
  def show
    @question = Question.find(params[:id])
    @answers =@question.answers
    @comment = Reply.new
  end

  # GET /questions/new
  def new
    @question = Question.new
  end

  # GET /questions/1/edit
  def edit
     @question = Question.find(params[:id])
     unless current_user.id == @question.user_id
      redirect_to questions_path, :notice => "Not permitted."
     end
  end
  # POST /questions
  # POST /questions.json
  def create
    @question = Question.new(question_params)

    respond_to do |format|
      if @question.save
        format.html { redirect_to @question, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @question }
      else
        format.html { render :new }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /questions/1
  # PATCH/PUT /questions/1.json
  def update
    respond_to do |format|
      if @question.update(question_params)
        format.html { redirect_to @question, notice: 'Question was successfully updated.' }
        format.json { render :show, status: :ok, location: @question }
      else
        format.html { render :edit }
        format.json { render json: @question.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /questions/1
  # DELETE /questions/1.json
  def destroy
    if current_user.id == @question.user_id
      @question.destroy
      redirect_to questions_path
    else
      redirect_to questions_path, :notice => "Not permitted."
    end
  end

  def filter_tag
    @tag = Tag.find_by_name(params[:id])
    @questions = Question.all

    @question_arr = []

    @questions.each do |question|
      @question_arr << question if question.tags_list.split(", ").include?(@tag.name)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_question
      @question = Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :body, :user_id, :tags_list)
    end


    def require_login
      if current_user

      else
      # flash[:error] = "You must be logged in to access this section"
      redirect_to sessions_new_url
    end
  end
  
end
