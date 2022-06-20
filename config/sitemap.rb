# Change this to your host. See the readme at https://github.com/lassebunk/dynamic_sitemaps
# for examples of multiple hosts and folders.
host 'https://animecult.org'

sitemap :site do
  url root_url, last_mod: Time.now, change_freq: "daily", priority: 1.0


  url anime_list_index_url

  url genre_index_url
  Element.by_elem_type(Element::GENRE_ID).each do |genre|
    url genre_url(genre.element_link)
  end

  url category_index_url
  Element.by_elem_type(Element::CATEGORY_ID).each do |category|
    url category_url(category.element_link)
  end

  url director_index_url
  Element.by_elem_type(Element::DIRECTOR_ID).each do |director|
    url director_url(director.element_link)
  end

  url author_index_url
  Element.by_elem_type(Element::AUTHOR_ID).each do |author|
    url author_url(author.element_link)
  end

  url studio_index_url
  Element.by_elem_type(Element::STUDIO_ID).each do |studio|
    url studio_url(studio.element_link)
  end

  Serial.order(:title).each do |serial|
    url serial_url(serial.transliterated_link)
  end

  url review_index_url
  Review.where(is_cancelled: false, is_applied: true).includes(:serial,:attachments).order('created_at desc').each do |review|
    url review_url(review)
  end

  url news_index_url
  New.where(is_cancelled: false, is_applied: true).includes(:attachments).order('created_at desc').each do |review|
    url news_url(review.link)
  end
end

# You can have multiple sitemaps like the above – just make sure their names are different.

# Automatically link to all pages using the routes specified
# using "resources :pages" in config/routes.rb. This will also
# automatically set <lastmod> to the date and time in page.updated_at:
#
#   sitemap_for Page.scoped

# For products with special sitemap name and priority, and link to comments:
#
#   sitemap_for Product.published, name: :published_products do |product|
#     url product, last_mod: product.updated_at, priority: (product.featured? ? 1.0 : 0.7)
#     url product_comments_url(product)
#   end

# If you want to generate multiple sitemaps in different folders (for example if you have
# more than one domain, you can specify a folder before the sitemap definitions:
# 
#   Site.all.each do |site|
#     folder "sitemaps/#{site.domain}"
#     host site.domain
#     
#     sitemap :site do
#       url root_url
#     end
# 
#     sitemap_for site.products.scoped
#   end

# Ping search engines after sitemap generation:
#
ping_with "https://#{host}/sitemap.xml"