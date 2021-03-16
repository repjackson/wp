Meteor.startup ->
    # Let's check if the browser supports notifications
    if !('Notification' of window)
        alert 'This browser does not support desktop notification'
    # else if Notification.permission == 'granted'
    #     notification = new Notification('whoo!')
    # else if Notification.permission != 'denied'
    #     Notification.requestPermission().then (permission) ->
    #         alert 'thanks for accepting notifications'
