class GroupController < ApplicationController
  before_filter :check_admin, except: :view

  def view
    @group = Group.first
  end

  def view_absenses
    @group = Group.first
    @discipline = Discipline.first
  end

  def get_updated_view_absenses
    required_params = [:discipline_id, :lesson_type]
    begin
      if params.has_key? :absenses_table and
         required_params.all? {|p| params[:absenses_table].has_key? p}
        discipline_id = params[:absenses_table][:discipline_id]
        lesson_type = params[:absenses_table][:lesson_type]

        group = Group.first
        students = group.students
        discipline = Discipline.find discipline_id
        absenses = get_absences_for_discipline_json discipline, lesson_type
        semester = get_semestral_discipline_lessons discipline, lesson_type

        render :json => {
          code: 200,
          response: {
            students: students.map{|s| {name: s.name, id: s.id}},
            discipline: discipline.name,
            absenses: absenses,
            semester: semester
          }
        }
      else
        render :json => {
          code: 400,
          response: {
            explaination: 'Bad request'
          }
        }
      end
    rescue e
      render :json => {
          code: 400,
          response: {
            explaination: e.message
          }
        }
    end
  end

  def update
    group = Group.first
    group.update(params.require(:group).permit(:semester, :cathedra,
      :faculty, :faculty_name, :cathedra_name, :index, :title))
    redirect_to action: :view
  end

  def create_absense
    needed = [:user_id, :lesson_id, :week]
    got = params.require(:absense)
    begin
      needed.each {|n| got.require n}
      absense = Absense.new (got.permit needed)
      absense.save

      render :json => {code: 200, response: get_absense_json(absense)}
    rescue Exception => e
      render :json => {code: 400, response: {explaination: e.message}}
    end
  end

  def delete_absense
    begin
      lesson = Lesson.find_by! ({
        time_index: params.require(:absense).require(:time_index),
        weekday: params.require(:absense).require(:weekday)
      })
      absense = Absense.find_by! ({
        week: params.require(:absense).require(:week),
        user_id: params.require(:absense).require(:user_id),
        lesson_id: lesson.id
      })
      buf = get_absense_json absense
      absense.delete
      render :json => {code: 200, response: buf}
    rescue Exception => e
      render :json => {
        code: 400,
        response: {
        explaination: e.message
      }}
    end
  end

  # *******************************************************************
  # Helping methods

  def get_absense_json absense
    {
      user_id: absense.user_id,
      lesson_id: absense.lesson_id,
      week: absense.week,
      reason_commentary: absense.reason_commentary
    }
  end

  def get_absences_for_discipline_json discipline, lesson_type = 0
    absenses = discipline.lessons.where(lesson_type: lesson_type).map do |l|
      l.absenses
    end.flatten
    absenses_by_student = {}
    absenses.each do |absense|
      absenses_by_student[absense.user.name] ||= {}
      absenses_by_student[absense.user.name][{
          week: absense.week,
          weekday: absense.lesson.weekday,
          time: absense.lesson.time_index
        }] = absense.reason_commentary
    end
    return absenses_by_student
  end

  def get_semestral_discipline_lessons discipline, lesson_type = 0
    semester = [].fill nil, 0, 17
    semester.map! {|v| []}
    discipline.lessons.where(lesson_type: lesson_type).order(:weekday, :time_index).each do |l|
      data = {time_index: l.time_index, weekday: l.weekday, lesson_id: l.id}
      case l.occurence_type
      when 0
        semester.each {|w| w.push data}
      else
        semester.select.with_index {|w,i| i%2==2-l.occurence_type}.each {|w| w.push data}
      end
    end
    return semester
  end
end
