class GolferController < ApplicationController
  # not sure what I had in mind for this controller
  # its for notices and articles and other stuff
  #   not owned by a group. more or less a global user
  def index
    @golfers = Golfer.all

  end

  def console
    shit = crap
  end
  
end