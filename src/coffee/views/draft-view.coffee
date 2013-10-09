(($) ->
  'use strict'

  draft.DraftView = Backbone.View.extend
    # Use container already in html.
    el: '#mainContent'

    initialize: ->
      @listenTo draft.draftedCards, 'add', @renderNext
      @render()

    # Main template of a draft view.
    template: _.template $('#draftTemplate').html()

    # Template to show round/pack/pick of draft user is currently on.
    progressTemplate: _.template $('#draftProgressTemplate').html()

    # Timer for each pick.
    timerTemplate: _.template $('#timerTemplate').html()

    # Template to show total cards / # creatures in user's drafted pool.
    infoTemplate: _.template $('#draftedInfoTemplate').html()

    # Delegated events.
    events:
      'click #collectionNav a': 'toggleContent'
      ###
      ISSUE: Look into refactoring with Modernizr to cover prefixes.
      ###
      'webkitAnimationEnd #timer .second': 'timerEnd'
      'animationend #timer .second': 'timerEnd'

    firstRender: true

    timerEnd: ->
      # If the timer runs out, we choose the first card in the pack for the user.
      pack = draft.packs[draft.round - 1][draft.pack - 1]
      card = pack.models[0]

      # Remove a card from each other booster in the round to simulate other drafters.
      draft.pickFromOtherPacks()

      # Remove the card we're adding from its pack.
      pack.remove pack.get card.get card

      # Increment pack number.
      draft.pickMade()

      # If the timer runs out, add the first card in the pack to draftedCards.      
      # This triggers renderNext, showing the next pack.
      draft.draftedCards.add card

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
      # Insert html on page.
      @$el.html @template()

      # Set varaibles.
      @$bp = @$ '#boosterPack'
      @$dp = @$ '#draftProgress'
      @$di = @$ '#draftedInfo'
      @$dcl = @$('#draftedCards').find '.drafted-cards__list'
      @$timer = @$ '#timer'

      # Insert html nested inside this view.
      @renderChildViews()

      # Set firstRender to false for use when refreshing data.
      @firstRender = false

    renderChildViews: ->
      # Insert draft metadata onto page. 
      @renderStats()

      # Insert cards into html we just rendered.
      @renderPack()

      # Render new timer only if first time rendering or if we're using a timer.
      if @firstRender or (not @firstRender and draft.use_timer)
        @$timer.html @timerTemplate use_timer: draft.use_timer

      # Add mtg branding to help fill negative space as the number of cards on the page decreases.
      @$('#boosterPack').append '<li class="card branding"><img src="img/branding/pwsymbol.png" alt=""></li>'

    renderStats: ->
      progress = 
        round: draft.round
        pack: draft.pack
        pick: draft.pick

      info =
        drafted_total: draft.draftedCards.length
        creature_count: draft.draftedCards.where(is_creature: true).length

      @$('#draftProgress').html @progressTemplate progress

      @$('#draftedInfo').html @infoTemplate info

    renderPack: ->
      @$('#boosterPack').empty()
      pack = draft.packs[draft.round - 1][draft.pack - 1]
      _.each pack.models, @renderPackCard

    renderPackCard: (card, index, list) ->
      cardView = new draft.CardView model: card
      $('#boosterPack').append cardView.render().el

    renderNext: (card) ->
      if draft.pick isnt 15
        # Update draft data and render next booster pack.
        @renderChildViews()
        # Render new drafted card.
        cardView = new draft.CardView model: card
        @$dcl.append cardView.render().el
      else
        # If its the last pick in the round we want to render the between-round view instead.
        new draft.PostRoundView()

) jQuery