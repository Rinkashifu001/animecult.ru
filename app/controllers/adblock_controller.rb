class AdblockController < ApplicationController

  before_action :access_deny_if_not_an_admin

  def index
    @adblock = Adblock.new
    @adblocks = Adblock.order(:title)
  end

  def create
    @adblock = Adblock.new(adblock_params)
    if @adblock.save
      redirect_to adblock_index_path
    else
      @adblocks = Adblock.order(:title)
      render :index
    end
  end

  def destroy
    @adblock = Adblock.find(params[:id])
    @adblock.destroy
    redirect_to adblock_index_path
  end

  private

  def adblock_params
    params.require(:adblock).permit(:title)
  end

end
