if Meteor.isClient
    Router.route '/user/:username', (->
        @layout 'layout'
        @render 'profile'
        ), name:'profile'

   
   
    Template.layout.onCreated ->
        @autorun -> Meteor.subscribe 'me', ->
    
    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
        # @autorun -> Meteor.subscribe 'user_post_count', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_checkins', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_live_posts', Router.current().params.username
        @autorun => Meteor.subscribe 'nearby_people', Router.current().params.username

    Template.profile.events
        'click .visible': ->
            Meteor.users.update Meteor.userId(),
                $set:light_mode:false
        'click .anonymous': ->
            Meteor.users.update Meteor.userId(),
                $set:light_mode:true
       
        'click .refresh_position': ->
            pos = Geolocation.currentLocation()
            # if pos
            #     console.log pos
            #     console.log typeof pos
            #     Meteor.users.update Meteor.userId(),
            #         $set:
            #             current_position: pos.coords
            #         , (err,res)->
            #             console.log res
            # if navigator.geolocation
            #     pos = navigator.geolocation.getCurrentPosition()
            #     console.log pos
                # Meteor.users.update Meteor.userId(),
                #     $set:
                #         current_position: pos.coords
                #     , (err,res)->
                #         console.log res
            user = Meteor.users.findOne()
            navigator.geolocation.getCurrentPosition (position) =>
                console.log 'saving long', position.coords.longitude
                console.log 'saving lat', position.coords.latitude
                Meteor.users.update Meteor.userId(),
                    $set:
                        location:
                            "type": "Point",
                            "coordinates": [
                                position.coords.longitude
                                position.coords.latitude
                            ]
                        current_lat: position.coords.latitude
                        current_long: position.coords.longitude
                    , (err,res)->
                        console.log res
                console.log 'updated user', Meteor.user().current_location
                Meteor.call 'tag_coordinates', user._id, position.coords.latitude, position.coords.longitude
                console.log(position.coords.latitude, position.coords.longitude);
                        
                        
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

            
        # 'click .checkin': (e,t)->
        #     target_user = Meteor.users.findOne(username:Router.current().params.username)
            
            
        #     Docs.insert
        #         model:'checkin'
        #         target_user_id: target_user._id
        #         target_user_username: target_user.username
        #         location_ob: Geolocation.currentLocation()
                
            
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

        long_form: ->
            @geocoded[0].formatted
        category: ->
            @geocoded[0].components._category
        
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
        if user
            Docs.find({
                model:'checkin'
                _author_id:user._id
            },{
                limit:20
                sort: _timestamp:-1
            })
    # Meteor.publish 'current_user', (username)->
    #     Meteor.users.find Meteor.userId()
        