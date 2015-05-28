class PublikaFetcher
  PAGES_DIR = "data/pages/publika/"
  FEED_URL  = "http://rss.publika.md/stiri.xml"

  def setup
    FileUtils.mkdir_p PAGES_DIR
  end

  def most_recent_id
    return @most_recent_id if @most_recent_id
    doc = Nokogiri::XML(RestClient.get(FEED_URL))
    @most_recent_id = doc.css("link")[2]
                         .text.scan(/_([\d]+)\.html/).first.first.to_i / 10
  end

  def latest_stored_id
    Dir["#{PAGES_DIR}*"].map{ |f| f.split('.').first.gsub(PAGES_DIR, "") }
                        .map(&:to_i).sort.last || 0
  end

  def link(id)
    "http://publika.md/#{id}1"
  end

  def valid?(page)
    page.include?("publicat in data de")
  end

  def save(page, id)
    return unless valid? page
    Zlib::GzipWriter.open(PAGES_DIR + id.to_s + ".html.gz") do |gz|
      gz.write page
    end
  end

  def fetch_single(id)
    page = SmartFetcher.fetch(link(id))
    save(page, id) if page
  end

  def progressbar
    @progressbar ||= ProgressBar.new(most_recent_id - latest_stored_id, :bar, :counter, :rate, :eta)
  end

  def run
    setup
    puts "Fetching Publika. Most recent: #{most_recent_id}. Last fetched: #{latest_stored_id}."
    if latest_stored_id == most_recent_id
      puts "Nothing to fetch for Publika"
      return
    end
    latest_stored_id.upto(most_recent_id) do |id|
      fetch_single(id)
      progressbar.increment!
    end
  end
end