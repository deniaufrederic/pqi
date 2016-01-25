class Maraude < ActiveRecord::Base
  default_scope -> { order(date: :desc) }
  validates :date, 	presence: true,
  					uniqueness: true
end
