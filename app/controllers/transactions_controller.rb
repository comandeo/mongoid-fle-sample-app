class TransactionsController < ApplicationController

  before_action :set_bank_account, only: %i[create]
  def new
    @transaction = Transaction.new
    @bank_accounts = User.current_user.bank_accounts.only(:_id, :name)
  end

  def create
    @transaction = Transaction.new(transaction_params)
    @transaction.bank_account = @bank_account

    respond_to do |format|
      if @transaction.save
        format.html { redirect_to root_path, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        @bank_accounts = User.current_user.bank_accounts.only(:_id, :name)
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction.errors, status: :unprocessable_entity }
      end
    end

  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :description, :completed_at)
  end

  def set_bank_account
    bank_account_id = params.dig(:transaction, :bank_account_id)
    @bank_account = User.current_user.bank_accounts.find(bank_account_id)
  end
end
