class Installment < ApplicationRecord
  belongs_to :enrollment

  validates :amount_due, :amount_paid, :status, presence: true

  def update_status
    if amount_paid >= amount_due
      update(status: 'paid')
    elsif amount_paid > 0
      update(status: 'partially paid')
    else
      update(status: 'pending')
    end
  end
end
