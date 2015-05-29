class MapReduceWorker
  include Sidekiq::Worker

  def perform(word, token)
    message = {channel: "/messages/#{token}", data: {message: "#{word} request was analyzed", type: "success"}}
    begin
      MongoHelper.new.frequency(word, token)
    rescue => e
      message[:data] = {message: "An error occurred while trying to analyze: #{word}", type: "danger"}
    end
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end