(->
  'use strict'

  DraftRouter = Backbone.Router.extend
    routes:
      ':setName': 'startDraft'
      '*nomatch': 'error'

    # Pass the name of the set to use for the draft.
    startDraft: (name) ->
      if name then draft.startDraft name 

    error: ->

  draft.setRouter = new DraftRouter()
  Backbone.history.start()

)()