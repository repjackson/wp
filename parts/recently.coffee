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
        'keyup .add_live_post': (e,t)->
            if e.which is 13
                e.preventDefault()
                content = t.$('.add_live_post').val().trim()
                if content.length>0
                    parent = Template.parentData()
                    Docs.insert 
                        model:'live_post'
                        content:content
                    content = t.$('.add_live_post').val('')
        'click .mark_viewed': ->
            console.log @

    Template.recent_checkin.onCreated ->
        @autorun => Meteor.subscribe 'author_from_id', @data._id
        
if Meteor.isServer
    Meteor.publish 'recent_checkins', ->
        Docs.find 
            model:'checkin'
        , limit:20    
        
    Meteor.publish 'author_from_id', (doc_id)->
        doc = Docs.findOne doc_id
        
        Meteor.users.find 
            _id:doc._author_id