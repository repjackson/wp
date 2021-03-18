if Meteor.isClient
    Router.route '/recently', (->
        @layout 'layout'
        @render 'recently'
        ), name:'recently'


    Template.recently.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
        # @autorun -> Meteor.subscribe 'user_post_count', Router.current().params.username
        # @autorun -> Meteor.subscribe 'user_comment_count', Router.current().params.username
        @autorun -> Meteor.subscribe 'recent_posts'
  
    Template.recently.helpers
        recent_posts: ->
            Docs.find {
                model:'live_post'
            }, sort:_timestamp:-1
    Template.recently.events
        'keyup .add_live_post': (e,t)->
            if e.which is 13
                e.preventDefault()
                content = t.$('.add_live_post').val().trim()
                user = Meteor.user()
                if user and user.geocoded
                    if content.length>0
                        parent = Template.parentData()
                        Docs.insert 
                            model:'live_post'
                            content:content
                            long_form:user.geocoded[0].formatted
                        content = t.$('.add_live_post').val('')
        'click .mark_viewed': ->
            console.log @

    Template.recent_post.onCreated ->
        @autorun => Meteor.subscribe 'author_from_id', @data._id
        
if Meteor.isServer
    Meteor.publish 'recent_posts', ->
        user = Meteor.user()
        if user and user.geocoded
            # console.log user.geocoded[0].components.formatted
            console.log user.geocoded[0].formatted
            Docs.find 
                model:'live_post'
                long_form:user.geocoded[0].formatted
            , limit:100 
        
    Meteor.publish 'author_from_id', (doc_id)->
        doc = Docs.findOne doc_id
        
        Meteor.users.find 
            _id:doc._author_id