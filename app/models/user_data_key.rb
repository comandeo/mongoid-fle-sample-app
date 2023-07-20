class UserDataKey

  attr_accessor :key_id, :key_alt_names, :user_email

  def initialize(user, data_key)
    @user = user
    @data_key = data_key
    @user_email = @user.email
    @key_id = @data_key[:_id]
    @key_alt_names = @data_key.fetch(:keyAltNames) { [] }
  end

  def to_param
    @key_id.to_uuid
  end

  def self.create(user)
    data_key = User.client_encryption.get_key_by_alt_name(user.encryption_key_name)
    return nil unless data_key

    UserDataKey.new(user, data_key)
  end
end
