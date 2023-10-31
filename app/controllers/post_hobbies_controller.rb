class PostHobbiesController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  before_action :set_post_hobby, only: [:edit, :show, :update]
  before_action :unpublished_post, only: [:show]

  def new
    @post_hobby = PostHobby.new
    @tag_list = @post_hobby.tags.pluck(:tag_name).join(",")
    @is_draft = @post_hobby.draft?
  end

  def create
    @post_hobby = PostHobby.new(post_hobby_params)
    if post_hobby_params[:post_image].present?
      # 画像ありの時の処理
      if result
        if params[:commit] == "下書き保存"
          if @post_hobby.save_draft
            flash[:notice] = "下書き保存に成功しました"
            redirect_to unpublished_post_hobbies_path
          else
            flash.now[:alert] = "下書き保存に失敗しました"
            render :new
          end
        else
          tag_list = params[:post_hobby][:tag_name].split(",")
          if @post_hobby.save
            @post_hobby.save_tags(tag_list)
            flash[:notice] = "投稿に成功しました"
            redirect_to post_hobbies_path
          else
            flash.now[:alert] = "投稿に失敗しました"
            render :new
          end
        end
      else
        flash.now[:alert] = "画像が不適切です"
        render :new
      end
    # 画像なしの時の処理
    elsif params[:commit] == "下書き保存"
      if @post_hobby.save_draft
        flash[:notice] = "下書き保存に成功しました"
        redirect_to unpublished_post_hobbies_path
      else
        flash.now[:alert] = "下書き保存に失敗しました"
        render :new
      end
    else
      tag_list = params[:post_hobby][:tag_name].split(",")
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
    # 公開設定のみ一覧へ表示させる
    @q = PostHobby.ransack(params[:q])
    @post_hobbies = @q.result(distinct: true).where(post_status: :published).order(created_at: :desc).page(params[:page])
    @follow_posts = @q.result(distinct: true).where(post_status: :opublished).where(current_user.follow).order(created_at: :desc).page(params[:page])
    @tag_list = Tag.all
  end

  def show
    @user = @post_hobby.user
    @comment = Comment.new
    @reply_comment = @post_hobby.comments.new
  end

  def edit
    @tag_list = @post_hobby.tags.pluck(:tag_name).join(",")
    @is_draft = @post_hobby.draft?
  end

  def update
    tag_list = params[:post_hobby][:tag_name].split(",")
    if post_hobby_params[:post_image].present?
      # 画像ありの処理
      if result
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
            redirect_to post_hobby_path(@post_hobby)
          else
            flash.now[:alert] = "投稿の更新に失敗しました"
            render :edit
          end
        else
          flash.now[:alert] = "変更を保存できませんでした"
          render :edit
        end
      else
        flash.now[:alert] = "画像が不適切です"
        render :new
      end
    elsif @post_hobby.update(post_hobby_params)
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
        redirect_to post_hobby_path(@post_hobby)
      else
        flash.now[:alert] = "投稿の更新に失敗しました"
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
    redirect_to post_hobbies_path
  end

  def unpublished
    @post_hobbies = PostHobby.where(user_id: current_user.id)
  end

  def favorites
    favorite = Favorite.where(user_id: current_user.id).pluck(:post_hobby_id)
    @post_hobbies = PostHobby.find(favorite)
  end

  private
    def post_hobby_params
      params.require(:post_hobby).permit(:title, :text, :post_status, :post_image).merge(user_id: current_user.id)
    end

    def ensure_correct_user
      @post_hobby = PostHobby.find(params[:id])
      unless @post_hobby.user == current_user || current_user.admin?
        redirect_to post_hobbies_path
      end
    end

    def set_post_hobby
      @post_hobby = PostHobby.find(params[:id])
    end

    def result
      Vision.image_analysis(post_hobby_params[:post_image])
    end

    def unpublished_post
      @post_hobby = PostHobby.find(params[:id])
      if @post_hobby.draft? || @post_hobby.unpublished?
        unless @post_hobby.user == current_user
         redirect_to post_hobbies_path
        end
      end
    end
end