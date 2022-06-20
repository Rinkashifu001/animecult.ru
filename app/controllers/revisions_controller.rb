class RevisionsController < ApplicationController
  before_action :access_deny_if_could_not_moderate

  def show
    @revision = Revision.includes(:user,:correctable).find(params[:id])
    if @revision.correctable.is_a?(Serial) && @revision.content_type==Revision::CONTENT_TYPE_SERIAL_ELEMENTS
      elements = {}
      serial_elements_to_add = @revision.body['add']
      serial_elements_to_delete = @revision.body['delete']
      Element::TITLES.each_pair do |id,title|
        elements[id] = {title: title, values: []}
      end
      Element.all.each do |e|
        elements[e.elem_type][:values] << {elem: e, action: :add} if serial_elements_to_add.include?(e.id)
        elements[e.elem_type][:values] << {elem: e, action: :remove} if serial_elements_to_delete.include?(e.id)
      end
      @elements = elements

    elsif @revision.correctable.is_a?(Serial) && @revision.content_type==Revision::CONTENT_TYPE_SERIAL_SONGS
      songs = {}
      songs_to_add = @revision.body['add']
      songs_to_delete = @revision.body['delete']
      SongParticipate::SONG_RELATIONS.each_pair do |id,title|
        songs[id] = {title: title, values: []}
      end
      allowed_songs = {}
      Song.where(id: (songs_to_add + songs_to_delete).map{|pair| pair[0]}).each do |song|
        allowed_songs[song.id] = song
      end
      (songs_to_add + songs_to_delete).each do |pair|
        action = songs_to_add.include?(pair) ? :add : :remove
        song_id,relation_id = pair
        songs[relation_id][:values] << {song:allowed_songs[song_id], action: action} if allowed_songs.include?(song_id)
      end
      @songs = songs

    elsif @revision.correctable.is_a?(Serial) && @revision.content_type==Revision::CONTENT_TYPE_SERIAL_CHARACTERS
      characters = {}
      characters_to_add = @revision.body['add']
      characters_to_delete = @revision.body['delete']
      CharacterParticipate::CATEGORY_TITLES.each_pair do |category,dataset|
        characters[category] = {title: dataset[:single], values: []}
      end
      allowed_characters = {}
      Character.where(id: (characters_to_add + characters_to_delete).map{|pair| pair[0]}).each do |character|
        allowed_characters[character.id] = character
      end
      allowed_creators = {}
      Creator.where(id: (characters_to_add + characters_to_delete).map{|pair| pair[1]}).each do |creator|
        allowed_creators[creator.id] = creator
      end
      (characters_to_add + characters_to_delete).each do |character_id,creator_id,category|
        action = characters_to_add.include?([character_id,creator_id,category]) ? :add : :remove
        if allowed_creators.include?(creator_id) && allowed_characters.include?(character_id)
          characters[category][:values] << {character: allowed_characters[character_id],creator: allowed_creators[creator_id], action: action}
        end
      end
      @characters = characters

    elsif @revision.correctable.is_a?(Serial) && @revision.content_type==Revision::CONTENT_TYPE_SERIAL_CREATORS
      creators = []
      creators_to_add = @revision.body['add']
      creators_to_delete = @revision.body['delete']
      allowed_creators = {}
      Creator.where(id: (creators_to_add + creators_to_delete).map{|pair| pair[0]}).each do |creator|
        allowed_creators[creator.id] = creator
      end
      allowed_credits = {}
      Credit.where(id: (creators_to_add + creators_to_delete).map{|pair| pair[1]}).each do |credit|
        allowed_credits[credit.id] = credit
      end
      (creators_to_add + creators_to_delete).each do |creator_id,credit_id|
        action = creators_to_add.include?([creator_id,credit_id]) ? :add : :remove
        if allowed_creators.include?(creator_id) && allowed_credits.include?(credit_id)
          creators << {creator: allowed_creators[creator_id], credit: allowed_credits[credit_id], action: action}
        end
      end
      @creators = creators

    elsif @revision.correctable.is_a?(Song) && @revision.content_type==Revision::CONTENT_TYPE_SONG_STUFFS
      stuff = []
      stuff_to_add = @revision.body['add']
      stuff_to_delete = @revision.body['delete']
      allowed_creators = {}
      Creator.where(id: (stuff_to_add + stuff_to_delete).map{|pair| pair[0]}).each do |creator|
        allowed_creators[creator.id] = creator
      end
      allowed_credits = {}
      Credit.where(id: (stuff_to_add + stuff_to_delete).map{|pair| pair[1]}).each do |credit|
        allowed_credits[credit.id] = credit
      end
      (stuff_to_add + stuff_to_delete).each do |creator_id,credit_id|
        action = stuff_to_add.include?([creator_id,credit_id]) ? :add : :remove
        if allowed_creators.include?(creator_id) && allowed_credits.include?(credit_id)
          stuff << {creator: allowed_creators[creator_id], credit: allowed_credits[credit_id], action: action}
        end
      end
      @stuff = stuff
    end
  end

  def do_cancel
    @revision = Revision.find(params[:id])
    @revision.is_cancelled = true
    @revision.save
    Notification.create(correctable:@revision.correctable,user:@revision.user,title:Notification::TITLE_CHANGES_CANCELLED)
    redirect_to revisions_moderate_index_path
  end

  def do_apply
    @revision = Revision.find(params[:id])
    @revision.do_apply
    @revision.is_applied = true
    @revision.save
    Notification.create(correctable:@revision.correctable,user:@revision.user,title:Notification::TITLE_CHANGES_APPROVED)
    redirect_to revisions_moderate_index_path
  end

end
