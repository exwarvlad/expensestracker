class ExpensesController < ApplicationController
  before_action :set_expenses, except: [:new, :edit]
  before_action :set_expense, only: [:edit, :update, :destroy]
  before_action :set_filter, only: :index
  # before_action :set_filterable_expenses, except: [:new, :edit]

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
    # byebug
    @expense = Expense.new(expense_params)
    @expense.user_id = current_user.id
    respond_to do |format|
      if @expense.save
        format.html { redirect_to root_path, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
        format.js { flash.now[:notice] = 'Expense was successfully created.' }
      else
        format.html { render :new }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
        format.js
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
        format.js { flash.now.notice = 'Expense was successfully updated.' }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
        format.js { render :edit }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
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
    params.require(:expense).permit(:name, :amount, :type_amount, :expense_type, currency_attributes: [:name])
  end

  def set_expenses
    @expenses = Filter.check_expenses(current_user.id)
  end
end