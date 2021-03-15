@selected_tags = new ReactiveArray []



# Meteor.setInterval ()->
    # navigator.geolocation.getCurrentPosition((position)->
    #     Session.set('lat', position.coords.latitude)
    #     Session.set('lon', position.coords.longitude)
    # , 5000);

Template.location.helpers
    pos:-> 
        console.log Geolocation.currentLocation()
        Geolocation.currentLocation()
    # lat: ()-> Geolocation.latLng().lat
    # lon: ()-> Geolocation.latLng().lon



Template.admin.helpers
    doc_count: ->
        Docs.find().count()


Template.agg_tag.onCreated ->
    # console.log @
    # @autorun => @subscribe 'term', @data.title
# Template.search_term.onCreated ->
#     # console.log @
#     @autorun => @subscribe 'term', @data.title

Template.map.onRendered ->
    map = L.map('mapid').setView([51.505, -0.09], 13);
    # L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    #     attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    #     maxZoom: 18,
    #     id: 'mapbox/streets-v11',
    #     tileSize: 512,
    #     zoomOffset: -1,
    #     accessToken: 'your.mapbox.access.token'
    # }).addTo(mymap);
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    L.marker([51.5, -0.09]).addTo(map)
        .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
        .openPopup();


    home_subs_ready: ->
        Template.instance().subscriptionsReady()
    #
    # home_subs_ready: ->
    #     if Template.instance().subscriptionsReady()
    #         Session.set('global_subs_ready', true)
    #     else
    #         Session.set('global_subs_ready', false)
