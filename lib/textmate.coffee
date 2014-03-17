require 'opal'

OpalNode.load_path.push __dirname
OpalNode.require 'textmate.rb'

module.exports = Opal.TextMate.$new()
