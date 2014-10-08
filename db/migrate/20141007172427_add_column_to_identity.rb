class AddColumnToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :token, :string
    add_column :identities, :refresh_token, :string
    add_column :identities, :token_expiration, :integer
  end
end
