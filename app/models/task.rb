class Task < ApplicationRecord
  validates :name, presence: true, format: { with: /\A[a-zA-Z0-9 ]+\z/, message: 'Only letters and numbers allowed' }
  validates :description, length: { maximum: 100 }
  validate :name_cannot_be_updated_if_in_progress, on: :update

  belongs_to :user, optional: true

  enum status: [:active, :in_progress, :inactive]
  
  private

    def name_cannot_be_updated_if_in_progress
      if name_was != name && status == 'in_progress'
        errors.add(:name, 'cannot be updated if status is in progress')
      end
    end

end
