draft =
  startDraft: (name) ->
    # Store the name of the set we're drafting.
    draft.setName = name

    # Fetch the json data for that set.
    $.getJSON "json/#{draft.setName}.json", draft.createPacks

  createPacks: (data) ->
    # Store all the cards.
    draft.cardSet = data
    # This stores 3 arrays, 1 for each round, those arrays contain the Collections.
    draft.packs = []
    draft.setStats()

    # There are 3 round in the draft, each using 8 packs.
    i  = 3
    while i--
      # Create array to store the packs for a round.
      oneRoundOfPacks = []
      j = 8
      while j--
        # Create booster and add them to array for holding one round of packs.
        oneRoundOfPacks.push magic.createBooster()
      
      draft.packs.push oneRoundOfPacks

    # Start the draft.
    new draft.DraftView()

  pickMade: ->
    # Increment stats accordingly.
    # If its the last pick in a round.
    if @pick is 15 then @round += 1

    # If its the last pack of a round cycle back to 1.
    if @pack < 8 then @pack += 1 else @pack = 1
    
    # If its the last pick, reset count.
    if @pick < 15 then @pick += 1 else @pick = 1

  setStats: ->
    @draftedCards = draft.cardsCollection()
    @round = 1
    @pack = 1
    @pick = 1