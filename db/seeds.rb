# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Create users
FactoryBot.create(:user, :normal, email: 'normal@normal.com') 
FactoryBot.create(:user, :editor, email: 'editor@editor.com') 
FactoryBot.create(:user, :admin, email: 'admin@admin.com') 

(1..100).each do 
  FactoryBot.create(:task)
end

