if Meteor.isClient
    Router.route '/user/:username/messages', (->
        @layout 'profile_layout'
        @render 'user_messages'
        ), name:'user_messages'
    
    Template.user_messages.onCreated ->
        @autorun => Meteor.subscribe 'docs', selected_tags.array(), 'thought'


    Template.user_messages.onCreated ->
        @autorun => Meteor.subscribe 'user_messages', Router.current().params.username
        @autorun => Meteor.subscribe 'model_docs', 'message'

    Template.user_messages.events
        'keyup .new_public_message': (e,t)->
            if e.which is 13
                val = $('.new_public_message').val()
                console.log val
                target_user = Meteor.users.findOne(username:Router.current().params.username)
                Docs.insert
                    model:'message'
                    body: val
                    is_private:false
                    target_user_id: target_user._id
                val = $('.new_public_message').val('')

        'click .submit_public_message': (e,t)->
            val = $('.new_public_message').val()
            console.log val
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.insert
                model:'message'
                is_private:false
                body: val
                target_user_id: target_user._id
            val = $('.new_public_message').val('')


        'keyup .new_private_message': (e,t)->
            if e.which is 13
                val = $('.new_private_message').val()
                console.log val
                target_user = Meteor.users.findOne(username:Router.current().params.username)
                Docs.insert
                    model:'message'
                    body: val
                    is_private:true
                    target_user_id: target_user._id
                val = $('.new_private_message').val('')

        'click .submit_private_message': (e,t)->
            val = $('.new_private_message').val()
            console.log val
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.insert
                model:'message'
                body: val
                is_private:true
                target_user_id: target_user._id
            val = $('.new_private_message').val('')



    Template.user_messages.helpers
        user_public_messages: ->
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find
                model:'message'
                target_user_id: target_user._id
                is_private:false

        user_private_messages: ->
            target_user = Meteor.users.findOne(username:Router.current().params.username)
            Docs.find
                model:'message'
                target_user_id: target_user._id
                is_private:true
                _author_id:Meteor.userId()



if Meteor.isServer
    Meteor.publish 'user_public_messages', (username)->
        target_user = Meteor.users.findOne(username:Router.current().params.username)
        Docs.find
            model:'message'
            target_user_id: target_user._id
            is_private:false

    Meteor.publish 'user_private_messages', (username)->
        target_user = Meteor.users.findOne(username:Router.current().params.username)
        Docs.find
            model:'message'
            target_user_id: target_user._id
            is_private:true
            _author_id:Meteor.userId()
