class CreditController < ApplicationController

  def search
    key = russian_lower(remove_sql_explot(params[:q].to_s)).downcase
    result = []
    if key.size>=3
      text = e.title.blank? ? e.title_translated : e.title
      result = Credit.where("lower(title) like '#{key}%' or lower(title_translated) like '#{key}%'").order(:title).limit(10).map{|e| {id: e.id,text: text}}
    end
    render json: result
  end

end
