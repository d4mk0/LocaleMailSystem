class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sent_messages, -> { where(message_type: 'sent') }, foreign_key: :sender_id, class_name: 'Message'
  has_many :received_messages, -> { where(message_type: 'received') }, foreign_key: :recepient_id, class_name: 'Message'
  # has_many :trashed_messages, foreign_key: :recepient_id, class_name: 'Message'

  def trashed_messages
    Message.where(id: sent_messages.deleted.pluck(:id) + received_messages.deleted.pluck(:id))
  end

end
