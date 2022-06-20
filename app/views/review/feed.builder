xml.instruct!
xml.rss version: '2.0', 'xmlns:atom' => 'http://www.w3.org/2005/Atom' do

  xml.channel do
    xml.title 'Обзоры и Рецензии на аниме'
    xml.description 'Обзоры и рецензии на аниме от пользователей Анимекульта.'
    xml.link root_url
    xml.language 'ru'
    xml.tag! 'atom:link', rel: 'self', type: 'application/rss+xml', href: 'home/rss'

    for new in @news
      xml.item do
        xml.title new.title
        xml.link news_url(new.link)
        unless new.attachments.blank?
          xml.enclosure url: "#{request.ssl? ? 'https' : 'http'}://#{request.domain}#{new.attachments.first.cover_url}",type:'image/jpeg'
        end
        xml.pubDate(new.created_at.rfc2822)
        xml.guid news_url(new.link)
        xml.description do
          xml.cdata! new.descr_short
        end
        xml.content strip_tags (new.descr_full)
      end
    end

    for review in @reviews
      xml.item do
        xml.title review.title
        xml.link review_url(review.id)
        unless review.attachments.blank?
          xml.enclosure url: "#{request.ssl? ? 'https' : 'http'}://#{request.domain}#{review.attachments.first.cover_url}",type:'image/jpeg'
         end
        xml.pubDate(review.created_at.rfc2822)
        xml.guid review_url(review)
        xml.description do
          xml.cdata! review.descr_short
        end
        xml.content strip_tags (review.descr_full)
      end
    end

  end

end