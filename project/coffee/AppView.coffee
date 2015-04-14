AbstractView = require './view/AbstractView'
Preloader    = require './view/base/Preloader'
Header       = require './view/base/Header'
Wrapper      = require './view/base/Wrapper'
Footer       = require './view/base/Footer'
ModalManager = require './view/modals/_ModalManager'

class AppView extends AbstractView

    template : 'main'

    $window  : null
    $body    : null

    wrapper  : null
    footer   : null

    dims :
        w : null
        h : null
        o : null
        c : null

    events :
        'click a' : 'linkManager'

    EVENT_UPDATE_DIMENSIONS : 'EVENT_UPDATE_DIMENSIONS'
    EVENT_PRELOADER_HIDE    : 'EVENT_PRELOADER_HIDE'

    MOBILE_WIDTH : 700
    MOBILE       : 'mobile'
    NON_MOBILE   : 'non_mobile'

    constructor : ->

        @$window = $(window)
        @$body   = $('body').eq(0)

        super()

    disableTouch: =>

        @$window.on 'touchmove', @onTouchMove
        return

    enableTouch: =>

        @$window.off 'touchmove', @onTouchMove
        return

    onTouchMove: ( e ) ->

        e.preventDefault()
        return

    render : =>

        @bindEvents()

        @preloader    = new Preloader
        @modalManager = new ModalManager

        @header  = new Header
        @wrapper = new Wrapper
        @footer  = new Footer

        @
            .addChild @header
            .addChild @wrapper
            .addChild @footer

        @onAllRendered()

        @preloader.playIntroAnimation => @trigger @EVENT_PRELOADER_HIDE

        return

    bindEvents : =>

        @on 'allRendered', @onAllRendered

        @onResize()

        @onResize = _.debounce @onResize, 300
        @$window.on 'resize orientationchange', @onResize
        return

    onAllRendered : =>

        # console.log "onAllRendered : =>"

        @$body.prepend @$el

        @begin()
        return

    begin : =>

        @trigger 'start'

        @CD().router.start()

        # @preloader.hide()
        return

    onResize : =>

        @getDims()
        return

    getDims : =>

        w = window.innerWidth or document.documentElement.clientWidth or document.body.clientWidth
        h = window.innerHeight or document.documentElement.clientHeight or document.body.clientHeight

        @dims =
            w : w
            h : h
            o : if h > w then 'portrait' else 'landscape'
            c : if w <= @MOBILE_WIDTH then @MOBILE else @NON_MOBILE

        @trigger @EVENT_UPDATE_DIMENSIONS, @dims

        return

    linkManager : (e) =>

        href = $(e.currentTarget).attr('href')

        return false unless href

        @navigateToUrl href, e

        return

    navigateToUrl : ( href, e = null ) =>

        route   = if href.match(@CD().BASE_URL) then href.split(@CD().BASE_URL)[1] else href
        section = if route.charAt(0) is '/' then route.split('/')[1].split('/')[0] else route.split('/')[0]

        if @CD().nav.getSection section
            e?.preventDefault()
            @CD().router.navigateTo route
        else 
            @handleExternalLink href

        return

    handleExternalLink : (data) =>

        console.log "handleExternalLink : (data) => "

        ###

        bind tracking events if necessary

        ###

        return

module.exports = AppView
