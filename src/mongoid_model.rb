class ParsedPage
  include Mongoid::Document
  store_in collection: "parsed_pages"
  has_many :words
  field :source,          type: String
  field :title,           type: String
  field :original_time,   type: String
  field :datetime,        type: Time
  field :views,           type: Integer
  field :content,         type: String
  field :article_id,      type: Integer
  field :url,             type: Strings
  index({ datetime: 1 }, {name: "datetime_index"})
end
