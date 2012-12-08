# encoding: UTF-8
module ApplicationHelper
  def width
    800
  end

  def align
    "left"
  end

  def title
    "#{@title} #{(Rails.env == "development" ? "ん゛開発ゔゔううぅぅぅ！！！！" : nil)}"
  end

  def login(param = nil)
    param.to_s
  end

  def serie_to_amazon_url(serie)
    serie= serie.books.order("publicationdate DESC").first
    serie && serie.detailurl ? serie.detailurl.gsub(/mantropy\-22/, "kumantropy-22") : "/"
  end
end
