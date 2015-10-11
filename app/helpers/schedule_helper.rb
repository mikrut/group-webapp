module ScheduleHelper
  def update_form_for_row(row, index, weekday_index, pair_index,
    occurence_type = Lesson.occurence_types[:weekly],
    lesson_type = Lesson.lesson_types[:lecture])

    discipline_id = nil
    if row.class == Array
      discipline_id = row[index].discipline_id
    else
      discipline_id = row.discipline_id if row.class == Lesson
    end

    disciplines = Discipline.all.map{|d| [d.name, d.id]}.insert(0, ["None", nil])
    lesson_types = Lesson::LESSON_TYPES.map.with_index {|t,i| [t, i]}

    form_for :lesson, url: {action: :updateItem}, method: 'POST',
      html: {autocomplete: 'off'} do |form|
      discipline_id ||= disciplines[0][1]
      form.select(
        :discipline_id, options_for_select(disciplines, discipline_id)
      ).concat(
        form.select :lesson_type, options_for_select(lesson_types, lesson_type)
      ).concat(
      form.hidden_field :weekday, value: weekday_index
      ).concat(
      form.hidden_field :time_index, value: pair_index
      ).concat(
      form.hidden_field :occurence_type, value: occurence_type
      ).concat(
      form.submit "Update item"
      )
    end
  end
end
