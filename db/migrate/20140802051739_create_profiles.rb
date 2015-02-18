class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :last_name
      t.string :first_name
	  t.boolean :require_change_password, default:true
      t.references :user, index: true

      t.timestamps
    end
  end
end
