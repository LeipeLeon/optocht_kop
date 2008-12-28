require 'rubygems'
require 'nailer'

desc "Make thumbnails of location" 
task :thumbs => :environment do 
  # TODO: eerst ff kijken wanneer de laatste update is geweest
  
  # Haal nieuw plaatje op
  url = 'http://webserver.vda-groep.nl/locations/just_map.html'
  t = Nailer.new(url, 320, 350)

  if t.ok?
    t.wait_until_ready
    # t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/small.jpg", :small)
    # t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/medium.jpg", :medium)
    t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/medium2.jpg", :medium2)
    # t.retrieve_to_file("#{RAILS_ROOT}/public/thumb/large.jpg", :large)
    puts "Thumbnails saved #{RAILS_ROOT}/public/thumb/medium2.jpg"
  else
    puts "Error"
  end    
end
