class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post_hobby

  def create
    @comment = @post_hobby.comments.new(comment_params)
    @comment.score = Language.get_data(comment_params[:comment])
    @comment.user_id = current_user.id
    @reply_comment = @post_hobby.comments.new
    @reply_comment.score = Language.get_data(comment_params[:comment])
    @comment.save
    # 通知機能
    @post_hobby.create_notification_by(current_user, @comment.id)
  end


  def destroy
    @reply_comment = @post_hobby.comments.new
    @comment = Comment.find(params[:id])
    @comment.destroy
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :parent_id, :user_id, :post_hobby_id)
  end

  def set_post_hobby
    @post_hobby = PostHobby.find(params[:post_hobby_id])
  end
end
