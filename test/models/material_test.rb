require 'test_helper'

class MaterialTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  test 'material uploads' do
    material = Material.create title: 'Java SE',
                               description: 'Java SE Presentation',
                               user: User.first
    uploaded_file = fixture_file_upload 'files/java_se_10.ppt',
                                        'application/vnd.ms-powerpoint'
    material.document = uploaded_file
    assert material.save
    material.delete
  end

  test 'material without user doesnt upload' do
    material = Material.create title: 'Java SE',
                               description: 'Java SE Presentation'
    uploaded_file = fixture_file_upload 'files/java_se_10.ppt',
                                        'application/vnd.ms-powerpoint'
    material.document = uploaded_file
    assert_not material.valid?
  end

  test 'material requires for title' do
    material = Material.create description: 'Java SE Presentation',
                               user: User.first
    uploaded_file = fixture_file_upload 'files/java_se_10.ppt',
                                        'application/vnd.ms-powerpoint'
    material.document = uploaded_file
    assert_not material.valid?
  end

  test 'material requires for file uploaded' do
    material = Material.create title: 'Java SE',
                               description: 'Java SE Presentation',
                               user: User.first
    assert_not material.valid?
  end

  test 'material checks title uniqueness' do
    existing_material = Material.first
    new_material = Material.create title: existing_material.title,
                                   description: 'Java SE Presentation',
                                   user: User.first
    uploaded_file = fixture_file_upload 'files/java_se_10.ppt',
                                        'application/vnd.ms-powerpoint'
    new_material.document = uploaded_file
    assert_not new_material.valid?
  end

  test 'material has title length limitation' do
    material = Material.create title: 'Java SE' * 50,
                               description: 'Java SE Presentation',
                               user: User.first
    uploaded_file = fixture_file_upload 'files/java_se_10.ppt',
                                        'application/vnd.ms-powerpoint'
    material.document = uploaded_file
    assert_not material.valid?
  end
end
