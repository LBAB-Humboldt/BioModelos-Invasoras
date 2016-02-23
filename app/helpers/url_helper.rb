module UrlHelper
  # To change this template use File | Settings | File Templates.
  def url_with_protocol(url)
    /^http/.match(url) ? url : "http://#{url}"
  end

end