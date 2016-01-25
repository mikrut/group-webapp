# encoding=utf-8
class GroupController < ApplicationController
  before_action :check_admin, except: :view

  # Получение информации о группе
  def view
    @group = Group.first
    @disciplines = Discipline.select("disciplines.*,\
      (select count(materials.id) from materials\
       where materials.discipline_id = disciplines.id) materials_count,\
      (select count(articles.id) from articles\
       where articles.discipline_id = disciplines.id) articles_count")
  end

  # Статистика пропусков
  def view_absenses
    @group = Group.first
    @discipline = Discipline.first
  end

  def get_updated_view_absenses
    required_params = [:discipline_id, :lesson_type]
    begin
      if params.key?(:absenses_table) &&
         required_params.all? { |p| params[:absenses_table].key? p }
        discipline_id = params[:absenses_table][:discipline_id]
        lesson_type = params[:absenses_table][:lesson_type]

        group = Group.first
        students = group.students
        discipline = Discipline.find discipline_id
        absenses = Absense.find_by_sql [
          "SELECT absenses.id AS id, absenses.user_id AS user_id,\
           absenses.lesson_id AS lesson_id, absenses.week AS week,\
           absenses.reason_commentary AS commentary, lessons.weekday AS weekday,\
           lessons.time_index AS time_index FROM lessons LEFT JOIN absenses
           ON lessons.id = absenses.lesson_id\
           WHERE lessons.discipline_id = ? AND lessons.lesson_type = ?",
          discipline.id, lesson_type]
        semester = get_semestral_discipline_lessons discipline, lesson_type
        progresses = Progress.find_by_sql ["SELECT user_id, percentage FROM progresses
          WHERE discipline_id = ?", discipline.id]

        render json: {
          code: 200,
          response: {
            students: students.map { |s| { name: s.name, id: s.id } },
            discipline: discipline.name,
            discipline_id: discipline.id,
            progresses: progresses,
            absenses: absenses,
            semester: semester
          }
        }
      else
        render json: {
          code: 400,
          response: {
            explaination: 'Bad request'
          }
        }
      end
    rescue StandardError => e
      render json: {
        code: 400,
        response: {
          explaination: e.message
        }
      }
    end
  end

  # Обновление информации о группе
  def do_update
    group = Group.first
    group.update(params.require(:group).permit(:semester, :cathedra,
                                               :faculty, :faculty_name, :cathedra_name, :index, :title,
                                               :supervisor, :decanus, :zamdecanus))
    redirect_to action: :view
  end

  # Показ страницы редактирования
  def view_update
    @group = Group.first
    render 'update'
  end

  # Добавление пропуска
  def create_absense
    needed = [:user_id, :lesson_id, :week]
    begin
      got = params.require(:absense)
      needed.each { |n| got.require n }
      absense = Absense.new(got.permit needed)
      absense.save

      render json: { code: 200, response: get_absense_json(absense) }
    rescue StandardError => e
      render json: { code: 400, response: { explaination: e.message } }
    end
  end

  # Удаление пропуска
  def delete_absense
    lesson = Lesson.find_by!(time_index: params.require(:absense).require(:time_index),
                             weekday: params.require(:absense).require(:weekday))
    absense = Absense.find_by!(week: params.require(:absense).require(:week),
                               user_id: params.require(:absense).require(:user_id),
                               lesson_id: lesson.id)
    buf = get_absense_json absense
    absense.delete
    render json: { code: 200, response: buf }
  rescue StandardError => e
    render json: {
      code: 400,
      response: {
        explaination: e.message
      } }
  end

  # Обновление процента успеваемости по дисциплине
  def update_percentage
    needed = [:user_id, :discipline_id, :percentage]
    begin
      got = params.require(:progress)
      needed.each { |n| got.require n }

      user_progress = Progress.find_or_create_by(user_id: got[:user_id],
                                                 discipline_id: got[:discipline_id])

      user_progress.percentage = got[:percentage]
      user_progress.save

      render json: {
        code: 200,
        response: {
          explaination: 'OK'
        }
      }
    rescue StandardError => e
      render json: {
        code: 400,
        response: {
          explaination: e.message
        } }
    end
  end

  # *******************************************************************
  # Helping methods

  def get_absense_json(absense)
    {
      user_id: absense.user_id,
      lesson_id: absense.lesson_id,
      week: absense.week,
      reason_commentary: absense.reason_commentary
    }
  end

  def get_absences_for_discipline_json(discipline, lesson_type = 0)
    absenses = discipline.lessons.where(lesson_type: lesson_type)
               .map(&:absenses).flatten
    absenses_by_student = {}
    absenses.each do |absense|
      absenses_by_student[absense.user.name] ||= {}
      absenses_by_student[absense.user.name][{
        week: absense.week,
        weekday: absense.lesson.weekday,
        time: absense.lesson.time_index
      }] = absense.reason_commentary
    end
    absenses_by_student
  end

  def get_semestral_discipline_lessons(discipline, lesson_type = 0)
    semester = [].fill nil, 0, 17
    semester.map! { |_v| [] }
    discipline.lessons.where(lesson_type: lesson_type)
      .order(:weekday, :time_index).each do |l|
      data = { time_index: l.time_index, weekday: l.weekday,
               lesson_id: l.id }
      case l.occurence_type
      when 0
        semester.each { |w| w.push data }
      else
        semester.select.with_index do |_w, i|
          i % 2 == 2 - l.occurence_type
        end.each { |w| w.push data }
      end
    end
    semester
  end
end
