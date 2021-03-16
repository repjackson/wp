if Meteor.isClient
    Router.route '/', (->
        @layout 'layout'
        @render 'map'
        ), name:'home'


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
        'map'
    ]
    })



Router.route '*', -> @render 'map'
