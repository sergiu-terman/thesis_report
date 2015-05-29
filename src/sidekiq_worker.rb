class MapReduceWorker
  include Sidekiq::Worker

  def perform(word, token)
    message = {channel: "/messages/#{token}", data: {message: "#{word} request was analyzed", type: "success"}}
    MongoHelper.new.frequency(word, token)
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end