# Comatose Configuration File
# http://comatose.rubyforge.org/
Comatose.configure do |config|
  # Sets the text in the Admin UI's title area
  config.admin_title = "Site Content"
  config.admin_sub_title = "Content for the rest of us..."
  config.default_tree_level = 5

  # config.admin_includes       = []
  # config.admin_helpers        = []
  # config.content_type         = 'utf-8'
  # config.default_filter       = 'Textile'
  # config.default_processor    = :liquid
  # config.disable_caching      = false
  # config.hidden_meta_fields   = []
  # config.helpers              = []
  # config.includes             = []
  # 
  # # These are 'blockable' settings
  # config.authorization        = Proc.new { true }
  # config.admin_authorization  = Proc.new { true }
  # config.admin_get_author     = Proc.new { request.env['REMOTE_ADDR'] }
  # config.admin_get_root_page  = Proc.new { Comatose::Page.root }
  # config.after_setup          = Proc.new { true }
end

# TODO: Een betere metode hiervoor verzinnen!
Comatose.define_drop 'news' do
  def latest_headlines
    # Location.find(:all, :conditions=>['created_on > ?', 2.weeks.ago]).collect {|n| n.title }
    Feed.find(:all, :limit => 5).collect {|n| "<a href=\"/feeds/#{n.id}\">#{n.title}</a>" }
  end
end
