class PostHobbiesController < ApplicationController
  def new
    @post_hobby = PostHobby.new
    @isDraft = @post_hobby.draft?
  end

  def create
     if params
       params[:post_status] == :draft
        @post_hobby = PostHobby.create(post_hobby_params.merge(user_id: current_user.id))
       if @post_hobby.save_draft
         flash[:notice] = "下書き保存に成功しました"
         redirect_to drafts_post_hobbies_path
        else
         flash.now[:alert] = "下書き保存に失敗しました"
         render :new
        end
      else
         @post_hobby = PostHobby.create(post_hobby_params.merge(user_id: current_user.id))
        tag_list = params[:post_hobby][:tag_name].split(',')
        if tag_list == []
          tag = Tag.new()
          tag.tag_name = ""
          tag.save
          flash.now[:alert] = "タグを入力してください"
          render :new
        elsif @post_hobby.save
          flash[:notice] = "投稿に成功しました"
          @post_hobby.save_tags(tag_list)
          redirect_to post_hobby_path(@post_hobby)
        else
          render :new
        end
      end
  end

  def index
    #公開設定のみ一覧へ表示させる
    @published_post_hobbies = PostHobby.where(user_id: current_user.id).where(post_status: :published).order(created_at: :desc)
    @tag_list = Tag.all
  end

  def show
    @post_hobby = PostHobby.find(params[:id])
  end

  def edit
    @post_hobby = PostHobby(params[:id])
    @tag_list = @post_hobby.tags.pluck(:tag_name).join(',')
  end

  def update

  end

  def drafts
    #下書き保存した分のみ表示する
    @draft_post_hobbies = PostHobby.where(user_id: current_user.id).where(post_status: :draft).order(created_at: :desc)
  end

  def favorites

  end

  private

  def post_hobby_params
    params.require(:post_hobby).permit(:title, :text, :post_status, :post_image)
  end
end
