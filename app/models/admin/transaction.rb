module Admin
  class Transaction
    include Mongoid::Document
    include Mongoid::Timestamps

    store_in client: :unencrypted, collection: :transactions

    field :amount, type: BSON::Binary
    field :description, type: BSON::Binary
    field :completed_at, type: Time
    field :encryption_key_name, type: String

    validates_presence_of :amount, :description, :completed_at
    belongs_to :bank_account, class_name: 'Admin::BankAccount'

    def amount
      self.class.client_encryption.decrypt(self[:amount])
    rescue Mongo::Error::CryptError
      self[:amount]
    end

    def description
      self.class.client_encryption.decrypt(self[:description])
    rescue Mongo::Error::CryptError
      self[:description]
    end

    def displayable_amount
      return 0 unless amount
      return amount if amount.is_a?(BSON::Binary)
      "#{amount / 100}.#{amount % 100}"
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