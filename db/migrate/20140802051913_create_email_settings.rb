class CreateEmailSettings < ActiveRecord::Migration
  def change
    create_table :email_settings do |t|
      t.boolean :is_forward, default:false
      t.boolean :is_vacation, default:false
      t.text :message
      t.references :user, index: true

      t.timestamps
    end
  end
end
