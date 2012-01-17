# -*- encoding : utf-8 -*-
module ActivitiesHelper

  def start_date(datetime)
    if datetime
      return datetime.strftime("%d.%m.%Y")
    else
      return Time.now.strftime("%d.%m.%Y")
    end
  end

  def start_time(datetime)
    if datetime
      return datetime.strftime("%H:%M")
    else
      return Time.now.strftime("%H:%M")
    end
  end

  def end_date(datetime)
    if datetime
      return datetime.strftime("%d.%m.%Y")
    else
      return Time.now.strftime("%d.%m.%Y")
    end
  end

  def end_time(datetime)
    if datetime
      return datetime.strftime("%H:%M")
    else
      return Time.now.strftime("%H:%M")
    end
  end

  def help_text(title="", content="", help_icon="[?]")
    "<a data-placement='below' href='#' rel='popover' title='#{title}' data-content='#{content}'>#{help_icon}</a>".html_safe
  end

  def activity_image(activity)
    "<img src='#{activity.photo_thumb_url.blank? ? '/assets/default_photo.png'  : @activity.photo_thumb_url}' id='image_preview'>".html_safe
  end
end
