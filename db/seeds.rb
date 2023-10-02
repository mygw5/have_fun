# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

User.create!(
  id:                                       1,
  name:                  ENV["ADMINUSER_NAME"],
  email:                 ENV["ADMINUSER_MAIL"],
  password:              ENV["ADMINUSER_PASSWORD"],
  password_confirmation: ENV["ADMINUSER_PASSWORD"],
  admin:                 true
)


# テストデータ
confectionery = Tag.find_or_create_by!(tag_name: "お菓子作り")
cake = Tag.find_or_create_by!(tag_name: "ケーキ")

# ユーザー1
momiji = User.find_or_create_by!(email: "momiji@example.com") do |user|
  user.name = "椛"
  user.hobby = "製菓,神社巡り"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename: "sample-user1.jpg")
end

PostHobby.find_or_create_by!(title: "ベイクドケーキ") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename: "sample-post1.jpg")
  post_hobby.text = "ベイクドチーズケーキを作りました！甘くてふんわりして美味しい◎"
  post_hobby.user = momiji
  post_hobby.tags << confectionery
  post_hobby.tags << cake
end

PostHobby.find_or_create_by!(title: "神社巡り") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename: "sample-post3.jpg")
  post_hobby.text = "綺麗な梅の花が咲いていたので、共有！！平日でも人が多い！"
  post_hobby.user = momiji
end

# ユーザー2
sakura = User.find_or_create_by!(email: "sakura@example.com") do |user|
  user.name = "さくら"
  user.hobby = "料理,キャンプ"
  user.introduction = "料理大好きです！よろしくお願いします。"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename: "sample-user2.jpg")
end

PostHobby.find_or_create_by!(title: "料理") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename: "sample-post2.jpg")
  post_hobby.text = "クリームチーズと砂糖と牛乳をミキサーで混ぜて、湯煎焼きして作りました。市販のチーズケーキプリンみたいで美味しいです！"
  post_hobby.user = sakura
  post_hobby.tags << confectionery
end



# グループテスト
Group.find_or_create_by!(group_name: "料理研究会") do |group|
  group.group_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-group1.jpg"), filename: "sample-group1.jpg")
  group.introduction = "料理好きの集まりです。気軽に参加してください！"
  group.owner = momiji
  group.users << momiji
  group.users << sakura
end

Group.find_or_create_by!(group_name: "写真に収めたい！") do |group|
  group.group_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-group2.jpg"), filename: "sample-group2.jpg")
  group.introduction = "カメラ好きな人参加してください！景色の綺麗なスポットなどみんなで共有しましょう！"
  group.owner = momiji
  group.users << momiji
end

puts "seedの実行が完了"