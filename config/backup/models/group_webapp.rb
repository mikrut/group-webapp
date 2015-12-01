# encoding: utf-8

Backup::Model.new(:group_webapp, 'Description for group_webapp') do
  split_into_chunks_of 250

  archive :my_archive do |archive|
    archive.add File.expand_path('../../', __FILE__)
  end

  database MySQL do |db|
    db.name               = 'group_webapp_production'
    db.username           = 'root'
    db.password           = '0000'
    db.host               = 'localhost'
    db.port               = 3306
    db.additional_options = ['--quick', '--single-transaction']
  end

  store_with Local do |local|
    local.path       = '~/backups/'
    local.keep       = 5
  end
end
