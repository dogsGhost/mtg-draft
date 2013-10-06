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
      @listenTo draft.draftedCards, 'add', @renderDraftedCard
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
      $( $parent.siblings().find('a').attr('href') ).hide()
      $( $tar.attr('href') ).show()
    
    render: ->
      content = 
        round: draft.round
        pack: draft.pack
        pick: draft.pick
        use_timer: draft.use_timer
        drafted_total: draft.draftedCards.length
        creature_count: draft.draftedCards.where(is_creature: true).length

      # Insert html on page.
      @$el.html @template content

      # Insert cards into html we just added.
      @renderPack()
      @renderDrafted()
      @$('#boosterPack').append '<li class="card branding"><img src="img/branding/pwsymbol.png" alt=""></li>'

    renderPack: ->
      @$('#boosterPack').empty()
      pack = draft.packs[draft.round - 1][draft.pack - 1]
      _.each pack.models, @renderPackCard

    renderPackCard: (card, index, list) ->
      cardView = new draft.CardView model: card
      $('#boosterPack').append cardView.render().el

    renderDrafted: ->
      pack = draft.draftedCards
      _.each pack.models, @renderDraftedCard

    renderDraftedCard: (card, index, list) ->
      cardView = new draft.CardView model: card
      $('#draftedCards .drafted-cards__list').append cardView.render().el

) jQuery