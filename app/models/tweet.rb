class Tweet
  def initialize(owner, text)
    @owner = owner
    @text = CGI.escapeHTML(text.to_s)
  end

  def save
    # FIXME: asynchronize each processes
    ([@owner] + @owner.followers).each do |u|
      add_a_tweet_on_timeline_to(u.username)
    end
    add_a_tweet_on_public_timeline()
  end

  def add_a_tweet_on_timeline_to(username)
    add_a_tweet_on_the_file("#{RAILS_ROOT}/public/#{username}.js")
  end

  def add_a_tweet_on_public_timeline()
    add_a_tweet_on_the_file("#{RAILS_ROOT}/public/_.js")
  end

  def add_a_tweet_on_the_file(file)
    File.open(file, 'r+') {|io|
      finale = "]);\n"
      io.seek(-finale.size, IO::SEEK_END)
      io.puts %|,{user: "#{@owner.username}", text: "#{@text}"}|
      io.write finale
    }
  end
end
