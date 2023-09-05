class CommentsController < ApplicationController

  def create
    post_hobby = PostHobby.find(params[:post_hobby_id])
    comment = current_user.comments.new(comment_params)
    comment.post_hobby_id = post_hobby.id
    comment.save
    resirect_to post_hobby_path(post_hobby)
  end

  private

  def comment_parmas
    params.require(:comment).permit(:comment)

  end
end
