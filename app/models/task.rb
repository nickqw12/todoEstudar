class Task < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  validates_presence_of :title
  validate :future_due_date

  def future_due_date
    self.errors.add(:due, "Cant be in the past!") if !due.blank? && due < Date.today
  end
end
