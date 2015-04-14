AbstractView = require './AbstractView'

class AbstractViewPage extends AbstractView

	_shown     : false
	_listening : false

	show : (cb) =>

		return unless !@_shown
		@_shown = true

		###
		CHANGE HERE - 'page' views are always in DOM - to save having to re-initialise gmap events (PITA). No longer require :dispose method
		###
		@CD().appView.wrapper.addChild @
		@callChildrenAndSelf 'setListeners', 'on'

		### replace with some proper transition if we can ###
		@$el.css 'visibility' : 'visible'
		cb?()

		if @CD().nav.changeViewCount is 1
			@CD().appView.on @CD().appView.EVENT_PRELOADER_HIDE, @animateIn
		else
			@animateIn()

		null

	hide : (cb) =>

		return unless @_shown
		@_shown = false

		###
		CHANGE HERE - 'page' views are always in DOM - to save having to re-initialise gmap events (PITA). No longer require :dispose method
		###
		@CD().appView.wrapper.remove @

		# @callChildrenAndSelf 'setListeners', 'off'

		### replace with some proper transition if we can ###
		@$el.css 'visibility' : 'hidden'
		cb?()

		null

	dispose : =>

		@callChildrenAndSelf 'setListeners', 'off'

		null

	setListeners : (setting) =>

		return unless setting isnt @_listening
		@_listening = setting

		null

	animateIn : =>

		###
		stubbed here, override in used page classes
		###

		null

module.exports = AbstractViewPage
