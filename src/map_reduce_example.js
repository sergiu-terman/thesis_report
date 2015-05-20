var map = function() {
  this.customers.forEach(function(customer) {
    emit(customer.id, this.data)
  });
};

var reduce = function(key, values) {
  return Array.sum(values)
}

db.posts.mapReduce(map, reduce, { out:"post_total" })