class GolferController < ApplicationController
  # not sure what I had in mind for this controller
  # its for notices and articles and other stuff
  #   not owned by a group. more or less a global user
  def index
    @golfer = Golfer.new(id:1)

    redirect_to root_path, notice:"Got a golfer #{@golfer.inspect}"
  end
end