# frozen_string_literal: true
class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  ## Database authenticatable
  field :email, type: String, encrypt: { deterministic: true }
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token, type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  include Mongoid::Timestamps

  encrypt_with key_id: 'ZVCeA+EBSe2VB1HdopLQmg=='

  field :first_name, type: String, encrypt: { deterministic: false }
  field :last_name, type: String, encrypt: { deterministic: false }

  field :encryption_key_name, type: String

  validates_presence_of :email, :first_name, :last_name
  index({ email: 1 }, { unique: true })

  has_many :bank_accounts, dependent: :destroy

  before_create :generate_data_key

  after_destroy :delete_data_key

  def self.current_user
    User.first
  end

  def self.kms_providers
    Mongoid.clients.dig(client_name, :options, :auto_encryption_options, :kms_providers)
  end

  def self.key_vault_namespace
    Mongoid.clients.dig(client_name, :options, :auto_encryption_options, :key_vault_namespace)
  end

  def self.client_encryption
    @client_encryption ||= begin
      key_vault_client = Mongoid.client('key_vault')
      Mongo::ClientEncryption.new(key_vault_client, key_vault_namespace:, kms_providers:)
    end
  end

  private

  def generate_data_key
    generate_encryption_key_name
    self.class.client_encryption.create_data_key(self.class.kms_providers.keys.first, key_alt_names: [encryption_key_name])
  end

  def generate_encryption_key_name
    self.encryption_key_name = Digest::SHA256.hexdigest(email)
  end

  def delete_data_key
    data_key = self.class.client_encryption.get_key_by_alt_name(encryption_key_name)
    return unless data_key

    self.class.client_encryption.delete_key(data_key[:_id])
  end

end
