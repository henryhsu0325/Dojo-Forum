# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  name: 'Admin',
  email: 'admin@example.com',
  password: '12345678',
  role: 'admin'
  )
puts 'Default admin user created' 

Category.destroy_all

category_list = [
  { name: "商業 " },
  { name: "流行" },
  { name: "心理" },
  { name: "科技" },
  { name: "文學" },
  { name: "娛樂" },
  { name: "體育" }
]

category_list.each do |category|
  Category.create( name: category[:name] )
end
puts "Category created!"