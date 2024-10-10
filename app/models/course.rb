class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
end
