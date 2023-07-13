class User
  include Mongoid::Document
  include Mongoid::Timestamps

  encrypt_with key_id: 'Jh1QMz6fSfiuloRMANZlhg=='

  field :first_name, type: String, encrypt: { deterministic: false }
  field :last_name, type: String, encrypt: { deterministic: false }
  field :email, type: String, encrypt: { deterministic: true }
  field :encryption_key_name, type: String

  validates_presence_of :email, :first_name, :last_name
  index({ email: 1 }, { unique: true })

  has_many :bank_accounts

  before_create :generate_data_key

  private

  def generate_data_key
    generate_encryption_key_name
    key_vault_client = Mongoid.client(User.client_name).encrypter.key_vault_client
    key_vault_namespace = Mongoid.client(User.client_name).options.dig(:auto_encryption_options, :key_vault_namespace)
    kms_providers = Mongoid.client(User.client_name).options.dig(:auto_encryption_options, :kms_providers)
    client_encryption = Mongo::ClientEncryption.new(
      key_vault_client,
      key_vault_namespace:,
      kms_providers:
    )
    client_encryption.create_data_key(kms_providers.keys.first, key_alt_names: [encryption_key_name])
  end

  def generate_encryption_key_name
    self.encryption_key_name = Digest::SHA256.hexdigest(email)
  end
end
