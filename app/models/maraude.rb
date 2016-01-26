class Maraude < ActiveRecord::Base
  default_scope -> { order(date: :desc) }
  validates :date, 	presence: true
end
