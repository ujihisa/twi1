# An Experimental Twitter Clone with Rails

Let's make an experimental Twitter clone web app by Ruby on Rails version 3.

The minimum features of Twitter clone app are below:

* A visitor can sign up and get an account to become a user
* A user can post tweets
* A visitor and a user can see another user's one single tweet or a sequence of tweets
* A visitor and a user can see public timeline
* A user can follow another user
* A user can see "timeline" of the followings' tweets

I cut the following features for ease:

* A user can see "mentions"
* A user can leave (unfollow) others
* A user can send or receive direct messages

But I also would want to add the following internal feature which the real Twitter seems to be using:

* A timeline is not created just in time, but created when a user of the participants posted a tweet

This feature reduces the load time of reading a timeline.

## So what's the difference?

* It doesn't use any special software but just use Rails3
* It doesn't use a relational DB for storing tweets
* It is fast and scales (hopefully)

## The Product "twi1"

I named it "twi1" without thinking anything. That's here. <http://twi1.heroku.net/>

Note that currently it doesn't work because heroku doesn't support writing a file. I should look for another way if I use heroku.

The below screenshots are on my local server.

![User's timeline](http://gyazo.com/481d6caa9e0ce814d93acc76941eadc9.png)

![Public timeline](http://gyazo.com/6b1ace898ac7dac063339f06785b488d.png)

The public/user timeline is stored as the below.

    timeline([
    ,{user: 'ayden', text: 'test'}
    ,{user: 'ayden', text: 'adsfjklasdf'}
    ,{user: "ayden", text: "newest"}
    ,{user: "brian", text: "asdfasdfasd"}
    ,{user: "brian", text: "&lt;script&gt;test&lt;/script&gt;"}
    ,{user: "jjjjjj", text: "asdfads"}
    ,{user: "ujm", text: "Hello, world!"}
    ]);

When a user posted a tweet, the following code runs.

    # in model/tweet

    def add_a_tweet_on_timeline_to(username)
      add_a_tweet_on_the_file("#{RAILS_ROOT}/public/#{username}.js")
    end

    def add_a_tweet_on_the_file(file)
      File.open(file, 'r+') {|io|
        finale = "]);\n"
        io.seek(-finale.size, IO::SEEK_END)
        io.puts %|,{user: "#{@owner.username}", text: "#{@text}"}|
        io.write finale
      }
    end

That just removed the last line and add two lines.

To show the static timeline json file, I used the following short javascript codes.

    function timeline(xs) {
      var t = new Template("<p><b>#{user}</b>: #{text}</p>")
      $('timeline').innerHTML =
        xs.compact().map(function(x) {
          return t.evaluate(x);
        }).reverse().join("\n");
    }

and in the HTML view file,

    <script type='text/javascript'>
      Event.observe(window, 'load', function() {
        var username = '<%= @user.username %>';
        var url = '/' + username + '.js?' + (new Date()).valueOf();
        var script = document.createElement('script');
        script.setAttribute('src', url);
        document.getElementsByTagName('head')[0].appendChild(script); 
      });
    </script>

## Actually

The current `twi1` doesn't have the "follow" feature.

## References

* <http://stackoverflow.com/questions/2453104/mongomapper-rails3-edge-undefined-method-to-key-on-form-for>
* <http://stackoverflow.com/questions/2255176/getting-undefined-method-username-for-usersession-no-credentials-provided-w> (to run authlogin on heroku)
* <http://www.ibm.com/developerworks/library/wa-aj-jsonp1/> (for jsonp)
