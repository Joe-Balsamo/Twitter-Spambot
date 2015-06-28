require 'jumpstart_auth'
require 'bitly'

class MicroBlogger
  attr_reader :client

  def initialize
    puts "Initializing MicroBlogger"
    @client = JumpstartAuth.twitter
  end

  def tweet(message)
  	if message.length > 140
  		puts "That tweet is too darned long!"
  		return
  	else
  		@client.update(message)
  		puts "This tweet should be successful!"
  	end
  end

  def dm(target, message)
    screen_name = @client.followers.collect { |follower| @client.user(follower).screen_name }
    if screen_name.include?target
      puts "Trying to send #{target} this direct message:"
      puts message
      message = "d @#{target} #{message}"
      tweet(message)
    else
      puts "You can only direct message people who follow you"
    end
  end

  def followers_list
    screen_names = []
    @client.followers.each do |follower|
      screen_names << @client.user(follower).screen_name
    end
    return screen_names
  end

  def everyones_last_tweet
    friends = @client.friends
    friends.each do |friend|
      puts @client.user(friend).screen_name
      puts @client.user(friend).status.text
      puts
    end
  end

  def spam_my_followers(message)
    followers_list.each do |follower|
      dm(follower, message)
    end
  end

  def shorten(original_url)
    puts "Shortening this URL: #{original_url}"
    # Shortening Code
    Bitly.use_api_version_3
    bitly = Bitly.new('hungryacademy', 'R_430e9f62250186d2612cca76eee2dbc6')
    return bitly.shorten(original_url).short_url
  end


  def run
  	puts "Welcome to the JSL Twitter Client!"
  	command = ""
  	while command != "q"
  		printf "enter command: "
      input = gets.chomp
      parts = input.split(" ")
      command = parts[0]
      case command
        when 'q' then puts "Goodbye!"
        when 't' then tweet(parts[1..-1].join(" "))
        when 'dm' then dm(parts[1], parts[2..-1].join(" "))
        when 'spam' then spam_my_followers(parts[1..-1].join(" "))
        when 'elt' then everyones_last_tweet
        when 's' then puts shorten(parts[1..-1].join(" "))
        else
          puts "Sorry, I don't know how to #{command}"
      end
  	end
  end	

end

blogger = MicroBlogger.new
blogger.run