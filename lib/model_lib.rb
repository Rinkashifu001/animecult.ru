# TODO: move to models/concerns
class Model

  def self.changes_from_params(obj,params_hash)
    changes = {}
    params_hash.each_pair do |field,value|
      unless ([false,true].include?(obj.send(field)) ? [false,true].index(obj.send(field)) : obj.send(field)).to_s==value
        changes[field] = value
      end
    end
    changes
  end

  def self.process_save(obj,user,params_hash,covers)
    changes = Model.changes_from_params(obj,params_hash)

    if changes.blank? && covers.blank?
      return
    end

    covers.each do |cover|
      obj.attachments.create!(cover: cover, main_object: obj, is_applied: !user.only_could_revise?, user: user)
    end

    if user.only_could_revise?

      unless changes.blank?
        obj.assign_attributes(params_hash)
        return unless obj.valid?
        Revision.create(user_id: user.id,body:changes,correctable:obj)
      end

      'Изменения будут проверены модератором'
    else
      unless changes.blank?
        return unless obj.update(params_hash)
      end

      'Изменения были применены'
    end

  end

end
