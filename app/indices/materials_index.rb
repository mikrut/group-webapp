ThinkingSphinx::Index.define :material, :with => :active_record do
  indexes title, :sortable => true
  indexes description
  indexes author.name
end
