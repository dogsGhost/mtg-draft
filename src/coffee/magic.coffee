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
    draft.cardSet[rarity] = _.shuffle draft.cardSet[rarity]

  # 1 LAND
  # Add 1 land to the pack.
  booster.add _.sample draft.cardSet.land

  # 1 RARE
  booster.add @addRare()

  # 3 UNCOMMON
  ranCards = _.sample draft.cardSet.uncommon, 3
  _.each ranCards, (el, i, list) ->
    booster.add el

  # 10 COMMON
  ranCards = _.sample draft.cardSet.common, 10
  _.each ranCards, (el, i, list) ->
    booster.add el


  # CHANCE FOIL
  # Roughly 1 in 4 packs replace a common with a foil version of a card.
  # This card can be any rarity, based on the same rarity distribtion of a pack.
  ran = _.sample _.range 1, 4

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

magic.addRare = ->
  # 1 in 8 rares are mythic, so perform a check to see if this one will be.
  ran = _.sample _.range 1, 8

  # The magic number is 3. If 3 is the random number we get a mythic.
  if ran is 3
    return _.sample draft.cardSet.mythic
  
  # Otherwise just a regular rare.
  _.sample draft.cardSet.rare

magic.pickFoil = ->
  # Pick a number 1 to 100.
  ran = _.sample _.shuffle _.range 1, 100
  console.log ran

  # Determine rarity of foil.
  #default to land
  rarity = 'land'
  # common
  if ran >= 1 and ran <= 66 then rarity = 'common'
  # uncommon
  if ran > 66 and ran <= 86 then rarity = 'uncommon'
  # rare
  if ran > 86 and ran <= 92 then rarity = 'rare'
  # mythic
  if ran is 93 then rarity = 'mythic'
  
  # Determine index of card.
  ranCard = _.sample draft.cardSet[rarity]

  # Create new instance of card object rather than reference it.
  # Otherwise that object would have the foil property misset.
  card = $.extend {}, ranCard
  
  # Set foil property to distinguish it as foil.
  card.is_foil = true
  
  # Return the card.
  card