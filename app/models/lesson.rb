# encoding: utf-8

class Lesson < ActiveRecord::Base
  enum occurence_type: {weekly: 0, numerator: 1, denominator: 2}
  enum lesson_type: {lecture: 0, seminar: 1, laboratory: 2}
  enum weekday: {MON: 0, TUE: 1, WED: 2, THU: 3, FRI: 4, SAT: 5, SUN: 6}

  WEEKDAY_NAMES = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
  TIMES = [
    {begin: {hour:  8, minute: 30}, end: {hour: 10, minute: 05}},
    {begin: {hour: 10, minute: 15}, end: {hour: 11, minute: 00}},
    {begin: {hour: 12, minute: 00}, end: {hour: 13, minute: 35}},
    {begin: {hour: 13, minute: 50}, end: {hour: 15, minute: 25}},
    {begin: {hour: 15, minute: 40}, end: {hour: 17, minute: 15}},
    {begin: {hour: 17, minute: 25}, end: {hour: 19, minute: 00}},
    {begin: {hour: 19, minute: 10}, end: {hour: 20, minute: 45}},
    ]
  LESSON_TYPES = ["Лекция", "Семинар", "Лабораторная работа"]

  belongs_to :discipline
  belongs_to :group

  ['occurence_type', 'weekday', 'lesson_type'].each do |attr|
    alias_method "old_#{attr}", "#{attr}="
    alias_method "old_#{attr}_get", "#{attr}"

    define_method("#{attr}=") do |val|
      send "old_#{attr}", val.to_i
    end

    define_method(attr) do
      Lesson.send("#{attr}s")[send "old_#{attr}_get"]
    end
  end

  def lesson_types_for_select
    lesson_types.to_a.map.with_index do |t,i|
      [LESSON_TYPES[i],t]
    end
  end

  def weekdays_for_select
    weekdays.to_a.map.with_index do |t,i|
      [WEEKDAY_NAMES[i],t]
    end
  end
end
