class PostHobbiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def new
    @post_hobby = PostHobby.new
    @tag_list = @post_hobby.tags.pluck(:tag_name).join(',')
    @isDraft = @post_hobby.draft?
  end

  def create
    if params[:commit] == "下書き保存"
      @post_hobby = PostHobby.create(post_hobby_params.merge(user_id: current_user.id))
      if @post_hobby.post_status = :draft
        @post_hobby.save
        flash[:notice] = "下書き保存に成功しました"
        redirect_to unpublished_post_hobbies_path
      else
        flash.now[:alert] = "下書き保存に失敗しました"
        render :new
      end
    else
      @post_hobby = PostHobby.create(post_hobby_params.merge(user_id: current_user.id))
      tag_list = params[:post_hobby][:tag_name].split(',')
      if @post_hobby.save
        @post_hobby.save_tags(tag_list)
        flash[:notice] = "投稿に成功しました"
        redirect_to post_hobbies_path
      else
        flash.now[:alert] = "投稿に失敗しました"
        render :new
      end
    end
  end

  def index
    #公開設定のみ一覧へ表示させる
    @q = PostHobby.ransack(params[:q])
    @post_hobbies = @q.result(distinct: true).where(post_status: :published).order(created_at: :desc).page(params[:page])
    @tag_list = Tag.all
  end

  def show
    @post_hobby = PostHobby.find(params[:id])
    @user = @post_hobby.user
    @comment = Comment.new
  end

  def edit
    @post_hobby = PostHobby.find(params[:id])
    @tag_list = @post_hobby.tags.pluck(:tag_name).join(',')
    @isDraft = @post_hobby.draft?
  end

  def update
    @post_hobby = PostHobby.find(params[:id])
    tag_list = params[:post_hobby][:tag_name].split(',')
    if @post_hobby.update(post_hobby_params)
      if params[:commit] == "下書き保存"
        @post_hobby.update(post_status: :draft)
        flash[:notice] = "下書きの更新に成功しました"
        redirect_to unpublished_post_hobbies_path
      elsif params[:commit] == "非公開にする"
        @post_hobby.update(post_status: :unpublished)
        @post_hobby.save_tags(tag_list)
        flash[:notice] = "投稿を非公開にしました"
        redirect_to unpublished_post_hobbies_path
      elsif @post_hobby.update(post_status: :published)
        @post_hobby.save_tags(tag_list)
        flash[:notice] = "投稿内容の更新に成功しました"
        redirect_to post_hobbies_path
      else
        flash.now[:alert] = "投稿内容の更新に失敗しました"
        render :edit
      end
    else
        flash.now[:alert] = "変更を保存できませんでした"
        render :edit
    end
  end

  def destroy
    post_hobby = PostHobby.find(params[:id])
    post_hobby.destroy
    flash[:notice] = "投稿削除に成功しました"
    redirect_to request.referer
  end

  def unpublished
    @post_hobbies = PostHobby.order(created_at: :desc).where(user_id: current_user.id)
  end

  def favorites
    favorite = Favorite.where(user_id: current_user.id).pluck(:post_hobby_id)
    @post_hobbies = PostHobby.find(favorite)
  end

  private

  def post_hobby_params
    params.require(:post_hobby).permit(:title, :text, :post_status, :post_image)
  end

  def ensure_correct_user
    @post_hobby = PostHobby.find(params[:id])
    unless @post_hobby.user == current_user || current_user.admin?
      redirect_to post_hobbies_path
    end
  end
end