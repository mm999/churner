class User < ActiveRecord::Base
  has_many :cards
  enum role: [:user, :vip, :admin]
  after_initialize :set_defaults, :if => :new_record?
  after_create :create_braintree_user, unless: Proc.new { |user| user.admin? }
  after_create :sign_up_for_mailing_list

  def set_defaults
    self.role ||= :user
    self.customer_id = "abc123"
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def create_braintree_user
    customer = Braintree::Customer.create(:email => self.email)
    self.update(customer_id: customer.customer.id)
  end

  def sign_up_for_mailing_list
    MailingListSignupJob.perform_later(self)
  end

  def subscribe
    mailchimp = Gibbon::API.new(Rails.application.secrets.mailchimp_api_key)
    result = mailchimp.lists.subscribe({
      :id => Rails.application.secrets.mailchimp_list_id,
      :email => {:email => self.email},
      :double_optin => false,
      :update_existing => true,
      :send_welcome => true
    })
    Rails.logger.info("Subscribed #{self.email} to MailChimp") if result
  end

end
