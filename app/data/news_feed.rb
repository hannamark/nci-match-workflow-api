
class NewsFeed
  attr_accessor :actor,
                :timestamp,
                :age,
                :message

  def initialize(actor, timestamp, age, message)
    @actor = actor
    @timestamp = timestamp
    @age = age
    @message = message
  end
end