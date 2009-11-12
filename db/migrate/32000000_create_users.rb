class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      
      # Custom columns:
      #
      t.string :name
      t.boolean :active, :default => false

      # Authlogic authentication
      #
      t.string :login
      t.string :email
      t.string :crypted_password
      t.string :password_salt
      t.string :persistence_token

      # We support e-mail activation and password reset, so we need this
      #
      t.string :perishable_token

      # Authlogic Magic Columns
      #
      t.datetime :last_login_at
      t.datetime :current_login_at

      # Other Magic Columns (not included by default, uncomment them or copy them to a new migration to include)
      #
      #t.integer   :login_count,         :null => false, :default => 0
      #t.integer   :failed_login_count,  :null => false, :default => 0
      #t.datetime  :last_request_at
      #t.string    :current_login_ip
      #t.string    :last_login_ip

      # Plain old Rails timestamps
      #
      t.timestamps

    end

    # Index login for fast user lookups
    #
    add_index :users, :login, :unique => true
    add_index :users, :perishable_token, :unique => true
  end

  def self.down
    drop_table :users
  end
end
