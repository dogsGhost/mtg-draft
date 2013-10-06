(->
  'use strict'

  draft.CardView = Backbone.View.extend
    tagName: 'li'

    events:
      # When a user selects a card.
      'click img': 'addDraftedCard'

    template: _.template $('#cardTemplate').html()

    addDraftedCard: ->
      # Remove a card from each other booster in the round to simulate other drafters.
      draft.pickFromOtherPacks()

      # Increment pack number.
      draft.pickMade()

      # Remove @model
      draft.packs[draft.round - 1][draft.pack - 1].remove @model
      
      # Store the selected card.
      draft.draftedCards.add @model
      
      # Draft View will render next pack from listening to adds on draft.draftedCards.

    className: ->
      string = 'card'
      foil = @model.get 'is_foil'

      # Check if a foil card was added to the pack.
      if foil then string += ' card--foil'
      string

    render: ->
      # If its a foil we have to bind to the element because its pseudo element covers the image.
      if @$el.hasClass('card--foil') then @delegateEvents 'click': 'addDraftedCard'
      
      # Create the html for the model.
      m = @model.toJSON()
      m.img_src = draft.setName + '/' + m.img_src
      @$el.html @template m
      @

  return
)()