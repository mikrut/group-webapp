require 'test_helper'

class GroupTest < ActiveSupport::TestCase

  test 'ordinary group passes the validation' do
    group = create_ordinary_group
    assert group.valid?
  end

  ['faculty_name', 'cathedra_name', 'semester',
   'faculty', 'cathedra', 'index'].each do |param_name|

    test "group requires #{param_name} presence" do
      group = create_ordinary_group
      group.send "#{param_name}=", nil
      assert_not group.valid?
    end

  end

  ['faculty_name', 'cathedra_name'].each do |param_name|
    test "group limits #{param_name} length to 128 symbols" do
      group = create_ordinary_group
      group.send "#{param_name}=", 'L' * 129
      assert_not group.valid?
    end
  end

  private

  def create_ordinary_group
    Group.create title: 'ИУ6-52', faculty_name: 'Faculty name',
          cathedra_name: 'Cathedra name'
  end

end
