class User < ApplicationRecord

	validates :full_name, :email, :presence => true
	validates_uniqueness_of :email
	validate :password_validator, :email_validator
	before_create :password_validator, :email_validator

	has_secure_password

	def password_validator
	    unless self.password.length >= 6
	      errors.add(:password, "is too short")
	    end
	end

	def email_validator
	   unless self.email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
	     errors.add(:email, "is not valid")
	   end
	end

	def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_initialize.tap do |user|
	    user.provider = auth.provider
	    user.uid = auth.uid
	    user.full_name = auth.info.name unless user.full_name != nil
	    user.email =  SecureRandom.hex + '@example.com' unless user.email = nil
	    user.password = SecureRandom.urlsafe_base64 unless user.password != nil
	    user.save!
	  end
	end

	# def add_provider(auth_hash)
	#   # Check if the provider already exists, so we don't add it twice
	#   unless authorizations.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"])
	#     Authorization.create :user => self, :provider => auth_hash["provider"], :uid => auth_hash["uid"]
	#   end
	# end

end
