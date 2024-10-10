class Enrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_many  :installments, dependent: :destroy

  validates :user_id, uniqueness: { scope: :course_id, message: 'Already enrolled this course'}

  after_create :create_installments
  
  private

  def create_installments
    total_price = self.course.price
    installment_amount = (total_price / number_of_installments).round(2)

    number_of_installments.times do |i|
      Installment.create!(
        enrollment: self,
        amount_due: installment_amount,
        status: 'pending'
      )
    end
  end

end
