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
    cant_do_that unless is_manager?
    @groups = Group.all
    @golfer = Golfer.first
  end
end
