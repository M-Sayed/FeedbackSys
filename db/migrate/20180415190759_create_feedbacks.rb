class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.text :content
      t.integer :number
      t.string :company_token
      t.integer :priority, default: 0

      t.timestamps
    end

    add_index :feedbacks, :company_token
    add_index :feedbacks, :number
  end
end
