rescue Errno::ETIMEDOUT => e
    sleep 2
    puts "timeout: #{url}"
    retry
  rescue Errno::ECONNREFUSED => e
    sleep 30
    puts "refused: #{url}"
    retry