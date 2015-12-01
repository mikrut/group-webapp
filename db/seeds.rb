# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

group = Group.create(cathedra: 6, cathedra_name: 'Computer networks', faculty: 'IU', faculty_name: 'Informatics', semester: 5, index: 2)

User.create(name: 'admin', password: 'admin', email: 'admin@localhost', password_confirmation: 'admin', date_of_birth: '1990-10-05', role: User.roles[:admin], group_id: group.id)

Discipline.create(name: 'C++', description: 'the best discipline ever', group_id: group.id)
