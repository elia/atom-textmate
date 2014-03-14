TextmateView = require './textmate-view'

module.exports =
  textmateView: null

  activate: (state) ->
    @textmateView = new TextmateView(state.textmateViewState)

  deactivate: ->
    @textmateView.destroy()

  serialize: ->
    textmateViewState: @textmateView.serialize()
