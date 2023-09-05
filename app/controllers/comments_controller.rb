class CommentsController < ApplicationController

  def create
    post_hobby = PostHobby.find(params[:post_hobby_id])
    comment = current_user.comments.new(comment_params)
    comment.post_hobby_id = post_hobby.id
    comment.save
    redirect_to post_hobby_path(post_hobby)
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to post_hobby_path(params[:post_hobby_id])
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)

  end
end
