class Rencontre < ActiveRecord::Base
  belongs_to :usager

  default_scope -> { order(date: :desc) }

  validates :usager_id, presence: true,
  						uniqueness: { scope: [:date, :type_renc] }
  validates :date, presence: true
  validates :type_renc, presence: true
  validates :ville, presence: true
end
