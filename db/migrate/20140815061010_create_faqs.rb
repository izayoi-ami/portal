class CreateFaqs < ActiveRecord::Migration
  def change
    create_table :faqs do |t|
      t.string :title, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
