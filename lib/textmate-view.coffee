{View} = require 'atom'

module.exports =
class TextmateView extends View
  @content: ->
    @div class: 'textmate overlay from-top', =>
      @div "The Textmate package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "textmate:open-favs", => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @detach()

  toggle: ->
    console.log "TextmateView was toggled!"
    if @hasParent()
      @detach()
    else
      atom.workspaceView.append(this)
