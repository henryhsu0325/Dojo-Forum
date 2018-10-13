namespace :dev do
  task fake_user: :environment do
    User.destroy_all
    url = "https://uinames.com/api/?ext&region=england"
     10.times do
      response = RestClient.get(url)
      data = JSON.parse(response.body)
       user = User.create!(
        name: data["name"],
        email: data["email"],
        remote_avatar_url: data["photo"],
        password: "12345678",
        introduction: "Hi! My name is #{data["name"]} #{FFaker::DizzleIpsum::paragraph(10)}"
      )
    end
     puts "have created fake users"
    puts "now you have #{User.count} users data"
  end

  task fake_post: :environment do
    Post.destroy_all
    User.all.each do |user|   
      5.times do |i|
        permit = ["all","friend","myself"]
        user.posts.create!(
          title: FFaker::Movie.title,
          description: FFaker::Lorem.sentence(80),
          status: "publish",
          permit: permit.sample,
        )
      end
    end

    Post.all.each do |post|
      rand(1..3).times do |i|
        CategoryOfPost.create!(category: Category.all.sample, post: post)
      end
    end

    puts "have created fake posts"
    puts "now you have #{Post.count} post data"
  end

  task fake_reply: :environment do
    Reply.destroy_all
    User.all.each do |user|
      rand(25..30).times do |post|
        post = Post.all_publish(user).sample
        post.replies.create!(
          comment: FFaker::Lorem.sentence(30),
          user: user,
          created_at: FFaker::Time::between(Time.new(2018, 04, 01), Time.new(2018, 05, 13))
        )
      end
    end
    puts "have created fake replies"
    puts "now you have #{Reply.count} reply data"
  end

  task fake_friend: :environment do
    Friendship.destroy_all
      User.all.each do |user|   
        10.times do |i|
          status = ["send","connect"]
          user.friendships.create!(
            friend: User.all.where.not(id: user)[i],
            status: status.sample
          )
        end
      end
    puts "have created fake friends"
    puts "now you have #{Friendship.count} friend data"
  end

  task fake_collect: :environment do
    Collect.destroy_all
    User.all.each do |user|
      3.times do |post|
        post = Post.all_publish(user).sample
        post.collects.create!(user: user)
      end
    end
    puts "have created fake collects"
    puts "now you have #{Collect.count} collect data"
  end

  task fake_all: :environment do
    system 'rails db:drop'
    system 'rails db:create'
    system 'rails db:migrate'
    system 'rails dev:fake_user'
    system 'rails db:seed'
    system 'rails dev:fake_post'
    system 'rails dev:fake_reply'
  end
end