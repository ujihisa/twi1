class User < ActiveRecord::Base
  acts_as_authentic

  after_create do
    File.open("#{RAILS_ROOT}/public/#{self.username}.js", 'w') {|io|
      io.puts 'timeline(['
      io.puts ']);'
    }
  end

  def followers
    # FIXME
    []
  end
end
