class TwitterController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.mobile # index.mobile.erb
    end
  end
end