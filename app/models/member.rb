class Member < ActiveRecord::Base
  extend FriendlyId
  friendly_id :login_name, use: :slugged

  has_many :posts,   :foreign_key => 'author_id'
  has_many :gardens, :foreign_key => 'owner_id'

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login_name, :email, :password, :password_confirmation,
    :remember_me, :login, :tos_agreement
  # attr_accessible :title, :body

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  # Requires acceptance of the Terms of Service
  validates_acceptance_of :tos_agreement, :allow_nil => false,
    :accept => true

  # Give each new member a default garden
  after_create {|member| Garden.create(:name => "Garden", :owner_id => member.id) }

  # allow login via either login_name or email address
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(login_name) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def self.find_confirmed(params)
    find(params, :conditions => 'confirmed_at IS NOT NULL')
  end

  def self.confirmed
    where('confirmed_at IS NOT NULL')
  end

  def to_s
    return login_name
  end
end
