if Meteor.isClient
    Router.route '/user/:username', (->
        @layout 'layout'
        @render 'profile'
        ), name:'profile'

   
   
    Template.layout.onCreated ->
        @autorun -> Meteor.subscribe 'me', ->
    
    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_post_count', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_checkins', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_live_posts', Router.current().params.username
  
    Template.profile.events
    
        'click a.select_term': ->
            $('.profile_yield')
                .transition('fade out', 200)
                .transition('fade in', 200)
    

        'click .logout': ->
            # Router.go '/login'
            Session.set 'logging_out', true
            Meteor.logout ->
                Session.set 'logging_out', false

        'click .mark_viewed': ->
            console.log @
            $('body').toast({
                message: 'marked read'
                class: 'success'
            })
            
            Meteor.call 'mark_viewed', @_id, ->
    
        'keyup .add_feed_item': (e,t)->
            if e.which is 13
                val = $('.add_feed_item').val()
                console.log val
                target_user = Meteor.users.findOne(username:Router.current().params.username)
                Docs.insert
                    model:'feed_item'
                    body: val
                    target_user_id: target_user._id
                    target_user_username: target_user.username
                val = $('.add_feed_item').val('')

            
        'click .checkin': (e,t)->
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            
            
            Docs.insert
                model:'checkin'
                target_user_id: target_user._id
                target_user_username: target_user.username
                location_ob: Geolocation.currentLocation()
                
            
    Template.profile.helpers
        live_posts: -> 
            Docs.find {
                model:'live_post'
            },
                sort:
                    _timestamp:-1
        user_post_count: -> Counts.get 'user_post_count'
        post_points: -> Counts.get('user_post_count')*10
        user_comment_count: -> Counts.get 'user_comment_count'

        user_checkins: ->
            Docs.find
                model:'checkin'

        
        
    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
    
    Template.profile.onRendered ->
        # Meteor.setTimeout ->
        #     $('.no_blink')
        #         .popup()
        # , 1000
        user = Meteor.users.findOne(username:Router.current().params.username)


    Template.profile.helpers
        route_slug: -> "user_#{@slug}"
        user: -> Meteor.users.findOne username:Router.current().params.username
        user_comment_count: -> Counts.get 'user_comment_count'
        user_post_count: -> Counts.get 'user_post_count'






if Meteor.isServer
    Meteor.publish 'user_tip_count', (username)->
        user = Meteor.users.findOne username:username
        match = {
            model:'tip'
            _author_id:user._id
        }
    
        # match.tags = $all:picked_tags
        # if picked_tags.length
        Counts.publish this, 'user_tip_count', Docs.find(match)
        return undefined
    
    Meteor.methods
        log_user_view: (user_id)->
            if Meteor.user()
                unless user_id is Meteor.userId()
                    Meteor.users.update user_id,
                        $inc:profile_views:1
            
                    
                    
if Meteor.isServer
    Meteor.publish 'user_posts', (username)->
        user = Meteor.users.findOne username:username
        Docs.find({
            model:'post'
            _author_id:user._id
        },{
            limit:20
            sort: _timestamp:-1
        })
    Meteor.publish 'user_checkins', (username)->
        user = Meteor.users.findOne username:username
        Docs.find({
            model:'checkin'
            _author_id:user._id
        },{
            limit:20
            sort: _timestamp:-1
        })
    # Meteor.publish 'current_user', (username)->
    #     Meteor.users.find Meteor.userId()
        