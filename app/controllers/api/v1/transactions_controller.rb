class Api::V1::TransactionsController < ApplicationController
  before_action :authenticate_api_v1_user!

  # GET /api/v1/transactions
  def index
    @api_v1_transactions = Transaction.all

    render json: @api_v1_transactions
  end

  # GET /api/v1/transactions/1
  def show
    @api_v1_transaction = Transaction.find_by_id(params[:id])
    if @api_v1_transaction
      render json: @api_v1_transaction
    else
      render status: :not_found
    end
  end

  # POST /api/v1/transactions
  def create
    @api_v1_transaction = Transaction.new(transaction_params)

    if @api_v1_transaction.save
      render json: @api_v1_transaction, status: :created
    else
      render json: @api_v1_transaction.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v1/transactions/1
  def update
    @api_v1_transaction = Transaction.find_by_id(params[:id])
    if @api_v1_transaction
      if @api_v1_transaction.update(transaction_params)
        render json: @api_v1_transaction
      else
        render json: @api_v1_transaction.errors, status: :unprocessable_entity
      end
    else
      render status: :not_found
    end
  end

  # DELETE /api/v1/transactions/1
  def destroy
    @api_v1_transaction = Transaction.find_by_id(params[:id])
    if @api_v1_transaction
      @api_v1_transaction.destroy
      render status: :no_content
    else
      render status: :not_found
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_api_v1_transaction

  end

  # Only allow a trusted parameter "white list" through.
  def transaction_params
    params.require(:transaction).permit(:symbol, :description, :value, :amount)
  end
end
