ThinkingSphinx::Index.define :material, with: :active_record do
  indexes title, sortable: true
  indexes description
  indexes author.name

  set_property enable_star: 1
  set_property min_infix_len: 3
end
