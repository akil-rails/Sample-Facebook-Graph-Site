module ApplicationHelper
  def graph_url(path)
    "http://graph.facebook.com/#{path}"
  end

  def graph_picture_url(id)
    graph_url(id) + "/picture?type=large"
  end
end
