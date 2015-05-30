var map = function() {
  var key = {year: this.year, month: this.month, source: this.source, word: this.normalized};
  emit(key, this.article_id);
};
var reduce = function(key, values) {
 var dummy = {}, size = 0;
 for (var i = 0; i < values.length; i++) {
    if (!dummy.hasOwnProperty(values[i])) {
        dummy[values[i]] = 1; size++;
    }
 }
 return size;
};

db.word.mapReduce(map,
    reduce,
    {
      out: "tmp_collection" 
    });
db.tmp_collection.find({}).forEach(function(d) {
    var result = {year: this.year, month: this.month, source: this.source, word: this.word, mentions: d.value};
    db.frequency_ready.insert(result);
});
db.tmp_collection.drop()
