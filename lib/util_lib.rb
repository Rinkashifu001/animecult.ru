class Util

  def self.transfer_images_from_anidb
    (Character.order(:title) + Creator.order(:title)).each do |object|
      unless object.image_path.blank?
        File.open(File.join(Rails.root,'public',object.image_path)) do |f|
          Attachment.create(main_object: object, is_applied: true, cover: f)
        end
      end
    end
  end

  def self.transfer_images_from_image_eleme
    ImageElem.all. each do |ie|
      Attachment.create(main_object_type: 'Review', main_object_id: ie.review_id,is_applied: true, cover: ie.image[0].file)
    end
  end

  def self.transfer_images_for_serials
    Serial.order(:id).each do |serial|
      unless serial.total_images.zero?
        serial.total_images.times do |i|
          filename = File.join(Rails.root,'public',"/images/#{serial.id}_#{i+1}_wm.jpg")
          if File.exist?(filename)
            File.open(filename) do |f|
              Attachment.create(main_object: serial, is_applied: false, cover: f)
            end
          end
        end
      end
    end
  end

end