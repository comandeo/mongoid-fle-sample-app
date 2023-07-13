class BankAccount
  include Mongoid::Document
  include Mongoid::Timestamps

  encrypt_with key_name_field: :encryption_key_name

  field :name, type: String
  field :account_number, type: String, encrypt: { deterministic: false }
  field :account_type, type: String
  field :bank_name, type: String, encrypt: { deterministic: false }
  field :encryption_key_name, type: String

  validates_presence_of :name, :account_number, :account_type, :bank_name

  belongs_to :user
  embeds_many :transactions

  before_create :set_encryption_key

  private

  def set_encryption_key
    self.encryption_key_name = user.encryption_key_name
  end
end
