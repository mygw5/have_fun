class Batch::RemoveUnuseTag
  def self.remove_unuse_tag
    # 付属する投稿がないタグを抽出
    tag_count_hash=Tag.joins(:post_hobbies).group(:id).count
    Tag.all.each do |tag|
      unless tag_count_hash[tag.id]
        tag.destroy
      end
    end
    p "結びつきのないタグを全て削除しました"
  end
end