class ChatsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @chat = current_user.chats.new(chat_params)
    @chat.group_id = @group.id
    if @chat.save
      @group.create_notification_by(current_user, @chat.id)
      flash[:notice] = "チャットを送信に成功しました"
      redirect_to request.referer
    else
      flash.now[:alert] = "チャットを送信に失敗しました"
      redirect_to :show
    end
  end

  private

  def chat_params
    params.require(:chat).permit(:message)
  end
end
