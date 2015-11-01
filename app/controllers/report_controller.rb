class ReportController < ApplicationController
  before_filter :check_admin

  def create
  end

  def form
    required = [:date]
    @report = params.require(:report).permit required
    required.each {|p| @report.require p}
    @group = Group.first

    render layout: 'empty'
  end
end
