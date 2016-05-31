class ControlPanel::TransactionsController < ControlPanel::BaseController

  def create
    transaction = Transaction.new(transaction_params)
    transaction.points = transaction.amount * @competition.dollar_to_point
    recipient = transaction.recipient
    if recipient.eliminated?
      flash[:error] = "#{recipient.name} has already been eliminated."
    elsif transaction.save
      flash[:success] = "#{recipient.name} received $#{transaction.amount} (#{transaction.points} pts)"
    else
      flash[:error] = "An error occurs while creating the transaction."
    end

    redirect_to control_panel_root_url
  end

  private

  def transaction_params
    params.require(:transaction).permit(:amount, :recipient_id).merge({
      competition_id: @competition.id,
      recipient_type: 'Project'
    })
  end
end
