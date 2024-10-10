class EnrollmentsController < ApplicationController

  def index
    @enrolled_courses = current_user.enrollments.includes(:course, :installments)
  
    render json: @enrolled_courses.to_json(include: { 
      course: { only: [:id, :name, :price, :photo] }, 
      installments: { only: [:id, :amount_due, :amount_paid, :status] } 
    })
  end

  def create
    @enrollment = current_user.enrollments.new(enrollment_params)

    if @enrollment.save
      first_installment = @enrollment.installments.first
      
      if first_installment
        first_installment.update!(
          amount_paid: params[:amount_paid],
          amount_due: 0,
          status: params[:amount_paid] < first_installment.amount_due ? 'partially paid' : 'paid'
        )
      end

      render json: { msg: "Enrollment and first installment created successfully." }, status: :created
    else
      render json: { error: @enrollment.errors.full_messages }, status: :unprocessable_entity
    end
  end



  private

  def enrollment_params
    params.permit(:course_id, :number_of_installments)
  end
end
