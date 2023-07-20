module WithEncryptionConfig
  extend ActiveSupport::Concern

  class_methods do
    def kms_providers
      Mongoid.clients.dig(client_name, :options, :auto_encryption_options, :kms_providers)
    end

    def key_vault_namespace
      Mongoid.clients.dig(client_name, :options, :auto_encryption_options, :key_vault_namespace)
    end

    def client_encryption
      pp client_name
      @client_encryption ||= Mongo::ClientEncryption.new(
        Mongoid.client(:key_vault),
        key_vault_namespace: key_vault_namespace,
        kms_providers: kms_providers
      )
    end
  end
end
