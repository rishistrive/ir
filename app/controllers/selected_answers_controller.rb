class SelectedAnswersController < ApplicationController
  before_action :set_selected_answer, only: [:show, :edit, :update, :destroy]

  # GET /selected_answers
  # GET /selected_answers.json
  def index
    @selected_answers = SelectedAnswer.all
  end

  # GET /selected_answers/1
  # GET /selected_answers/1.json
  def show
  end

  # GET /selected_answers/new
  def new
    @selected_answer = SelectedAnswer.new
  end

  # GET /selected_answers/1/edit
  def edit
  end

  # POST /selected_answers
  # POST /selected_answers.json
  def create
    @selected_answer = SelectedAnswer.new(selected_answer_params)

    respond_to do |format|
      if @selected_answer.save
        format.html { redirect_to @selected_answer, notice: 'Selected answer was successfully created.' }
        format.json { render :show, status: :created, location: @selected_answer }
      else
        format.html { render :new }
        format.json { render json: @selected_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /selected_answers/1
  # PATCH/PUT /selected_answers/1.json
  def update
    respond_to do |format|
      if @selected_answer.update(selected_answer_params)
        format.html { redirect_to @selected_answer, notice: 'Selected answer was successfully updated.' }
        format.json { render :show, status: :ok, location: @selected_answer }
      else
        format.html { render :edit }
        format.json { render json: @selected_answer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /selected_answers/1
  # DELETE /selected_answers/1.json
  def destroy
    @selected_answer.destroy
    respond_to do |format|
      format.html { redirect_to selected_answers_url, notice: 'Selected answer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_selected_answer
      @selected_answer = SelectedAnswer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def selected_answer_params
      params.require(:selected_answer).permit(:statement_id, :answer_value_id)
    end
end
