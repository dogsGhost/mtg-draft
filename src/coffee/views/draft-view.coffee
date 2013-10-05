(($) ->
  'use strict'

  draft.DraftView = Backbone.View.extend
    # Use container already in html.
    el: '#mainContent'

    # Template of all the elements of a draft view.
    template: _.template $('#draftTemplate').html()

    # Delegated events.
    events:
      'click #collectionNav a': 'toggleContent'

    initialize: ->
      @listenTo draft.draftedCards, 'add', @addDrafted
      @render()

    toggleContent: (e) ->
      e.preventDefault()
      # Reference to the element clicked.
      $tar = $ e.currentTarget
      $parent = $tar.parent()

      # Do nothing if this is already the active tab.
      if $parent.hasClass('active') then return

      # Remove sibling 'active' class, add to this element's parent.
      $parent
        .siblings()
          .removeClass('active')
          .end()
        .addClass 'active'

      # Hide other cotent, show new content.
      $($parent.siblings().find('a').attr('href')).hide()
      $($tar.attr('href')).show()
    
    render: ->
      content = 
        round: draft.round
        pack: draft.pack
        pick: draft.pick
        drafted_total: draft.draftedCards.length
        creature_count: draft.draftedCards.where(is_creature: true).length

      ###
      Should we insrt the cards at this point by nesting views?
      ie. calling render for our card models and passing the output into this view template?
      ###

      # Insert html on page.
      @$el.html @template content
      # Insert cards into html we just added.
      @renderPack()
      @$('#boosterPack').append '<li class="card branding"><img src="img/branding/pwsymbol.png" alt=""></li>'
      @renderDraftedCards()

    renderPack: ->
      pack = draft.packs[draft.round - 1][draft.pack - 1]
      _.each pack.models, @renderCard

    renderDraftedCards: ->

    renderCard: (card, index, list) ->
      cardView = new draft.CardView model: card
      $('#boosterPack').append cardView.render().el

    addDrafted: ->

) jQuery