module ScheduleHelper
  include DisciplineHelper

  def lesson_type_selector(form, default_type = 0)
    lesson_types = Lesson::LESSON_TYPES.map.with_index { |t, i| [t, i] }
    form.select :lesson_type,
                options_for_select(lesson_types, default_type),
                {},
                id: nil
  end

  def update_form_for_row(row, index, weekday_index, time_index,
                          occurence_type = Lesson.occurence_types[:weekly],
                          lesson_type = Lesson.lesson_types[:lecture])

    discipline_id = 0
    if row.class == Array && !row[index].nil?
      discipline_id = row[index].discipline_id
    elsif row.class == Lesson
      discipline_id = row.discipline_id if row.class == Lesson
    end

    form_for :lesson, url: { action: :update_item }, method: 'POST',
                      html: { autocomplete: 'off', id: nil } do |form|
      discipline_id ||= disciplines[0][1]
      discipline_selector(form, discipline_id).concat(
        lesson_type_selector form, lesson_type
      ).concat(
        form.hidden_field :weekday,
                          value: weekday_index,
                          id: nil
      ).concat(
        form.hidden_field :time_index,
                          value: time_index,
                          id: nil
      ).concat(
        form.hidden_field :occurence_type,
                          value: occurence_type,
                          id: nil
      ).concat(form.submit 'Update item', id: nil)
    end
  end

  def display_small(model)
    case model
    when Article
      render partial: 'article/small', locals: { article: model }
    when Material
      render partial: 'materials/small', locals: { material: model }
    else
      ''
    end
  end

  def display_lesson_for_row(row, row_index = 0)
    lesson = nil
    case row
    when Array
      lesson = row[row_index] unless row[row_index].nil?
    when Lesson
      lesson = row
    end
    render partial: 'timetable_lesson', locals: { lesson: lesson } unless lesson.nil?
  end
end
