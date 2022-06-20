class AdminController < ApplicationController

  before_action :access_deny_if_not_an_admin

  def index
    @accounts = Account.order(:nickname)


    @adblock_count = Adblock.count
    @admin_data = AdminData.first
  end

  def update
    @admin_data = AdminData.first
    @admin_data.update(params.require(:admin_data).permit(:adv_mobile,:adv_desktop))
    redirect_to(admin_index_path, notice: 'Данные обновлены')
  end

  def update_account_nickname
    account = Account.find(params[:account_id])
    account.nickname = params[:nickname]
    if account.save
      render json: {status:'success',message:"Аккаунт: #{account.id}, никнейм: #{account.nickname}"}
    else
      render json: {status:'error',message:"Не удалось изменить никнейм у аккаунта #{account.id}"}
    end
  end

  def account
    @account = Account.includes(:users).find(params[:account_id])
  end

  def update_seo_item
    p params
    params['domains'].each_pair do |domain,data|
      si = SeoItem.find_or_create_by(controller_name: params[:controller_name], action_name: params[:action_name], domain: domain)
      update_dict = {}
      SeoItem::ALLOWED_TAGS.each do |tag|
        if data.include?(tag.to_s)
          update_dict[tag] = data[tag.to_s]
        end
      end
      si.update(update_dict)
      si.save
    end
    render json: {status: 'success', message: "Элемент:  обновлен"}
  end

end
