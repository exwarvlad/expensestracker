class ExpensesController < ApplicationController
  before_action :set_expense, only: [:edit, :update, :destroy]

  # GET /expenses
  # GET /expenses.json
  def index
    @expenses = Expense.all
    @expense = Expense.new
  end

  # GET /expenses/1
  # GET /expenses/1.json
  # def show
  # end

  # GET /expenses/new
  def new
    @expense = Expense.new
  end

  # GET /expenses/1/edit
  def edit
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        # format.js {}
        format.html { redirect_to root_path, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        # format.js {}
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    @total_sum = ActionController::Base.helpers.number_to_currency(
        Expense.pluck(:amount).sum, unit: '$', separator: '.', format: '%n %u'
    )
    respond_to do |format|
      format.html { redirect_to expenses_url, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
      format.js {}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def expense_params
      # params.fetch(:expense, {})
      params.require(:expense).permit(:name, :amount, :type_amount, :expense_type)
    end
end
