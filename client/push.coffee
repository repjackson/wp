# Meteor.startup ->
@registerServiceWorker = ->
    navigator.serviceWorker.register('/sw.js').then (swRegistration) ->


@isPushNotificationSupported = ->
    'serviceWorker' of navigator and 'PushManager' of window


initializePushNotifications = ->
    Notification.requestPermission (result) ->
        result

@sendNotification = ->
    img = '/images/jason-leung-HM6TMmevbZQ-unsplash.jpg'
    text = 'Take a look at this brand new t-shirt!'
    title = 'New Product Available'
    options = 
        body: text
        icon: '/images/jason-leung-HM6TMmevbZQ-unsplash.jpg'
        vibrate: [
            200
            100
            200
        ]
    tag: 'new-product'
    image: img
    badge: 'https://spyna.it/icons/android-icon-192x192.png'
    actions: [ {
      action: 'Detail'
      title: 'View'
      icon: 'https://via.placeholder.com/128/ff0000'
    } ]
navigator.serviceWorker.ready.then (serviceWorker) ->
    serviceWorker.showNotification title, options
