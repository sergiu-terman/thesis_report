post '/search' do
  token = SecureRandom.urlsafe_base64(nil, false)
  MapReduceWorker.perform_async(params[:words], token)
  token
end

get '/queries' do
  @queries = MongoHelper.new.get_executed_queries
  haml :queries
end

get '/queries/:token' do
  response = MongoHelper.new.get_frequency(params[:token])
  unless response.any?
    @no_result = true
  else
    @no_result = false
    @word = response.first["word"]
    @result = prepare_data(response)
  end
  haml :plot
end