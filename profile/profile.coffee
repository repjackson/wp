if Meteor.isClient
    Router.route '/u/:username', (->
        @layout 'layout'
        @render 'user_dashboard'
        ), name:'user_dashboard'
    Router.route '/user/:username', (->
        @layout 'layout'
        @render 'user_dashboard'
        ), name:'user_dashboard_long'

   
   

    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_post_count', Router.current().params.username
        @autorun -> Meteor.subscribe 'user_comment_count', Router.current().params.username
  
    Template.user_dashboard.onCreated ->
    Template.user_dashboard.events
        'click .mark_viewed': ->
            console.log @
            $('body').toast({
                message: 'marked read'
                class: 'success'
            })
            
            Meteor.call 'mark_viewed', @_id, ->
    
        'click .user_credit_segment': ->
            Router.go "/debit/#{@_id}/view"
            
        'click .user_debit_segment': ->
            Router.go "/debit/#{@_id}/view"
            
        'click .user_checkin_segment': ->
            Router.go "/drink/#{@drink_id}/view"
            
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

            
    Template.user_dashboard.helpers
        feed_items: -> 
            Docs.find {
                model:'feed_item'
            },
                sort:
                    _timestamp:-1
        user_post_count: -> Counts.get 'user_post_count'
        post_points: -> Counts.get('user_post_count')*10
        user_comment_count: -> Counts.get 'user_comment_count'
        user_tips_sent_count: -> Counts.get 'user_tips_sent_count'
        user_tips_received_count: -> Counts.get 'user_tips_received_count'

        user_karma_received: ->
            current_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find 
                model:'debit'
                target_id:current_user._id
        user_karma_sent: ->
            current_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find 
                model:'debit'
                _author_id:current_user._id
                
        
        
    Template.profile.onCreated ->
        @autorun -> Meteor.subscribe 'current_user', Router.current().params.username
    
    Template.profile.onRendered ->
        # Meteor.setTimeout ->
        #     $('.no_blink')
        #         .popup()
        # , 1000
        user = Meteor.users.findOne(username:Router.current().params.username)
        Meteor.setTimeout ->
            if user
                Meteor.call 'calc_user_stats', user._id, ->
                Meteor.call 'log_user_view', user._id, ->
        , 2000


    Template.profile.helpers
        route_slug: -> "user_#{@slug}"
        user: -> Meteor.users.findOne username:Router.current().params.username
        user_comment_count: -> Counts.get 'user_comment_count'
        user_post_count: -> Counts.get 'user_post_count'

    Template.profile.events
    
        'click a.select_term': ->
            $('.profile_yield')
                .transition('fade out', 200)
                .transition('fade in', 200)
        'click .click_group': (e,t)->
            # $('.label')
            #     .transition('fade out', 200)
            Router.go "/g/#{@name}"
        'keyup .goto_group': (e,t)->
            if e.which is 13
                val = $('.goto_group').val()
                found_group =
                    Docs.findOne 
                        model:'group_bookmark'
                        name:val
                if found_group
                    Docs.update found_group._id,
                        $inc:search_amount:1
                else
                    Docs.insert 
                        model:'group_bookmark'
                        search_amount:1
                        name:val
                # $('.header')
                #     .transition('scale', 200)
                # $('.global_container')
                #     .transition('scale', 400)
                Router.go "/g/#{val}"
                # target_user = Meteor.users.findOne(username:Router.current().params.username)
                # Docs.insert
                #     model:'debit'
                #     body: val
                #     target_user_id: target_user._id
        'click .remove_group': ->
            if confirm 'remove group?'
                Docs.remove @_id
        # 'click .goto_users': ->
        #     $('.global_container')
        #         .transition('fade right', 500)
        #         # .transition('fade in', 200)
        #     Meteor.setTimeout ->
        #         Router.go '/users'
        #     , 500
    
    
        'click .refresh_user_stats': ->
            user = Meteor.users.findOne(username:Router.current().params.username)
            # Meteor.call 'calc_user_stats', user._id, ->
            Meteor.call 'calc_user_stats', user._id, ->
            Meteor.call 'calc_user_tags', user._id, ->
    

        'click .logout': ->
            # Router.go '/login'
            Session.set 'logging_out', true
            Meteor.logout ->
                Session.set 'logging_out', false





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
    Meteor.publish 'current_user', (username)->
        Meteor.users.find Meteor.userId()
        