@selected_tags = new ReactiveArray []



# Meteor.setInterval ()->
    # navigator.geolocation.getCurrentPosition((position)->
    #     Session.set('lat', position.coords.latitude)
    #     Session.set('lon', position.coords.longitude)
    # , 5000);

Template.map.helpers
    pos:-> 
        # console.log Geolocation.currentLocation()
        Geolocation.currentLocation()
    # lat: ()-> Geolocation.latLng().lat
    # lon: ()-> Geolocation.latLng().lon



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
        .bindPopup('person')
        .openPopup();

    L.marker([53.5, -0.1]).addTo(map)
        .bindPopup('person')
        .openPopup();


    home_subs_ready: ->
        Template.instance().subscriptionsReady()
    #
    # home_subs_ready: ->
    #     if Template.instance().subscriptionsReady()
    #         Session.set('global_subs_ready', true)
    #     else
    #         Session.set('global_subs_ready', false)
