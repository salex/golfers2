class CoursesController < ApplicationController
  def show
    @group = current_group
    @group.parse_courses
  end

  def edit
    @group = current_group
    @group.parse_courses

  end

  def update
    @group = current_group
    courses = params["course"]
    size = courses['name'].size
    course = ""
    0.upto(size-1) do |i|
      next if courses['name'][i].blank?
      str = "#{courses['name'][i]}::"
      str += "par_in=#{courses['par_in'][i]}:"
      str += "par_out=#{courses['par_out'][i]}:"
      str += "tees=#{courses['tees'][i]},"
      course += str
    end
    @group.courses = course
    @group.save
    redirect_to course_path, notice:"Group Courses has been updated"
    # puts "ARR #{arr} "
  end
end
