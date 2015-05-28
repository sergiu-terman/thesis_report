var map = function() {
    var word = "example";
    if (this.normalized == word) {
        emit({year: this.year, month: this.month, source: this.source}, this.parsed_page_id);
    }
};

var reduce = function(key, values) {
 var dummy = {};
 var size = 0;
 for (var i = 0; i < values.length; i++) {
    if (!dummy.hasOwnProperty(values[i])) {
        dummy[values[i]] = 1;
        size++;
    }
 }
 return size;
};