class InstallmentsController < ApplicationController
  before_action :set_installments, only: %i[pay_installment]

  def index
    @installments = current_user.installments.includes(:installments).map(&:installments).flatten
    render json: @installments
  end

  def pay_installment
    amount_paid = params[:amount_paid].to_f
    user_choice = params[:user_choice]

    if amount_paid >= @installment.amount_due

      excess_amount = amount_paid - @installment.amount_due

      @installment.update!(
        amount_paid: @installment.amount_paid + @installment.amount_due,
        amount_due: 0,
        status: 'paid'
      )
      
      
      next_installment = @installment.enrollment.installments.where('id > ?', @installment.id).first

      while next_installment && excess_amount > 0 do
        if excess_amount >= next_installment.amount_due
          excess_amount -= next_installment.amount_due
          next_installment.update!(
            amount_paid: next_installment.amount_due,
            amount_due: 0,
            status: 'paid'
          )
          
        else
          next_installment.update!(
            amount_paid: next_installment.amount_paid + excess_amount,
            amount_due: next_installment.amount_due - (next_installment.amount_paid + excess_amount),
            status: 'partially paid'
          )
          excess_amount = 0
        end

        next_installment = @installment.enrollment.installments.where('id > ?', next_installment.id).first
      end

      render json: { msg: "Payment processed successfully." }, status: :ok
      
    elsif amount_paid < @installment.amount_due && 
      remaining_amount = @installment.amount_due - amount_paid

      if user_choice == 'add_to_next'
        next_installment = @installment.enrollment.installments.where('id > ?', @installment.id).first

        if next_installment
          next_installment.update!(
            amount_due: next_installment.amount_due + remaining_amount
          )
        else
          @installment.enrollment.installments.create!(
            amount_due: remaining_amount,
            amount_paid: 0,
            status: 'pending'
          )
        end

        @installment.update!(
          amount_due: 0,
          amount_paid: amount_paid,
          status: 'paid'
        )
  
        render json: { msg: "Remaining amount added to the next installment." }, status: :ok

      elsif user_choice == 'new_installment'

        @installment.enrollment.installments.create!(
          amount_due: remaining_amount,
          amount_paid: 0,
          status: 'pending'
        )

        @installment.update!(
          amount_paid: amount_paid,
          amount_due: 0,
          status: 'paid'
        )

        render json: { msg: "New installment created for the remaining amount." }, status: :ok

      else
        render json: { error: "Invalid option provided." }, status: :unprocessable_entity
      end

    end
  end

  private 

  def set_installments
    @installment = Installment.find(params[:id])
  end
end
