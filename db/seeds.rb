# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if user = User.find_by(name: "admin") then
  user.destroy
end
admin = User.create({name: "admin", password:"admin", email:"admin@localhost", password_confirmation:"admin", date_of_birth: "1990-10-05", role: User.roles[:admin]})
