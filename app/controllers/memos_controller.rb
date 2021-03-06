class MemosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_memo, only: [:show, :edit, :update, :destroy]

  def all
    @q = Memo.open.resent.with_user.ransack(params[:q])
    @memos = @q.result(distinct: true).page(params[:page])
  end

  def index
    @user = User.find(params[:user_id])
    pickup_memos_within_range(@user, @user)
  end

  def new
    @user = User.find(params[:user_id])
    check_your_id(@user.id)
    @memo = Memo.new
    if params[:house_id]
      @memo.house_id = params[:house_id]
    elsif params[:room_id]
      room = Room.find(params[:room_id])
      @memo.room_id = params[:room_id]
      @memo.house_id = room.house_id
    end
    @houses = @user.houses.all.with_rooms.resent
    @rooms = @user.rooms.all.resent
  end

  def create
    @memo = current_user.memos.new(memo_params)
    if @memo.save
      touch_parent(@memo)
      flash[:success] = "投稿が完了しました"
      back_in_place(@memo)
    else
      @user = current_user
      @houses = @user.houses.all.with_rooms.resent
      @rooms = @user.rooms.all.resent
      render :new
    end
  end

  def show
    range_barrier(@memo)
    @tags = @memo.tags
    @comments = @memo.comments.all.eager_load(:user)
    @comment = Comment.new
  end

  def edit
    check_your_id(@memo.user_id)
    @user = @memo.user
    @houses = @user.houses.all.with_rooms.resent
    @rooms = @user.rooms.all.resent
  end

  def update
    check_your_id(@memo.user_id)
    @memo.tag_list.remove(@memo.tag_list)
    @memo.assign_attributes(memo_params)
    @memo.image_id = nil if params[:image_is_delete] == "true"
    if @memo.save
      touch_parent(@memo)
      flash[:success] = "投稿を更新しました"
      redirect_to memo_path(@memo)
    else
      @user = @memo.user
      @houses = @user.houses.all.resent
      @rooms = @user.rooms.all.resent
      render :edit
    end
  end

  def destroy
    check_your_id(@memo.user_id)
    @memo.destroy
    flash[:alert] = "投稿を削除しました"
    back_in_place(@memo)
  end

  private

  def memo_params
    params.require(:memo).permit(:title, :body, :tag_list, :range, :image, :house_id, :room_id)
  end

  def set_memo
    @memo = Memo.find(params[:id])
  end

  # 公開範囲に合わせてアクセスを拒否
  def range_barrier(memo)
    if memo.range == "自分のみ" # 自分以外back
      unless memo.user_id == current_user.id
        flash[:alert] = "閲覧権限がありません"
        redirect_back(fallback_location: root_path)
      end
    elsif memo.range == "友達のみ" # 自分と友達以外back
      unless memo.user_id == current_user.id || current_user.friends.ids.include?(memo.user_id)
        flash[:alert] = "閲覧権限がありません"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  # メモのある家や部屋の更新日を変更する
  def touch_parent(memo)
    if memo.room_id.present?
      room = Room.find_by(id: memo.room_id)
      room.touch # 部屋の更新日を変更する
      House.find_by(id: room.house_id).touch # 家の更新日を変更する
    elsif memo.house_id.present?
      House.find_by(id: memo.house_id).touch
    end
  end

  # メモの場所によって家と部屋どちらかに遷移するか
  def back_in_place(memo)
    if memo.room_id.present?
      redirect_to room_path(memo.room)
    else # memo.house == true
      redirect_to house_path(memo.house)
    end
  end
end
