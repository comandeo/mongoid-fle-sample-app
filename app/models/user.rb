# frozen_string_literal: true
class User
  include Mongoid::Document
  include Mongoid::Timestamps

  encrypt_with key_id: 'Wjyh4r2eT9OW5pjbwDm5rw=='

  field :first_name, type: String, encrypt: { deterministic: false }
  field :last_name, type: String, encrypt: { deterministic: false }
  field :email, type: String, encrypt: { deterministic: true }
  field :encryption_key_name, type: String

  validates_presence_of :email, :first_name, :last_name
  index({ email: 1 }, { unique: true })

  has_many :bank_accounts, dependent: :destroy

  before_create :generate_data_key

  def self.current_user
    User.first
  end

  private

  def generate_data_key
    generate_encryption_key_name
    key_vault_client = Mongoid.client('key_vault')
    auto_encryption_options = Mongoid.clients.dig(self.class.client_name, :options, :auto_encryption_options)
    key_vault_namespace = auto_encryption_options[:key_vault_namespace]
    kms_providers = auto_encryption_options[:kms_providers]
    client_encryption = Mongo::ClientEncryption.new(key_vault_client, key_vault_namespace:, kms_providers:)
    client_encryption.create_data_key(kms_providers.keys.first, key_alt_names: [encryption_key_name])
  end

  def generate_encryption_key_name
    self.encryption_key_name = Digest::SHA256.hexdigest(email)
  end
end
