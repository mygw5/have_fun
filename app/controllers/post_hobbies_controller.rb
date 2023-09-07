class PostHobbiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_q, only: [:index, :search]

  def new
    @post_hobby = PostHobby.new
    @tag_list = @post_hobby.tags.pluck(:tag_name).join(',')
  end

  def create
    @post_hobby = PostHobby.create(post_hobby_params.merge(user_id: current_user.id))
    tag_list = params[:post_hobby][:tag_name].split(',')
    if tag_list == []
      tag = Tag.new()
      tag.tag_name = ""
      tag.save
      flash.now[:alert] = "タグを入力してください"
      render :new
    elsif @post_hobby.save
      @post_hobby.save_tags(tag_list)
      flash[:notice] = "投稿に成功しました"
      redirect_to post_hobby_path(@post_hobby)
    else
      flash.now[:alert] = "投稿に失敗しました"
      render :new
    end
  end

  def index
    #公開設定のみ一覧へ表示させる
    #@published_post_hobbies = PostHobby.where(user_id: current_user.id).where(post_status: :published).order(created_at: :desc)

    @post_hobbies = PostHobby.order('created_at DESC')
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
  end

  def update
    @post_hobby = PostHobby.find(params[:id])
    tag_list = params[:post_hobby][:tag_name].split(',')
    if tag_list == []
       tag = Tag.new()
        tag.tag_name = ""
        tag.save
        flash.now[:alert] = "タグを入力してください"
        render :edit
    elsif @post_hobby.update(post_hobby_params)
        @old_relations = PostTag.where(post_hobby_id: @post_hobby.id)
        @old_relations.each do |relation|
          relation.delete
        end
        @post_hobby.save_tags(tag_list)
        flash[:notice] = "投稿内容の更新に成功しました"
        redirect_to post_hobby_path(@post_hobby)
    else
      flash.now[:alert] = "投稿内容の更新に失敗しました"
      render :edit
    end
  end

  def destroy
    post_hobby = PostHobby.find(params[:id])
    post_hobby.destroy
    flash[:notice] = "投稿削除に成功しました"
    redirect_to post_hobbies_path
  end

  def drafts
    #下書き保存した分のみ表示する
    @draft_post_hobbies = PostHobby.where(user_id: current_user.id).where(post_status: :draft).order(created_at: :desc)
  end

  def favorites
    favorite = Favorite.where(user_id: current_user.id).pluck(:post_hobby_id)
    @post_hobbies = PostHobby.find(favorite)
  end

  def search
    @results = @q.result
  end

  private

  def set_q
    @q = PostHobby.ransack(params[:q])
  end


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