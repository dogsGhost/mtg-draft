(->
  'use strict'

  draft.Card = Backbone.Model.extend
    defaults:
      card_name: 'Unknown'
      color: 'none',
      img_src: 'img/branding/card-back.jpg'

)()