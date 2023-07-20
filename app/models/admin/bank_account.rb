module Admin
  class BankAccount
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in client: :unencrypted, collection: :bank_accounts

    field :name, type: String
    field :account_number, type: BSON::Binary
    field :account_type, type: String
    field :bank_name, type: BSON::Binary
    field :encryption_key_name, type: String

    validates_presence_of :name, :account_number, :account_type, :bank_name

    has_many :transactions, class_name: 'Admin::Transaction'

    def account_number
      self.class.client_encryption.decrypt(self[:account_number])
    rescue Mongo::Error::CryptError
      self[:account_number]
    end

    def bank_name
      self.class.client_encryption.decrypt(self[:bank_name])
    rescue Mongo::Error::CryptError
      self[:bank_name]
    end

    def self.client_encryption
      @client_encryption ||= Mongo::ClientEncryption.new(
        Mongoid.client(:key_vault),
        key_vault_namespace: User.key_vault_namespace,
        kms_providers: User.kms_providers
      )
    end
  end
end
