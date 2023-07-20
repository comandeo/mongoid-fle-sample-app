class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  encrypt_with key_name_field: :encryption_key_name

  field :amount, type: Integer, encrypt: { deterministic: false }
  field :description, type: String, encrypt: { deterministic: false }
  field :completed_at, type: Time
  field :encryption_key_name, type: String

  validates_presence_of :amount, :description, :completed_at
  after_initialize :set_defaults
  before_create :set_encryption_key

  belongs_to :bank_account

  def displayable_amount
    "#{amount / 100}.#{amount % 100}"
  end

  private

  def set_defaults
    self[:completed_at] = Time.zone.now if completed_at.nil?
  end

  def set_encryption_key
    self.encryption_key_name = bank_account.encryption_key_name
  end
end
