Meteor.publish 'userStatus', ()->
    Meteor.users.find 'status.online': true

Meteor.publish 'user_from_username', (username)->
    Meteor.users.find username:username

Meteor.publish 'markers', (username)->
    Markers.find()    