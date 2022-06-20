class Serial < ApplicationRecord
  NAME = 'Аниме'
  ENDING_LIMIT = 3
  OPENING_LIMIT = 3
  OST_LIMIT = 3
  EDITABLE_FIELDS = {
    transliterated_link: 'Ссылка',
    title: 'Название',
    english_title: 'Английское название',
    original_title: 'Оригинальное название',
    aka: 'Прочие названия',
    description: 'Описание',
    release: 'Год выпуска',
    full_length: 'Полнометражное',
    adult: 'Для взрослых'
  }.freeze

  rating
  acts_as_favoritable
  acts_as_commontable dependent: :destroy

  belongs_to :account, optional: true
  belongs_to :user, optional: true

  has_many :chapters
  has_many :videos
  has_many :serial_elements
  has_many :serial_images
  has_many :translates
  has_many :reviews
  has_many :attachments, as: :main_object
  has_many :character_participates
  has_many :creator_participates
  has_many :song_participates
  has_many :resources
  has_many :shikimori_resources
  has_many :revisions, as: :correctable

  has_and_belongs_to_many :translators
  has_and_belongs_to_many :associated,
                          class_name: 'Serial',
                          join_table: 'associated_serials',
                          association_foreign_key: 'associated_id'

  validates :title, presence: true
  validates :release, numericality: { only_integer: true, greater_than_or_equal_to: 0, less_than_or_equal_to: 2050,
                                      message: 'Год выпуска должен быть целым числом: "%<value>s"' }
  validates :transliterated_link,
            uniqueness: { message: 'Значение атрибута "Ссылка" должно быть уникально: "%<value>s"' },
            format: { with: /\A[\_a-z0-9\/]+\z/,
                      message: 'Ссылка должна состоять из латинских букв, цифр и подчеркиваний: %<value>s' }

  scope :anime_list, ->{ includes(:attachments, serial_elements: :element).where(is_cancelled: false, is_applied: true).order(title: :asc) }

  def other_titles
    [english_title, original_title, aka].join(' | ')
  end

  def clear_link
    transliterated_link
  end

  def translate
    @translate ||= translates.where(selected: true).first
  end

  def _seo_title
    [title,english_title,original_title].select{|t| !blank?}.uniq.join(' | ')
  end

  def _seo_length
    full_length ? 'фильм' : 'сериал'
  end

  def seo_title
    result = "Аниме "
    result << (full_length ? 'фильм' : 'сериал')
    result << " #{title}" unless title.blank?
    result << " | #{english_title}" if !english_title.blank? && title!=english_title
    result << " | #{original_title}" if !original_title.blank? && original_title!=english_title && original_title!=title
    result
  end

  def seo_title_characters
    result = "Все персонажи аниме "
    result << " #{title}" unless title.blank?
    result << " | #{english_title}" if !english_title.blank? && title!=english_title
    result << " | #{original_title}" if !original_title.blank? && original_title!=english_title && original_title!=title
    result
  end

  def seo_title_creators
    result = "Все создатели аниме "
    result << " #{title}" unless title.blank?
    result << " | #{english_title}" if !english_title.blank? && title!=english_title
    result << " | #{original_title}" if !original_title.blank? && original_title!=english_title && original_title!=title
    result
  end

  def seo_title_songs
    result = "Песни и Музыка аниме "
    result << " #{title}" unless title.blank?
    result << " | #{english_title}" if !english_title.blank? && title!=english_title
    result << " | #{original_title}" if !original_title.blank? && original_title!=english_title && original_title!=title
    result
  end

  def elements_by_elem_type
    return @elements_by_elem_type unless @elements_by_elem_type.blank?
    @elements_by_elem_type = {}
    Element::TITLES.each_pair do |elem_type,title|
      @elements_by_elem_type[elem_type] = []
    end
    serial_elements.each do |se|
      if !se.element.is_cancelled? && se.element.is_applied?
        @elements_by_elem_type[se.element.elem_type] << se.element
      end
    end
    @elements_by_elem_type
  end

  def songs_by_relation_type
    return @songs_by_song_type unless @songs_by_song_type.blank?
    @songs_by_song_type = {}
    SongParticipate::SONG_RELATIONS.each_pair do |relation_id,title|
      @songs_by_song_type[relation_id] = []
    end
    song_participates.each do |sp|
      @songs_by_song_type[sp.relation_id] << sp.song
    end
    @songs_by_song_type
  end

  def characters_by_category
    return @characters_by_category unless @characters_by_category.blank?
    @characters_by_category = {}
    CharacterParticipate::CATEGORY_TITLES.each_pair do |category,dataset|
      @characters_by_category[category] = []
    end
    character_participates.each do |cp|
      @characters_by_category[cp.category] << {character: cp.character, creator: cp.creator}
    end
    @characters_by_category
  end

  def seo_description
    result = "Аниме "
    result << (full_length ? ' фильм' : 'сериал')
    result << " #{title}" unless title.blank?
    result << " | #{english_title}" if !english_title.blank? && title!=english_title
    result << " | #{original_title}" if !original_title.blank? && original_title!=english_title && original_title!=title
    genres = elements_by_elem_type[Element::GENRE_ID].map(&:title).join(', ')
    result << " в жанре: #{genres}" unless genres.blank?
    result << '. Вы можете узнать всю информацию об этом аниме:'
    result << " дата выхода: #{release}," unless release.blank?
    result << ' где его можно посмотреть бесплатно и онлайн, с цензурой или без цензуры, какие в этом аниме персонажи'
    authors = elements_by_elem_type[Element::AUTHOR_ID].map(&:title).join(', ')
    result << ", кто является создателем: #{authors}" unless authors.blank?
    studios = elements_by_elem_type[Element::STUDIO_ID].map(&:title).join(', ')
    result << ", студии: #{studios}" unless studios.blank?
    directors = elements_by_elem_type[Element::DIRECTOR_ID].map(&:title).join(', ')
    result << ", режиссеры: #{directors}" unless directors.blank?

    opening = song_participates.filter{|sp| sp.relation_id==SongParticipate::OPENING_ID}
    unless opening.blank?
      opening_song = opening[0].song
      opening_author = opening_song.song_stuffs.filter{|ss| !ss.creator.blank? && !ss.credit.blank? && ss.credit.title=='Vocals/Performed by'}.map{|ss| ss.creator.title}.join(', ')
      result << ", кто исполняет опенинг: #{opening_song.title}"
      result << " - #{opening_author}" unless opening_author.blank?
    end

    ending = song_participates.filter{|sp| sp.relation_id==SongParticipate::ENDING_ID}
    unless ending.blank?
      ending_song = ending[0].song
      ending_author = ending_song.song_stuffs.select{|ss| !ss.creator.blank? && !ss.credit.blank? && ss.credit.title=='Vocals/Performed by'}.map{|ss| ss.creator.title}.join(', ')
      result << ", кто исполняет эндинг: #{ending_song.title}"
      result << " - #{ending_author}" unless ending_author.blank?
    end
    result << '. И многое другое.'
    result
  end

  def movie_type
    full_length ? ' Фильм' : 'Сериал'
  end

  def total_css
    [12,13].include?(total) ? 'type4' : [24,25,26].include?(total) ? 'type3' : total > 26 ? 'type1' : ((2..11).include?(total) ? 'type6' : '')
  end

  def small_title(length=30)
    title.size > length ? title[0,length-3]+'.'*3 : title
  end

  def show_aka
    divider = ' / '
    limit = 100
    values = aka.split(divider)
    values_passed = []
    values_filtered = []

    values.each do |value|
      text = values_passed.join(divider)
      if text.size < limit
        values_passed << value
      else
        values_filtered << value
      end
    end

    result = values_passed.join(divider)
    unless values_filtered.blank?
      filtered_text = values_filtered.map{|value| "#{divider}#{value}"}.join('')
      result += "<a href='#' class='view-more' data-text='#{filtered_text}'> <i class='fa fa-chevron-down' aria-hidden='true'></i> </a>"
    end
    result
  end

  def preview_text_old
    genres = serial_elements.map{|se| se.element}.select{|e| e.elem_type==1}.map(&:title)
    small_title = title.size > 60 ? title[0,60-3]+'.'*3 : title
    genre_string = genres.join(', ')
    if (small_title + genre_string).size > 90
      genre_string = genres[0,4].join(', ')+'...'
    end
    small_title + '<br>-------------<br>' + genre_string
  end

  def genres_string
    serial_elements.map{|se| se.element}.select{|e| e.elem_type==1}.map(&:title).join(', ')
  end

  def category_string
    serial_elements.map{|se| se.element}.select{|e| e.elem_type==2}.map(&:title).join(', ')
  end

  def total_cached_text
    s = total.to_s
    if s.end_with?('1')
      "#{total} эпизод"
    elsif s.end_with?('12') || s.end_with?('13') || s.end_with?('44')
      "#{total} эпизодов"
    elsif s.end_with?('2') || s.end_with?('3') || s.end_with?('4')
      "#{total} эпизода"
    else
      "#{total} эпизодов"
    end
  end

  def character_participates_by_category
    result = {}
   character_participates.each do |cp|
      if result[cp.category].blank?
        result[cp.category] = []
      end
      result[cp.category] << cp
    end
    result
  end

  def endings
    song_participates.filter{ |sp| sp.relation_id==SongParticipate::ENDING_ID }
  end

  def openings
    song_participates.filter{ |sp| sp.relation_id==SongParticipate::OPENING_ID }
  end

  def ost
    song_participates.filter{ |sp| ![SongParticipate::OPENING_ID, SongParticipate::ENDING_ID].include? sp.relation_id }
  end

  def process_save(user,params_hash,elements_params,songs_params,characters_params,creators_params,covers)
    changes = Model.changes_from_params(self,params_hash)
    elements_current = serial_elements.map{|se|se.element_id}.sort
    songs_current = song_participates.map{|sp| [sp.song_id,sp.relation_id]}.sort
    characters_current = character_participates.map{|cp| [cp.character_id,cp.creator_id,cp.category]}.sort
    creators_current = creator_participates.map{|cp| [cp.creator_id,cp.credit_id]}.sort

    if changes.blank? && elements_current==elements_params && covers.blank? && songs_current==songs_params && characters_current==characters_params && creators_current==creators_params
      return
    end

    covers.each do |cover|
      attachments.create!(cover: cover, main_object: self, is_applied: !user.only_could_revise?, user: user)
    end

    if user.only_could_revise?

      unless elements_current==elements_params
        elements_to_delete = elements_current - elements_params
        elements_to_add = elements_params - elements_current
        revision_body = {add: elements_to_add, delete: elements_to_delete}
        Revision.create(user_id: user.id,body:revision_body,correctable:self,content_type:Revision::CONTENT_TYPE_SERIAL_ELEMENTS)
      end

      unless songs_current==songs_params
        songs_to_delete = songs_current - songs_params
        songs_to_add = songs_params - songs_current
        revision_body = {add: songs_to_add, delete: songs_to_delete}
        Revision.create(user_id: user.id,body:revision_body,correctable:self,content_type:Revision::CONTENT_TYPE_SERIAL_SONGS)
      end

      unless characters_current==characters_params
        characters_to_delete = characters_current - characters_params
        characters_to_add = characters_params - characters_current
        revision_body = {add: characters_to_add, delete: characters_to_delete}
        Revision.create(user_id: user.id,body:revision_body,correctable:self,content_type:Revision::CONTENT_TYPE_SERIAL_CHARACTERS)
      end

      unless creators_current==creators_params
        creators_to_delete = creators_current - creators_params
        creators_to_add = creators_params - creators_current
        revision_body = {add: creators_to_add, delete: creators_to_delete}
        Revision.create(user_id: user.id,body:revision_body,correctable:self,content_type:Revision::CONTENT_TYPE_SERIAL_CREATORS)
      end

      unless changes.blank?
        original_link = transliterated_link
        assign_attributes(params_hash)
        return unless valid?
        Revision.create(user_id: user.id,body:changes,correctable:self)
        self.transliterated_link = original_link
      end

      'Изменения будут проверены модератором'
    else

      unless changes.blank?
        if update(params_hash)
          update_attribute(:is_locked, true)
        else
          return
        end
      end

      unless elements_current==elements_params
        SerialElement.where(serial_id:id).delete_all
        elements_params.each{|element_id| SerialElement.create(serial_id:id,element_id:element_id)}
        update_attribute(:elements_are_locked, true)
      end

      unless songs_current==songs_params
        SongParticipate.where(serial_id:id).delete_all
        songs_params.each{|song_id,relation_id| SongParticipate.create(serial_id:id, song_id: song_id, relation_id: relation_id)}
      end

      unless characters_current==characters_params
        CharacterParticipate.where(serial_id:id).delete_all
        characters_params.each{|character_id,creator_id,category| CharacterParticipate.create(serial_id:id,character_id:character_id,creator_id:creator_id,category:category)}
      end

      unless creators_current==creators_params
        CreatorParticipate.where(serial_id:id).delete_all
        creators_params.each{|creator_id,credit_id| CreatorParticipate.create(serial_id:id,creator_id:creator_id,credit_id:credit_id)}
      end

      'Изменения были применены'
    end
  end

  def show_title
    title
  end
