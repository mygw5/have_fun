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

# タグテストデータ
confectionery = Tag.find_or_create_by!(tag_name: "お菓子作り")
cake = Tag.find_or_create_by!(tag_name: "ケーキ")
shrine = Tag.find_or_create_by!(tag_name: "神社")
desert = Tag.find_or_create_by!(tag_name: "デザート巡り")

# ユーザーテストデータ
momiji = User.find_or_create_by!(email: "momiji@example.com") do |user|
  user.name = "椛"
  user.hobby = "製菓,神社巡り"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename: "sample-user1.jpg")
end

sakura = User.find_or_create_by!(email: "sakura@example.com") do |user|
  user.name = "さくら"
  user.hobby = "料理,デザート巡り"
  user.introduction = "料理大好きです！よろしくお願いします。"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename: "sample-user2.jpg")
end

User.find_or_create_by!(email: "taro@example.com") do |user|
  user.name = "太郎"
  user.hobby = "ゲーム"
  user.introduction = "新しい趣味を見つけたい!"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename: "sample-user3.jpg")
end

User.find_or_create_by!(email: "shin@example.com") do |user|
  user.name = "シン"
  user.hobby = "映画鑑賞"
  user.introduction = "ホラー映画とねこ大好き!アイコンの猫ちゃんは猫カフェの猫です"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user4.jpg"), filename: "sample-user4.jpg")
  user.is_status = false
end

hana = User.find_or_create_by!(email: "hana@example.com") do |user|
  user.name = "華"
  user.hobby = "フラワーアレンジ,デザート巡り"
  user.introduction = "よろしくお願いします。"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user5.jpg"), filename: "sample-user5.jpg")
end

# 投稿テストデータ
PostHobby.find_or_create_by!(title: "ベイクドケーキ") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post1.jpg"), filename: "sample-post1.jpg")
  post_hobby.text = "ベイクドチーズケーキを作りました！甘くてふんわりして美味しい◎"
  post_hobby.user = momiji
  post_hobby.tags << confectionery
  post_hobby.tags << cake
end

PostHobby.find_or_create_by!(title: "料理") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post2.jpg"), filename: "sample-post2.jpg")
  post_hobby.text = "クリームチーズと砂糖と牛乳をミキサーで混ぜて、湯煎焼きして作りました。市販のチーズケーキプリンみたいで美味しいです！"
  post_hobby.user = sakura
  post_hobby.tags << confectionery
end

PostHobby.find_or_create_by!(title: "神社巡り") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post3.jpg"), filename: "sample-post3.jpg")
  post_hobby.text = "綺麗な梅の花が咲いていたので、共有！！平日でも人が多い！"
  post_hobby.user = momiji
  post_hobby.tags << shrine
end

PostHobby.find_or_create_by!(title: "デザート巡り") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post4.jpg"), filename: "sample-post4.jpg")
  post_hobby.text = "デザートを求めてカフェに行きました!デザートは撮り忘れたので、カフェオレを代わりに載せときます!カフェオレも美味!!"
  post_hobby.user = sakura
  post_hobby.tags << desert
end

PostHobby.find_or_create_by!(title: "抹茶ティラミス") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post5.jpg"), filename: "sample-post5.jpg")
  post_hobby.text = "抹茶のティラミス食べに来ました!カフェオレまで最高でした!"
  post_hobby.user = hana
  post_hobby.tags << desert
end

PostHobby.find_or_create_by!(title: "お花") do |post_hobby|
  post_hobby.post_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-post6.jpg"), filename: "sample-post6.jpg")
  post_hobby.text = "フラワーアレンジ!まだまだ練習中!"
  post_hobby.user = hana
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