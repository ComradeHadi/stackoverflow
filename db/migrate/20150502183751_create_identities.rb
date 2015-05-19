class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.references :user, index: true, foreign_key: true
      t.string :provider
      t.string :uid
      t.string :confirmation_token
      t.string :email

      t.timestamps null: false
    end

    add_index :identities, [:provider, :uid]
    add_index :identities, :confirmation_token, unique: true
  end
end
