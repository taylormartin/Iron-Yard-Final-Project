module ApplicationHelper
  
  def flash_class name
    case name.to_sym
    when :notice
      :success
    when :alert
      :error
    else
      name
    end
  end

end
