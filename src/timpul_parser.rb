def parse(text, id)
  doc = Nokogiri::HTML(text, nil, 'UTF-8')
  unless doc.css('.content').size > 0
    puts "Timpul: id #{id} \- no content"
    return
  end
  title = doc.title.split(" | ").first.strip rescue doc.title
  timestring = doc.css('.box.artGallery').css('.data_author').text.split("\n").map(&:strip)[2]
  content = doc.css('.changeFont').text.gsub("\n", '').gsub("\t",'').strip
  unless content.size > 0
    puts "Timpul: id #{id} - empty content"
    return
  end
  {
    source:         "timpul",
    title:          title,
    datetime:       parse_timestring(timestring),
    content:        content,
    article_id:     id.to_i,
    url:            build_url(id)
  }
end