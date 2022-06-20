module RevisionsHelper

  def show_revision_value(value,field=nil)
    if field.nil?
      value
    elsif [false,true].include?(field)
      [true,'1'].include?(value) ? 'Да' : 'Нет'
    else value
    end
  end

end
