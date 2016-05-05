class Message < ActiveRecord::Base
  belongs_to :sender, class_name: 'User'
  belongs_to :recepient, class_name: 'User'

  validates_presence_of :subject, :text, :sender_id, :recepient_id

  scope :deleted, -> { where(deleted: true) }
  scope :undeleted, -> { where(deleted: false) }
  scope :read, -> { where(read: true) }
  scope :unread, -> { where(read: false) }
  scope :by_time, -> { order(created_at: :desc) }
end
