module FilmsHelper
  def youtube_tag(youtube_id)
    content_tag(:iframe, nil, class: 'youtube', src: "//www.youtube.com/embed/#{youtube_id}?html5=1", frameborder: 0, allowfullscreen: true)
  end
end
