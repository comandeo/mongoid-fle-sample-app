class Transaction
  include Mongoid::Document
  include Mongoid::Timestamps

  field :amount, type: Integer, encrypt: { deterministic: false }
  field :description, type: String, encrypt: { deterministic: false }
  field :completed_at, type: Time

  validates_presence_of :amount, :description, :completed_at
  after_initialize :set_defaults

  embedded_in :bank_account

  private

  def set_defaults
    self[:completed_at] = Time.zone.now if completed_at.nil?
  end
end
