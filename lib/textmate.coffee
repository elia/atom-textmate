# "activationEvents": ["textmate:open-favs"],

# TextmateView = require './textmate-view'
require 'opal'
OpalNode.require __dirname + '/textmate.rb'

module.exports = Opal.TextMate.$new()
