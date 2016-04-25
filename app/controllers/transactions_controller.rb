class TransactionsController < ApplicationController
  DOLLAR_TO_POINT = 1

  rescue_from Payment::RecordInvalid, with: :render_payment_error
  rescue_from ActiveRecord::RecordInvalid, with: :render_error

  before_action :set_projects
  before_action :clean_amount, only: [:create]

  def new
    @projects = @competition.projects.active
    @project = @projects.find_by id: params[:project_id]
    @transaction = Transaction.new(recipient_id: @project.try(:id))
  end

  def create
    @project = @competition.projects.find_by(id: params[:transaction][:recipient_id])

    unless authorize_project(@project)
      @transaction = Transaction.new(recipient_id: @project.try(:id))
      return render :new
    end

    purchase_and_allocate_points
    TransactionMailer.confirmation(@purchase, @transaction).deliver_now

    render :create, status: :created
  end

  private

  def purchase_and_allocate_points
    ActiveRecord::Base.transaction do
      set_temp_user
      purchase_points
      allocate_points
      accept_payment
    end
  end

  def authorize_project(project)
    if project.nil?
      flash[:error] = ['The selected beer does not exists.']
    elsif project.eliminated?
      flash[:error] = ['The selected beer has been eliminated.']
    end

    return true if flash[:error].blank?
  end

  def set_projects
    @projects = @competition.projects.active
  end

  def clean_amount
    params.tap do |p|
      amount = p[:transaction] && p[:transaction][:amount]
      p[:transaction][:amount] = amount.gsub(/[$,]/, '') if amount.present?
    end
  end

  def set_temp_user
    transaction = params[:transaction]
    temp_user = transaction && transaction[:temp_user]
    email = temp_user && temp_user[:email]

    @temp_user = TempUser.find_or_create_by! email: email
  end

  def purchase_params
    params.require(:transaction).permit(:amount).merge(
      recipient_type: @temp_user.class.name,
      recipient_id: @temp_user.id,
      competition_id: @competition.id
    )
  end

  def transaction_params
    params.require(:transaction).permit(:recipient_id).merge(
      recipient_type: 'Project',
      sender_type: @temp_user.class.name,
      sender_id: @temp_user.id,
      competition_id: @competition.id
    )
  end

  def accept_payment
    nonce = params[:payment_method_nonce]
    amount = params[:transaction] && params[:transaction][:amount]
    payment = Payment.new nonce, amount

    payment.pay!
  end

  def purchase_points
    @purchase = Transaction.new purchase_params
    @purchase.points = ((@purchase.amount || 0) * DOLLAR_TO_POINT).ceil
    @purchase.save!
  end

  def allocate_points
    @transaction = Transaction.new transaction_params
    @transaction.points = @purchase.points
    @transaction.save!
  end

  def render_payment_error(exception)
    @transaction ||= Transaction.new
    flash[:error] = exception.record.errors
    render :new, status: :ok
  end

  def render_error(exception)
    @transaction ||= Transaction.new
    flash[:error] = exception.record.errors.full_messages
    render :new, status: :ok
  end
end
