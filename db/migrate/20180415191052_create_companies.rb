class CreateCompanies < ActiveRecord::Migration[5.1]
  def change
    create_table :companies do |t|
      t.string :token
      t.integer :feedbacks_count, default: 0
      t.timestamps
    end

    add_index :companies, :token, unique: true
  end
end
