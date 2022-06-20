class SearchController < ApplicationController

  def index
    @serial_stat = SerialStat.first
    allow_params = params.permit(:key,:search_elements,:non_search_elements,:page,:page_a,:release_v1,:release_v2)
    @release_v1 = allow_params[:release_v1].to_i.zero? ? @serial_stat.min_release : allow_params[:release_v1].to_i
    @release_v2 = allow_params[:release_v2].to_i.zero? ? @serial_stat.max_release : allow_params[:release_v2].to_i
    if request.fullpath=="/?key=&search_elements=&non_search_elements=&release_v1=#{@serial_stat.min_release}&release_v2=#{@serial_stat.max_release}"
      redirect_to(root_path) && return
    end
    per_page = 72
    @key = allow_params[:key]
    @search_elements = allow_params[:search_elements]
    @non_search_elements = allow_params[:non_search_elements]
    search_elements = @search_elements ? @search_elements.split('-').map{|x| x.to_i}.select{|x| x>0} : []
    non_search_elements = @non_search_elements ? @non_search_elements.split('-').map{|x| x.to_i}.select{|x| x>0} : []
    additional_keys = [50001,50002,50003,50004,50005]
    search_elements_additional = search_elements & additional_keys
    non_search_elements_additional = non_search_elements & additional_keys
    search_elements = search_elements - search_elements_additional
    non_search_elements = non_search_elements - non_search_elements_additional
    cond=[]
    if (@serial_stat.min_release!=@release_v1) || (@serial_stat.max_release!=@release_v2)
      cond << "release between #{@release_v1} and #{@release_v2}"
    end
    unless @key.blank?
      @key_fixed = russian_lower(remove_sql_explot(@key)).downcase
      @key_fixed = @key_fixed[1,40] if @key_fixed.size>40
      if @key_fixed.size>=3
        cond << "(lower(replace(title,'ё','е')) like '%#{@key_fixed}%' or lower(english_title) like '%#{@key_fixed}%' or lower(original_title) like '%#{@key_fixed}%' or lower(replace(aka,'ё','е')) like '%#{@key_fixed}%')"
      end
    end
    if search_elements_additional.any? or non_search_elements_additional.any?
      cond << 'full_length = true' if search_elements_additional.include?(50001)
      cond << 'adult = true' if search_elements_additional.include?(50002)
      cond << 'full_length = false' if non_search_elements_additional.include?(50001)
      cond << 'adult = false' if non_search_elements_additional.include?(50002)
      cond << 'total not in (12,13)' if non_search_elements_additional.include?(50003)
      cond << 'total not in (24,25,26)' if non_search_elements_additional.include?(50004)
      cond << 'total < 27' if non_search_elements_additional.include?(50005)

      if search_elements_additional.include?(50003) || search_elements_additional.include?(50004) || search_elements_additional.include?(50005)
        s = []
        s << 'total in (12,13)' if search_elements_additional.include?(50003)
        s << 'total in (24,25,26)' if search_elements_additional.include?(50004)
        s << 'total >= 27' if search_elements_additional.include?(50005)
        cond << '('+s.join(' or ')+')'
      end
    end
    if search_elements.any? or non_search_elements.any?
      cond << "id in (select serial_id from serial_elements where element_id in (#{search_elements.join(',')})  group by serial_id having count(*)=#{search_elements.size})" if search_elements.any?
      cond << "id not in (select serial_id from serial_elements where element_id in (#{non_search_elements.join(',')}))" if non_search_elements.any?
    end
    @page = [allow_params[:page].to_i,1].max
    @page_a = allow_params[:page_a]
    @genres = Element.by_elem_type(Element::GENRE_ID)
    @categories = Element.by_elem_type(Element::CATEGORY_ID)
    @additionals = [
        {id:50001,title:t('search.index.full_length')},
        {id:50002,title:t('search.index.adult')},
        {id:50003,title:t('search.index.total_1')},
        {id:50004,title:t('search.index.total_2')},
        {id:50005,title:t('search.index.total_3')}
    ]
    @serials = Serial.includes(:attachments,serial_elements: :element).order("video_date desc nulls last, release desc nulls last").where(is_applied: true, is_cancelled: false)
    @serials = @serials.where(cond.join(' and ')) if cond.any?
    @serials = @serials.paginate(page:@page, per_page:per_page)

    @reviews = Review.where(is_cancelled: false, is_applied: true).includes(:serial,:attachments).order('created_at desc').limit(6)
    @news = New.where(is_cancelled: false, is_applied: true).includes(:attachments).order('created_at desc').limit(6)
  end

  def sitemap
    respond_to do |format|
      format.xml { render file: 'public/sitemaps/sitemap.xml' }
      format.html { redirect_to root_url }
    end
  end
end