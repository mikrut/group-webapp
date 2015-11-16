class ReportController < ApplicationController
  before_filter :check_admin

  def create
  end

  def form
    required = [:date]
    @report = params.require(:report).permit required
    required.each {|p| @report.require p}
    @group = Group.first
    @students = ActiveRecord::Base.connection.select_all(
      "SELECT users.name AS name, COALESCE(abs.num, 0) AS absense_num, \
       COALESCE(progresses.percentage,0) AS percentage FROM users LEFT JOIN (\
         SELECT user_id, COUNT(*) AS num FROM absenses GROUP BY user_id\
       ) AS abs ON users.id=abs.user_id LEFT JOIN progresses ON\
       users.id = progresses.user_id ORDER BY name")
    less_number = Lesson.less_in_sem
    @students.each do |student|
      if less_number != 0
        student['absense_perc'] = student['absense_num'] / less_number
      else
        student['absense_perc'] = 0
      end
    end
    @students_num = @group.students.count

    render layout: 'empty'
  end
end
