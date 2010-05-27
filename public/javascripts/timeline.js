function timeline(xs) {
  var t = new Template("<p><b>#{user}</b>: #{text}</p>")
  $('timeline').innerHTML =
    xs.compact().map(function(x) {
      return t.evaluate(x);
    }).reverse().join("\n");
}
