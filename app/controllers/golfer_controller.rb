class GolferController < ApplicationController
  # not sure what I had in mind for this controller
  # its for notices and articles and other stuff
  #   not owned by a group. more or less a global user
  def index
    @golfers = Golfer.all
  end

  def console
    redirect_to root_path, notice:"Thank you for something"
  end

  def relimit
    puts "my name is #{self.class}"
    @groups = Group.all
    @golfer = Golfer.first
    @golfer.reset_limited
  end
end
