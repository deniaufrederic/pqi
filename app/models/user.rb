class User < ActiveRecord::Base
  before_save { nom.upcase! }
  before_save { self.prenom = prenom.split(' ').map(&:capitalize).join(' ').split('-').map(&:capitalize).join('-') }
  
  default_scope -> { order(nom: :asc) }

  validates :nom, 			presence: true,
  							length: {maximum: 25}
  validates :prenom, 		presence: true,
							length: {maximum: 25}
  validates :identifiant, 	presence: true,
							length: {maximum: 25, minimum: 4},
							uniqueness: {case_sensitive: false}
  
  has_secure_password
  validates :password,		presence: true,
							length: {minimum: 6},
							allow_nil: true
  class << self						
	# Returns the hash digest of the given string.
    def digest(string)
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                    BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end
  end
end