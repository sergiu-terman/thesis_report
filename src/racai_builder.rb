  def tokenize
    @input = client_call(:tokenizer)
    self
  end

  def tag
    @input = client_call(:tagger)
    self
  end

  def client
    @@client ||= Savon.client(read_timeout: 3600, open_timeout: 3600) do
      wsdl "http://ws.racai.ro/ttlws.wsdl"
    end
  end

  def client_call(action, lang="ro")
    message = { input: @input }
    unless lang.nil?
      message = Hash[:lang, "ro"].merge!(message)
    end
    extract_response(client.call(action, message: message), action)
  end