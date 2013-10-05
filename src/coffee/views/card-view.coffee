(->
  'use strict'

  draft.CardView = Backbone.View.extend
    tagName: 'li'

    events:
      # When a user selects a card.
      'click img': 'storeCard'

    storeCard: ->
      # Store the selected card.
      draft.draftedCards.add @model
      
      # Remove @model

      # Remove a card from each other booster in the round to simulate other drafters.

      # Increment pack number.
      draft.pickMade()
      # render next pack.
      draft.outputList()

    className: ->
      string = 'card'
      foil = @model.get 'is_foil'

      # Check if a foil card was added to the pack.
      if foil then string += ' card--foil'
      string

    template: _.template $('#cardTemplate').html()

    render: ->
      m = @model.toJSON()
      m.img_src = draft.setName + '/' + m.img_src
      @$el.html @template m
      @

  return
)()