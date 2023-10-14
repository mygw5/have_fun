class ChatsController < ApplicationController
  before_action :authenticate_user!

  def create
    @group = Group.find(params[:group_id])
    @chat = current_user.chats.new(chat_params)
    @chat.group_id = @group.id
    @chat.save

    @group.create_notification_by(current_user, @chat.id)
  end

  private
    def chat_params
      params.require(:chat).permit(:message)
    end
end
