# The magic object deals specifically with the functionality behind creating a
# random pack of 15 cards from a set.

magic = {}

magic.createBooster = ->
  # We need 15 random cards from the card set, adhering to the normal makeup
  # of a booster pack regarding distribution of card rarity.
  
  # Each booster is a Backbone Collection, with each card in the booster being
  # the Model.
  booster = draft.cardsCollection()

  # Randomize the order of the cards we're pulling from.
  for rarity of draft.cardSet
    @shuffle draft.cardSet[rarity]

  # 1 LAND
  # Add 1 land to the pack.
  ran = @getRandomInt 0, draft.cardSet.land.length - 1
  booster.add draft.cardSet.land[ran]

  # 1 RARE
  booster.add @addRare()

  # 3 UNCOMMON
  # Start at a random card.
  ran = @getRandomInt 2, draft.cardSet.uncommon.length - 1
  i = ran
  while i > ran - 3
    # Add card to booster.
    booster.add draft.cardSet.uncommon[i]
    i--

  # 10 COMMON
  ###
  ISSUE: sometimes getting 9 commons instead of 10, thinking the issue is here somewhere.
  ###
  ran = @getRandomInt 9, draft.cardSet.common.length - 1
  i = ran
  while i > ran - 10
    booster.add draft.cardSet.common[i]
    i--

  # CHANCE FOIL
  # Roughly 1 in 4 packs replace a common with a foil version of a card.
  # This card can be any rarity, based on the same rarity distribtion of a pack.
  ran = @getRandomInt 1, 4

  # Again, 3 is the magic number. We find and swap in the foil.
  if ran is 3
    # Get a random card from across the whole set.
    foil = @pickFoil()

    # Remove the last common and add the foil.
    booster.pop()
    booster.add foil

  # We make the land the last card in the pack for visual purposes.
  booster.add booster.shift()

  # Return the booster pack array.
  booster

magic.pickFoil = ->
  # Pick a number 1 to 100.
  ran = @getRandomInt 1, 100

  ###
  ISSUE: if statements might work better as a switch statement.
  ###
  # Default foil to land, override based on random number.
  rarity = 'land'
  # common
  if ran >= 1 and ran <= 66
    rarity = 'common'
  # uncommon
  if ran > 66 and ran <= 86
    rarity = 'uncommon'
  # rare
  if ran > 86 and ran <= 92
    rarity = 'rare'
  # mythic
  if ran is 93
    rarity = 'mythic'

  # Determine index of card.
  ran = @getRandomInt 0, draft.cardSet[rarity].length - 1

  ###
  ISSUE: Rewrite to use jQuery $.extend()
  ###
  # Create new instance of card object rather than reference it.
  # Otherwise that object would have the foil property misset.
  Card = ->
  Card:: = draft.cardSet[rarity][ran]
  card = new Card()
  
  # Set foil property to distinguish it as foil.
  card.is_foil = true
  
  # Return the card.
  card

magic.addRare = ->
  # 1 in 8 rares are mythic, so perform a check to see if this one will be.
  ran = @getRandomInt 1, 8

  # The magic number is 3. If 3 is the random number we get a mythic.
  if ran is 3
    ran = @getRandomInt 0, draft.cardSet.mythic.length - 1
    return draft.cardSet.mythic[ran]
  
  # Otherwise just a regular rare.
  ran = @getRandomInt 0, draft.cardSet.rare.length - 1
  draft.cardSet.rare[ran]

magic.getRandomInt = (min, max) ->
  # Return a number between the min and min, inclusively.
  Math.floor Math.random() * (max - min + 1) + min

magic.shuffle = (arr) ->
  # Perform the Fisher-Yates shuffle on an array.
  i  = arr.length
  return false if i is 0
  while --i
    j = Math.floor Math.random() * (i + 1)
    tempi = arr[i]
    tempj = arr[j]
    arr[i] = tempj
    arr[j] = tempi
  arr