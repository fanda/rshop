# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

Employee.create({:name => 'fanda', :email => 'fandisek@gmail.com'})
Page.create({:title => 'Text na úvodní straně'})
Page.create({:title => 'Text u kontaktního formuláře'})
Page.create({:title => 'Obchodní podmínky'})
