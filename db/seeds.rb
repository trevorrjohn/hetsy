# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Seed from local file
require 'csv'

CSV.foreach("#{Rails.root}/db/seeds/exercises.csv", headers:true) do |row|
  Exercise.create(title: row[0], value: row[1].to_f)
end
