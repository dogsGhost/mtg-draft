(->
  'use strict'

  DraftRouter = Backbone.Router.extend
    routes:
      ':setName': 'startDraft'
      '*nomatch': 'error'

    # Pass the name of the set to use for the draft.
    startDraft: (name) ->
      if name
        document.title = "#{name.charAt(0).toUpperCase()}#{name.slice 1} | #{document.title}"
        draft.startDraft name 

    error: ->

  draft.setRouter = new DraftRouter()
  Backbone.history.start()

)()