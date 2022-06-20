class SeoItem < ApplicationRecord

  MAIN_DOMAIN = 'animecult.org'
  DOMAIN_TRANSLATE = {
      'animecult.me' => 'Ме',
      'animecult.ru' => 'Ру',
      'findanime.me' => 'Ме',
      'findanime.ru' => 'Ру',
  }
  ALLOWED_DOMAINS = ['animecult.me','animecult.org','animecult.ru','findanime.me','findanime.org','findanime.ru']
  ALLOWED_TAGS = [:title, :h1, :klass]

end
