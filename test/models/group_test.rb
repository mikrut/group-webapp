require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  test 'ordinary group passes the validation' do
    group = create_ordinary_group
    assert group.valid?
  end

  %w(faculty_name cathedra_name semester
     faculty cathedra index).each do |param_name|
    test "group requires #{param_name} presence" do
      group = create_ordinary_group
      group.send "#{param_name}=", nil
      assert group.invalid?
    end
  end

  %w(faculty_name cathedra_name).each do |param_name|
    test "group limits #{param_name} length to 128 symbols" do
      group = create_ordinary_group
      group.send "#{param_name}=", 'L' * 129
      assert group.invalid?
    end
  end

  [{ param_name: 'semester',  bottom: 1, top: 12 },
   { param_name: 'cathedra',  bottom: 1, top: 20 },
   { param_name: 'index',     bottom: 1, top: 5 }].each do |description|
    test "#{description[:param_name]} bottom"\
         "is #{description[:bottom]}" do
      group = create_ordinary_group
      group.send "#{description[:param_name]}=", description[:bottom]
      assert group.valid?
    end

    test "#{description[:param_name]} below bottom"\
         "is #{description[:bottom] - 1}" do
      group = create_ordinary_group
      group.send "#{description[:param_name]}=",
                 description[:bottom] - 1
      assert group.invalid?
    end

    test "#{description[:param_name]} top"\
         "is #{description[:top]}" do
      group = create_ordinary_group
      group.send "#{description[:param_name]}=", description[:top]
      assert group.valid?
    end

    test "#{description[:param_name]} above top"\
         "is #{description[:top] + 1}" do
      group = create_ordinary_group
      group.send "#{description[:param_name]}=", description[:top] + 1
      assert group.invalid?
    end
  end

  private

  def create_ordinary_group
    Group.create title: 'ИУ6-52', faculty_name: 'Faculty name',
                 cathedra_name: 'Cathedra name'
  end
end
