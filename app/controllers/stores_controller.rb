class StoresController < ApplicationController

  before_action :find_store, only: %i[index update edit destroy show]
  before_action :find_event, only: [:index]
  def index
    if current_user?
      @q =Store.ransack(params[:q])
      @store=@q.result
    elsif current_user_store?
      @store = current_user.store
      redirect_to store_products_path(@store.id)
    else
      redirect_to new_store_path
    end
  end

  def new
    @store = Store.new
  end
  
  def create
    @store = current_user.build_store(store_params) if current_vendor?
    if @store.save
      redirect_to stores_path, notice: '成功新增商店！'
    else
      render :new
    end
  end

  def show
    if current_user_store?
      @store = current_user.store
      redirect_to store_products_path(@store.id)
    else
      redirect_to new_store_path
    end
  end

  def edit
  end
  
  def update
    if @store.update(store_params)
      redirect_to stores_path, notice: '成功更新商店！'
    else
      render :edit
    end
  end

  def destroy
    @store.destroy

    redirect_to stores_path, alert: '商店已刪除'
  end

  def checkout_order

  end

  private
  
  def store_params
    params.require(:store).permit(:title, :description, :avatar)
  end 

  def find_store
    @store = Store.find_by(id: params[:store_id])
    if current_user_store?
      @store =current_user.store
    end
  end
  
  def current_user_store?
    @store = current_user.store
  end

  def find_event
    @event = Event.find(params[:id])
  end

end
