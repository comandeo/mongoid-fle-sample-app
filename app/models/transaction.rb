class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, type: Integer, encrypt: { deterministic: false }
  field :description, type: String, encrypt: { deterministic: false }
  field :completed_at, type: Time
  field :key_name_field, type: String

  validates_presence_of :amount, :description, :completed_at

  belongs_to :bank_account
end
