if Meteor.isClient
    Router.route '/recently', (->
        @layout 'layout'
        @render 'recently'
        ), name:'recently'


    Template.recently.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_post_count', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_comment_count', Router.current().params.username
        @autorun -> Meteor.subscribe 'recent_checkins'
  
    Template.recently.helpers
        checkins: ->
            Docs.find
                model:'checkin'
    Template.recently.events
        'click .mark_viewed': ->
            console.log @


if Meteor.isServer
    Meteor.publish 'recent_checkins', ->
        Docs.find 
            model:'checkin'
        , limit:20