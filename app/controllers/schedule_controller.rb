class ScheduleController < ApplicationController
  before_action :check_admin, only: [:update, :updateItem]

  def read
    @lessons = getLessonsArray
  end

  def update
    @lessons = getLessonsArray
  end

  def updateItem
    required_params = [:discipline_id, :weekday, :occurence_type, :time_index, :lesson_type]
    if params.has_key? :lesson and required_params.all? {|param| params[:lesson].has_key? param} then
      data = params[:lesson]
      Lesson.destroy_all ["weekday = ? AND time_index = ? and occurence_type in (?)", data[:weekday], data[:time_index], [data[:occurence_type], Lesson.occurence_types[:weekly]]]

      lesson = Lesson.new(params.require(:lesson).permit(required_params))
      lesson.group = Group.first
      lesson.save

      render :json => {:code => 200, :response => {
        :discipline_id => lesson.discipline_id,
        :weekday => lesson.weekday,
        :occurence_type => lesson.occurence_type,
        :time_index => lesson.time_index,
        :lesson_type => lesson.lesson_type
      }}
    else
      render :json => {:code => 400, :response => {
        explaination: "Bad request",
        received_data: (params[:lesson] || {})
        }}
    end
  end

  private

  def getLessonsArray
    array = [].fill nil, 0, Lesson::WEEKDAY_NAMES.length - 1
    array.map! {|e| [].fill nil, 0, Lesson::TIMES.length}
    Lesson.all.each do |l|
      if l.occurence_type == Lesson.occurence_types[:weekly]
        array[l.weekday][l.time_index] = l
      else
        if array[l.weekday][l.time_index].nil?
          array[l.weekday][l.time_index] = [].fill nil, 0, 2
        end
        array[l.weekday][l.time_index][l.occurence_type-1] = l
      end
    end
    array
  end
end
