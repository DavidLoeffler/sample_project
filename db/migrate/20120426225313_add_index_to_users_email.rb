class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
    add_index :users, :email, unique: trued
  end
end
