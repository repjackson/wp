if Meteor.isClient
    Router.route '/', (->
        @layout 'layout'
        @render 'map'
        ), name:'map'

    Router.route '/profile', (->
        @layout 'layout'
        @render 'profile'
        ), name:'profile'


Router.configure
    layoutTemplate: 'layout'
    notFoundTemplate: 'map'
    loadingTemplate: 'splash'
    trackPageView: false

force_loggedin =  ()->
    if !Meteor.userId()
        @render 'login'
    else
        @next()

Router.onBeforeAction(force_loggedin, {
    # only: ['admin']
    except: [
        'home'
        'register'
        'login'
        'verify-email'
    ]
    })



Router.route '*', -> @render 'map'
