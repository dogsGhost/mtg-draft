(->
  'use strict'

  CardsCollection = Backbone.Collection.extend
    model : draft.Card    

  draft.cardsCollection = ->
    new CardsCollection()

)()