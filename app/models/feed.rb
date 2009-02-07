class Feed < ActiveRecord::Base
  twitterify :url, :title
end
