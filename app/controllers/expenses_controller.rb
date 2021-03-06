class ExpensesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_expenses, except: [:new, :edit]
  before_action :set_currency_convert, only: :index
  before_action :set_expense, only: [:edit, :update, :destroy]
  before_action :set_filter, only: :index

  # GET /expenses
  # GET /expenses.json
  def index
  end

  # GET /expenses/new
  def new
    @expense = Expense.new
    respond_to do |format|
      format.html
      format.js { render template: 'expenses/modal' }
    end
  end

  # GET /expenses/1/edit
  def edit
    respond_to do |format|
      format.html
      format.js { render template: 'expenses/modal' }
    end
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = ExpenseService.create(expense_params, current_user.id)
    respond_to do |format|
      if @expense.errors.empty?
        format.html { redirect_to root_path, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
        format.js { flash.now[:notice] = 'Expense was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
        format.js { render template: 'expenses/modal_errors' }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    @before_expense = @expense.attributes
    @before_expense['currency'] = @expense.currency.attributes
    @before_position = @expenses.page(params[:page]).find_index { |exp| exp.id == @expense.id }
    ExpenseService.update(@expense, expense_params)

    respond_to do |format|
      if @expense.errors.empty?
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
        format.js { flash.now.notice = 'Expense was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
        format.js { render template: 'expenses/modal_errors' }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      flash.now.notice = 'Expense was successfully destroyed.'
      format.html { redirect_to root_path, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
      format.js { flash.now.notice = 'Expense was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = Expense.find(params[:id])
  end

  def set_filter
    filter = Filter.find { |f| f.user_id == current_user.id }.data['duration']
    @filter = Filter.check_duration_range(filter)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def expense_params
    params.require(:expense).permit(:name, :amount, :type_amount, :expense_type, :created_at, currency_attributes: [:name])
  end

  def set_expenses
    @expenses = Filter.check_expenses(current_user.id).page(params[:page])
    @expenses_before = @expenses.dup.to_a
  end

  def set_currency_convert
    if params[:page].nil?
      current_user.currency_convert.update_bank(@expenses, current_user.filter.currency.name)
      current_user.currency_convert.transfer_transit
    end
  end
end