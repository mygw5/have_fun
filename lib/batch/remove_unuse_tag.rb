class Batch::RemoveUnuseTag
  def self.remove_unuse_tag
    # 投稿と結びつきがないタグを抽出する
    tag_count_hash = Tag.joins(:post_hobbies).group(:id).count
    Tag.all.each do |tag|
      unless tag_count_hash[tag.id]
        tag.destroy
      end
    end
    p "結びつきのないタグを全て削除しました"
  end
end
