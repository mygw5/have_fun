class ChatsController < ApplicationController

  def create
    group = Group.find(params[:group_id])
    chat = group.chats.build(chat_params)
    chat.user_id = current_user.id
    chat.save
    redirect_to group_path(group)
  end

  private

  def chat_params
    params.require(:chat).permit(:message)
  end
end
