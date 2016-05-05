json.array!(@messages) do |message|
  json.extract! message, :id, :sender_id, :recepient_id, :subject, :text, :deleted, :read
  json.url message_url(message, format: :json)
end
