class User
  include Mongoid::Document

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  field :super_admin, :type => Boolean, :default => false

  belongs_to :location
  belongs_to :region

  def is_super_admin?
    super_admin
  end
end
