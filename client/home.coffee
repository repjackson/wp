@selected_tags = new ReactiveArray []


# @onpush = (event)->
#   console.log(event.data);

# self.registration.showNotification("New mail from Alice", {
#   actions: [{action: 'archive', title: "Archive"}]
# });



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

Template.body.events
    # 'click a': ->
    #     $('.main_content')
    #         .transition('fade out', 250)
    #         .transition('fade in', 250)


Template.map.onCreated ->
    if Meteor.user()
        @autorun => Meteor.subscribe 'nearby_people', Meteor.user().username

Template.map.onRendered =>
    Meteor.setTimeout =>
        pos = Geolocation.currentLocation()
        # pos.coords.latitude
        Session.set('current_lat', pos.coords.latitude)
        Session.set('current_long', pos.coords.longitude)
        Meteor.users.update Meteor.userId(),
            $set:current_position:pos
        @map = L.map('mapid',{
            dragging:false, 
            zoomControl:false
            bounceAtZoomLimits:false
            touchZoom:false
            }).setView([Session.get('current_lat'), Session.get('current_long')], 17);
        # L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
        #     attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
        #     maxZoom: 18,
        #     id: 'mapbox/outdoors-v11',
        #     tileSize: 512,
        #     zoomOffset: -1,
        #     accessToken: 'your.mapbox.access.token'
        # }).addTo(mymap);
        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            # attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            accessToken:"pk.eyJ1IjoicmVwamFja3NvbiIsImEiOiJja21iN3V5OWgwMGI4Mm5temU0ZHk3bjVsIn0.3nq7qTUAh0up18iIIuOPrQ"
            maxZoom: 19,
            minZoom: 19,
            id: 'mapbox/outdoors-v11',
            tileSize: 512,
            zoomOffset: -1,
        }).addTo(map);
        L.marker([Session.get('current_lat'), Session.get('current_long')]).addTo(map)
            # .openPopup();
            # .bindPopup('you')
        L.circle([Session.get('current_lat'), Session.get('current_long')], {
            color: 'blue',
            weight: 0
            fillColor: '#3b5998',
            fillOpacity: 0.16,
            radius: 50
        }).addTo(map);
        # onMapClick = (e)->
        #     alert("You clicked the map at " + e.latlng);
        
        # map.on('click', onMapClick);

    , 1000
    # pos.coords.latitude
    # pos.coords.longitude
    # if Session.get('current_lat')
    #     map = L.map('mapid').setView([Session.get('current_lat'), Session.get('current_long')], 13);
    # L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
    #     attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
    #     maxZoom: 18,
    #     id: 'mapbox/outdoors-v11',
    #     tileSize: 512,
    #     zoomOffset: -1,
    #     accessToken: 'your.mapbox.access.token'
    # }).addTo(mymap);
    # L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    #     attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    # }).addTo(map);
    

    # L.marker([53.5, -0.1]).addTo(map)
    #     .bindPopup('person')
    #     .openPopup();
    

    home_subs_ready: ->
        Template.instance().subscriptionsReady()
    #
    # home_subs_ready: ->
    #     if Template.instance().subscriptionsReady()
    #         Session.set('global_subs_ready', true)
    #     else
    #         Session.set('global_subs_ready', false)


Template.nearby_person.onCreated ->
    console.log @data
    # L.marker([51.5, -0.09]).addTo(map)
    #     .bindPopup('person')
    #     .openPopup();

    

Template.map.helpers
    nearby_people: ->
        Meteor.users.find()
Template.map.events
    'click .goto_user': ->
        $('.main_content')
            .transition('fade out', 500)
            .transition('fade in', 500)
        
        Router.go "/user/#{@username}"
    
    'click .refresh': ->
        console.log Geolocation.currentLocation();
        pos = Geolocation.currentLocation()
        # pos.coords.latitude
        Session.set('current_lat', pos.coords.latitude)
        Session.set('current_long', pos.coords.longitude)
        
        map = L.map('mapid').setView([Session.get('current_lat'), Session.get('current_long')], 17);
        # L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
        #     attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
        #     maxZoom: 18,
        #     id: 'mapbox/outdoors-v11',
        #     tileSize: 512,
        #     zoomOffset: -1,
        #     accessToken: 'your.mapbox.access.token'
        # }).addTo(mymap);
        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            accessToken:"pk.eyJ1IjoicmVwamFja3NvbiIsImEiOiJja21iN3V5OWgwMGI4Mm5temU0ZHk3bjVsIn0.3nq7qTUAh0up18iIIuOPrQ"
            maxZoom: 21,
            minZoom: 18,
            id: 'mapbox/outdoors-v11',
            tileSize: 512,
            zoomOffset: -1,
        }).addTo(map);
        
        L.marker([51.5, -0.09]).addTo(map)
            .bindPopup('person')
            .openPopup();
        # circle = L.circle([51.508, -0.11], {
        #     color: 'red',
        #     fillColor: '#f03',
        #     fillOpacity: 0.5,
        #     radius:100
        # }).addTo(mymap);

        # L.marker([53.5, -0.1]).addTo(map)
        #     .bindPopup('person')
        #     .openPopup();


