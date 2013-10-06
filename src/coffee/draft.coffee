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
    draft.use_timer = !!parseInt $('#timerOption').find('input:checked').val(), 10

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

  pickFromOtherPacks: ->
    # Simulates other players in the draft.
    roundPacks = draft.packs[draft.round - 1]    
    curPackIndex = draft.pack - 1

    # Loop through the packs used in this round.
    for pack, index in roundPacks
      # Make sure we skip the pack the user picked from.
      if index isnt curPackIndex
        ran = magic.getRandomInt 1, 100
        m = pack.where rarity: 'M'
        r = pack.where rarity: 'R'
        u = pack.where rarity: 'U'
        c = pack.where rarity: 'C'
        l = pack.where rarity: 'L'
        # Chance to skip rare in first 3 picks, otherwise pick the rare.
        if (draft.pick < 4 and ran < 89 and (m.length or r.length)) or
        (draft.pick >= 4 and (m.length or r.length))
          # In case there's more than one in the pack, randomly pick one then remove it.
          if m.length
            ran = magic.getRandomInt 0, m.length - 1
            pack.remove pack.get(m[ran].id)
          else
            ran = magic.getRandomInt 0, r.length - 1
            pack.remove pack.get(r[ran].id)
        
        # If not picking rare, move on to uncommons.
        # 50% chance to pick uncommon if there are any or if its late in the round force pick.
        else if (ran < 51 and u.length) or (draft.pick > 8 and u.length)
          ran = magic.getRandomInt 1, 100
          ran = magic.getRandomInt 0, u.length - 1
          pack.remove pack.get(u[ran].id)

        # If not picking uncommon, move on the commons.
        else if c.length
          ran = magic.getRandomInt 0, c.length - 1
          pack.remove pack.get(c[ran].id)
        
        # If nothing else, pick a land.
        else if l.length
          ran = magic.getRandomInt 0, l.length - 1
          pack.remove pack.get(l[ran].id)
        
        # Do something when there are no more cards to pick.
    return 