end

# == Schema Information
#
# Table name: serials
#
#  id                           :integer          not null, primary key
#  adult                        :boolean          default(FALSE)
#  aka                          :string(4096)
#  anidb_aka                    :string
#  anidb_description            :text
#  anidb_description_translated :string
#  description                  :string(8150)
#  description2                 :text
#  description_original         :string
#  duration                     :integer
#  elements_are_locked          :boolean          default(FALSE)
#  english_title                :string(255)
#  full_length                  :boolean          default(FALSE)
#  is_applied                   :boolean          default(TRUE)
#  is_cancelled                 :boolean          default(FALSE)
#  is_locked                    :boolean          default(FALSE)
#  link                         :string(255)
#  original_title               :string(255)
#  release                      :integer
#  title                        :string(255)
#  total                        :integer          default(0)
#  total_cached                 :integer
#  total_frames                 :integer
#  total_images                 :integer
#  transliterated_link          :string(255)
#  video_date                   :datetime
#  visited_at                   :integer
#  account_id                   :integer
#  anidb_id                     :integer
#  user_id                      :bigint
#
# Indexes
#
#  index_serials_on_account_id              (account_id)
#  index_serials_on_release                 (release)
#  index_serials_on_user_id                 (user_id)
#  index_serials_on_video_date_and_release  (video_date,release)
#  index_serials_on_visited_at              (visited_at)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
