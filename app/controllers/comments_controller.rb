class CommentsController < ApplicationController

  def create
    post_hobby = PostHobby.find(params[:post_hobby_id])
    @comment = current_user.comments.new(comment_params)
    @comment.post_hobby_id = post_hobby.id
    @comment.save
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment)

  end
end
