class Feed < ActiveRecord::Base
  twitterify :url, :title
  
  def self.last(count = 5)
    Feed.find(:all, :limit => count, :sort => "created_at DESC")
  end
end
