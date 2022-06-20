module ApplicationHelper

  def fixed_page_path
    path = request.fullpath.gsub(/page=\d+/,'')
    if path.start_with?('/')
      path = path[1,path.size]
    end
    path.gsub!('?&','?')
    if path.end_with?('?')
      path = path[0,path.size-1]
    end
    path
  end

  def cure_froala(text)
    legal = '<p data-f-id="pbf" style="text-align: center; font-size: 14px; margin-top: 30px; opacity: 0.65; font-family: sans-serif;">Powered by <a href="https://www.froala.com/wysiwyg-editor?pb=1" title="Froala Editor">Froala Editor</a></p>'
    text.to_s.gsub(legal,'')
  end

  def characters(serial)
    result = ''
    serial.character_participates.each_with_index do |cp,index|
      unless index.zero?
        result << ', '
      end
      result << link_to(cp.character.title,character_path(cp.character.link)) unless cp.character.link.blank?
      result << " (#{cp.category_title}"
      result << " - #{link_to(cp.creator.title,creator_path(cp.creator.link))}" unless cp.creator.blank?
      result << ')'
    end
    result.html_safe
  end

  def creators(serial)
    result = ''
    serial.creator_participates.each_with_index do |cp,index|
      unless index.zero?
        result << ', '
      end
      unless cp.creator.blank?
        result << link_to(cp.creator.title,creator_path(cp.creator.link))
      end
      result << " (#{cp.credit.title})"
    end
    result.html_safe
  end

  def creators_by_group(serial)
    result = {}
    serial.creator_participates.each do |cp|
      unless result.include? cp.credit.show_title
        result[cp.credit.show_title] = []
      end
      unless cp.creator.blank?
        result[cp.credit.show_title] << {title: cp.creator.title, link: creator_path(cp.creator.link)}
      end
    end
    result
  end

  def songs(serial)
    result = ''
    serial.song_participates.each_with_index do |sp,index|
      unless index.zero?
        result << ', '
      end
      result << link_to(sp.song.title,song_path(sp.song.link)) unless sp.song.blank?
      result << " (#{sp.relation_title})"
    end
    result.html_safe
  end

  def paginate(collection, params= {})
    params[:controller_accessed] ||= fixed_page_path
    will_paginate collection, params.merge(:renderer => LinkPaginationHelper::LinkRenderer)
  end

  def remove_sql_explot(text)
    #result = text.gsub(/[^a-zа-яА-ЯA-Z 0-9ёЁ]/,'')
    #p result
    text.gsub("'","''")
  end

  def russian_lower(text)
    lower = 'абвгдееежзийклмнопрстуфхцчшщъыьэюя'
    upper = 'АБВГДЕЁёЖЗИЁКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ'
    text.split('').map{|x| upper.include?(x) ? lower[upper.index(x)] : x}.join('')
  end

  def filter_text_for_url text
    text.gsub!(/[^a-z0-9_]+/, '_'); # remaining non-alphanumeric => hyphen
    text.gsub(/^[-_]*|[-_]*$/, ''); # remove hyphens/underscores and numbers at beginning and hyphens/underscores at end
  end

  def get_unique_field_number(value)
    parts = value.split('_').select{|part| !part.blank?}
    if parts.size==1
      {value: value, number: 0}
    elsif parts.size==0
      return
    elsif parts[parts.size-1].to_i.to_s==parts[parts.size-1]
      {value: parts[0,parts.size-1].join('_'), number: parts[parts.size-1].to_i}
    else
      {value: parts.join('_'), number: 0}
    end
  end

  def process_unique_field(model,field,value,is_update)
    field_number = get_unique_field_number(value)
    return value unless field_number
    value_base = field_number[:value]
    current_number = field_number[:number]
    current_value = ''
    loop do
      if current_number.zero?
        current_value = value_base
      else
        current_value = "#{value_base}_#{current_number}"
      end
      break if (model.where(field=>current_value).count<=(is_update ? 1 : 0))
      current_number += 1
      return value if current_number >= 20
    end
    current_value
  end

  def transliterate cyrillic_string
    ru = { 'а' => 'a', 'б' => 'b', 'в' => 'v', 'г' => 'g', 'д' => 'd', \
    'е' => 'e', 'ё' => 'e', 'ж' => 'j', 'з' => 'z', 'и' => 'i', \
    'к' => 'k', 'л' => 'l', 'м' => 'm', 'н' => 'n', 'о' => 'o', \
    'п' => 'p', 'р' => 'r', 'с' => 's', 'т' => 't', 'у' => 'u', \
    'ф' => 'f', 'х' => 'h', 'ц' => 'c', 'ч' => 'ch', 'ш' => 'sh', \
    'щ' => 'shch', 'ы' => 'y', 'э' => 'e', 'ю' => 'u', 'я' => 'ya', \
    'й' => 'i', 'ъ' => '', 'ь' => ''}
    identifier = ''
    cyrillic_string.downcase.each_char do |char|
      identifier += ru[char] ? ru[char] : char
    end

    filter_text_for_url identifier
  end

  def video_details(details)
    key = russian_lower(details)
    if Video::DETAILS_DATA.include?(key)
      Video::DETAILS_DATA[key][:details]
    else
      []
    end
  end

  def video_details2(details)
    key = russian_lower(details)
    if Video::DETAILS_DATA.include?(key)
      Video::DETAILS_DATA[key][:details2]
    else
      []
    end
  end

  def small_string(string,size=25,points=3)
    string.size > size ? string[0,size-points]+'.'*points : string
  end

  def get_image(filename)
    if FileTest.exist?("#{Rails.public_path}#{filename}")
      filename
    else
      '404.jpg'
    end
  end

  def smallize(text,size)
    text = text.to_s
    text.size > size ? text[0,size-3]+'.'*3 : text
  end

  def serial_preview(title,genres)
    title = small_string(title,60)
    genre_string = genres.join(', ')
    if (title + genre_string).size > 90
      genre_string = genres[0,4].join(', ')+'...'
    end
    title + '<br>-------------<br>' + genre_string
  end

  def preview_chapter_title(title)
    title=='preview' ? '' : title
  end

  def special_page_link(object,method_name)
    unless object.send(method_name).blank?
      if request.fullpath =~ /page=\d+/
        link = request.fullpath.gsub(/page=\d+/,"page=#{object.send(method_name)}")
      elsif request.fullpath.include?('?')
        link = request.fullpath + "&page=#{object.send(method_name)}"
      else
        link = request.fullpath + "?page=#{object.send(method_name)}"
      end
      link.html_safe
    end
  end

  def providers
    {
        vkontakte: {title: 'Войти с VK',key:'vk'},
        facebook: {title: 'Войти с Facebook',key:'facebook'},
        google_oauth2: {title: 'Войти с Google',key:'google'},
        odnoklassniki: {title: 'Войти через Одноклассники',key:'odnoklassniki'},
        mail_ru: {title: 'Войти с Mail.ru',key:'openid'},
        yandex: {title: 'Войти с Yandex',key:'openid'},
    }
  end


  def show_sp_collection(sp_collection, limit)
    items = []
    filtered_items = []
    sp_collection.each_with_index do |sp,index|
      (index < limit ? items : filtered_items) << sp.song
    end
    text = ''
    items.each_with_index do |item,index|
      (text << ', ') unless index.zero?
      text << link_to(item.title,song_path(item.link))
    end
    text_filtered = ''
    filtered_items.each_with_index do |item,index|
      (text_filtered << ', ') unless index.zero?
      text_filtered << link_to(item.title,song_path(item.link))
    end
    unless text_filtered.blank?
      text << ", <a href='#' class='view-more' data-text='#{text_filtered}'> <i class='fa fa-chevron-down' aria-hidden='true'></i> </a>".html_safe
    end
    text.html_safe
  end

  def set_path(element)
    paths = %W[translator_path genre_path category_path director_path author_path studio_path]
    send(paths[element.elem_type],element.link)
  end

  def get_pass(object)
    if object.class==Serial
      serial_path(object.transliterated_link)
    elsif object.class==Chapter
      serial_episode_path(serial_id:object.serial.transliterated_link,id:object.chapter_id)
    elsif object.class==Review
      review_path(object.id)
    elsif object.class==New
      news_path(object.link)
    elsif object.class==ChapterLink
      return '#error' if object.chapter.blank? || object.chapter.serial.blank?
      serial_episode_path(serial_id:object.chapter.serial.transliterated_link,id:object.chapter.chapter_id)
    elsif object.class==Video
      return '#error' if object.serial.blank?
      serial_episode_path(serial_id:object.serial.transliterated_link,id:object.chapter_id)
    else
      send("#{object.class.to_s.downcase}_path",object.link)
    end
  end

  def prepare_link(text)
    transliterated_text = Translit.convert(text, :english)
    transliterated_text = transliterated_text.downcase.gsub(/ +/,'_').gsub(/[^\da-z_]/,'').gsub(/_+/,'_')
    if transliterated_text.start_with?('_')
      transliterated_text = transliterated_text[1,transliterated_text.size]
    end
    if transliterated_text.end_with?('_')
      transliterated_text = transliterated_text[0,transliterated_text.size-1]
    end
    transliterated_text
  end

  def successfully_created_notice(obj)
    if obj.is_applied?
      "#{obj.class::NAME} успешно создана"
    else
      "#{obj.class::NAME} создана и будет отображена после проверки модератором"
    end
  end

  def safe_link(link)
    bad_symbols = '<>"\'\\ '
    bad_symbols.split('').each do |symbol|
      link = link.gsub(symbol,'')
    end
    link
  end

  def get_seo_dynamic
    {
        search: {index: {}},
        serial: {
            show: {
                title: :_seo_title,
                length: :_seo_length,
            }
        },
        episode: {
            show: {
                title: :_seo_title,
                length: :_seo_length,
                link: :_seo_link,
            }
        }

    }
  end

  def fill_in_templates(text)
    return text unless get_seo_dynamic.include?(controller_name.to_sym)
    return text unless get_seo_dynamic[controller_name.to_sym].include?(action_name.to_sym)
    get_seo_dynamic[controller_name.to_sym][action_name.to_sym].each_pair do |key,method|
      next if @seo_obj.blank?
      search_key = "!#{key.to_s}!"
      next unless text.include?(search_key)
      next unless @seo_obj.methods.include?(method)
      value = @seo_obj.send(method).to_s
      text = text.gsub(search_key,value)
    end
    text
  end

  def get_seo_elem(key)
    domain = request.domain
    seo_block = get_seo_block(controller_name,action_name)
    return '' unless seo_block.include?(domain)
    return '' unless SeoItem::ALLOWED_TAGS.include?(key)
    seo_block[domain][key]
  end

  def get_seo_h1(fill_in = true)
    value = get_seo_elem(:h1)
    fill_in ? fill_in_templates(value) : value
  end

  def get_seo_title(fill_in = true)
    value = get_seo_elem(:title)
    fill_in ? fill_in_templates(value) : value
  end

  def get_seo_klass
    get_seo_elem(:class)
  end

  def get_seo_block(controller_name,action_name)
    return @seo_block unless @seo_block.blank?
    seo_block = {}
    SeoItem::ALLOWED_DOMAINS.each do |domain|
      seo_block[domain] = {}
      SeoItem::ALLOWED_TAGS.each do |tag|
        seo_block[domain][tag] = ''
      end
    end
    SeoItem.where(controller_name:controller_name, action_name: action_name).each do |si|
      if seo_block.include?(si.domain)
        seo_block[si.domain][:title] = si.title
        seo_block[si.domain][:h1] = si.h1
        seo_block[si.domain][:klass] = si.klass
      end
    end
    @seo_block = seo_block
  end

  def seo_title
    return '' if get_seo_dynamic.include?(controller_name.to_sym) && get_seo_dynamic[controller_name.to_sym].include?(action_name.to_sym)
    domain = request.domain
    if SeoItem::DOMAIN_TRANSLATE.include?(domain)
      "Аниме Культ точка #{SeoItem::DOMAIN_TRANSLATE[domain]} - "
    else
      ''
    end
  end

  def description_required?
    domain = request.domain.split('.')[-1].to_sym
    domain==SeoItem::MAIN_DOMAIN
  end

end
