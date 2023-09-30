class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @post_hobby = PostHobby.find(params[:post_hobby_id])
    @comment = @post_hobby.comments.new(comment_params)
    @comment.user_id = current_user.id
    @reply_comment = @post_hobby.comments.new
    @comment.save
    # 通知機能
    @post_hobby.create_notification_by(current_user, @comment.id)
  end


  def destroy
    @post_hobby = PostHobby.find(params[:post_hobby_id])
    @reply_comment = @post_hobby.comments.new
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :parent_id, :user_id, :post_hobby_id)
  end
end
