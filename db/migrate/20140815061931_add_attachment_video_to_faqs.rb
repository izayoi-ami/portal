class AddAttachmentVideoToFaqs < ActiveRecord::Migration
  def self.up
    change_table :faqs do |t|
      t.attachment :video
    end
  end

  def self.down
    remove_attachment :faqs, :video
  end
end
