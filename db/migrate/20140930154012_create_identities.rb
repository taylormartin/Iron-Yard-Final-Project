class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.integer    :user_id
      t.string     :provider
      t.string     :uid
      t.text       :auth_data
      t.datetime   :created_at
      t.datetime   :updated_at
      t.timestamps
    end
  end
end
