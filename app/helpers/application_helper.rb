module ApplicationHelper
  def error_messages_for(object)
    render 'error_messages_for', object: object
  end

  def copyright_years
    start = 2016
    finish = Date.today.year
    "© #{start == finish ? start : "#{start} — #{finish}"}"
  end

end
