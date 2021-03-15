if Meteor.isClient
    Router.route '/login', (->
        @layout 'layout'
        @render 'login'
        ), name:'login'

    Template.login.onCreated ->
        Session.set 'username', null

    Template.login.events
        'keyup .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'

        'blur .username': ->
            username = $('.username').val()
            Session.set 'username', username
            Meteor.call 'find_username', username, (err,res)->
                if res
                    Session.set 'enter_mode', 'login'
                else
                    Session.set 'enter_mode', 'register'

        'click .enter': (e,t)->
            e.preventDefault()
            username = $('.username').val()
            password = $('.password').val()
            options = {
                username:username
                password:password
                }
            # console.log options
            Meteor.loginWithPassword username, password, (err,res)=>
                if err
                    console.log err
                    $('body').toast({
                        message: err.reason
                    })
                else
                    Docs.insert 
                        model:'global_event'
                        type:'login'
                        user_id:Meteor.userId()
                        username:Meteor.user().username
                    # console.log res
                    # if Meteor.user().roles and 'admin' in Meteor.user().roles
                    #     Router.go "/admin"
                    # else
                    Router.go "/user/#{Meteor.user().username}"
                    # Router.go "/user/#{username}"

        'keyup .password, keyup .username': (e,t)->
            if e.which is 13
                e.preventDefault()
                username = $('.username').val()
                password = $('.password').val()
                if username and username.length > 0 and password and password.length > 0
                    options = {
                        username:username
                        password:password
                        }
                    # console.log options
                    Meteor.loginWithPassword username, password, (err,res)=>
                        if err
                            console.log err
                            $('body').toast({
                                message: err.reason
                            })
                        else
                            # Router.go "/user/#{username}"
                            # if Meteor.user().roles and 'admin' in Meteor.user().roles
                            #     Router.go "/admin"
                            # else
                            Router.go "/user/#{Meteor.user().username}"


    Template.login.helpers
        username: -> Session.get 'username'
        logging_in: -> Session.equals 'enter_mode', 'login'
        input_login_class: ->
            if Meteor.loggingIn() then 'loading disabled' else ''
        enter_class: ->
            if Session.get('username').length
                if Session.get 'enter_mode', 'login'
                    if Meteor.loggingIn() then 'loading disabled' else ''
            else
                'disabled'
        is_logging_in: -> Meteor.loggingIn()
