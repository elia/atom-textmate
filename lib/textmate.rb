require 'native'
# textmateView: null
#
# activate: (state) ->
#   @textmateView = new TextmateView(state.textmateViewState)
#
# deactivate: ->
#   @textmateView.destroy()
#
# serialize: ->
#   textmateViewState: @textmateView.serialize()

class TextMate
  native_class

  def activate state
    # state = Native(state)
    # @view = TextMateView.new(state[:textmateViewState])
  end

  def deactivate
    # view.destroy
  end

  def serialize
    # {textmateViewState: view.serialize}.to_n
    {}.to_n
  end

  native_alias :activate, :activate
  native_alias :deactivate, :deactivate
  native_alias :serialize, :serialize
end
