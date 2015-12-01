module DisciplineHelper
  def discipline_selector(form, default_discipline = 0)
    disciplines = Discipline.all.map { |d| [d.name, d.id] }.insert(0, ['None', nil])
    form.select :discipline_id,
                options_for_select(disciplines, default_discipline),
                {},
                id: nil
  end
end
