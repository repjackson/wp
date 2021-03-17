# @selected_tags = new ReactiveArray []


# @onpush = (event)->
#   console.log(event.data);

# self.registration.showNotification("New mail from Alice", {
#   actions: [{action: 'archive', title: "Archive"}]
# });




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
    @autorun => Meteor.subscribe 'markers'
    if Meteor.user()
        @autorun => Meteor.subscribe 'nearby_people', Meteor.user().username

Template.map.onRendered =>
    navigator.geolocation.getCurrentPosition (position) =>
        console.log 'navigator position', position
        Session.set('current_lat', position.coords.latitude)
        Session.set('current_long', position.coords.longitude)

    # pos = Geolocation.currentLocation()
    Meteor.setTimeout =>
        # pos.coords.latitude
        # Session.set('current_lat', pos.coords.latitude)
        # Session.set('current_long', pos.coords.longitude)
        # Meteor.users.update Meteor.userId(),
        #     $set:current_position:pos
        @map = L.map('mapid',{
            dragging:false, 
            zoomControl:false
            bounceAtZoomLimits:false
            touchZoom:false
            doubleClickZoom:false
            }).setView([Session.get('current_lat'), Session.get('current_long')], 17);

        # var map = L.map('map', {
        # doubleClickZoom: false
        # }).setView([49.25044, -123.137], 13);
        
        # L.tileLayer.provider('Stamen.Watercolor').addTo(map);
        
        map.on('dblclick', (event)->
            console.log 'clicked', event
            Markers.insert({latlng: event.latlng});
        )
        # // add clustermarkers
        # markers = L.markerClusterGroup();
        # map.addLayer(markers);
        
        query = Markers.find();
        query.observe
            added: (doc)->
                console.log 'added marker', doc
                # marker = L.marker(doc.latlng).on('click', (event)->
                #     Markers.remove({_id: doc._id});
                # );
                L.marker([doc.latlng.lat, doc.latlng.lng]).addTo(map)
                # markers.addLayer(marker);
                
            removed: (oldDocument)->
                layers = map._layers;
                for key in layers
                    val = layers[key];
                    if (val._latlng)
                        if val._latlng.lat is oldDocument.latlng.lat and val._latlng.lng is oldDocument.latlng.lng
                            markers.removeLayer(val)
            
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
        onMapClick = (e)->
            alert("You clicked the map at " + e.latlng);
        
        # map.on('click', onMapClick);

    , 1000
    # Meteor.setInterval ()->
    #     navigator.geolocation.getCurrentPosition((position)->
    #         Session.set('lat', position.coords.latitude)
    #         Session.set('lon', position.coords.longitude)
    #     , 5000);
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
    

    # home_subs_ready: ->
    #     Template.instance().subscriptionsReady()
    #
    # home_subs_ready: ->
    #     if Template.instance().subscriptionsReady()
    #         Session.set('global_subs_ready', true)
    #     else
    #         Session.set('global_subs_ready', false)


Template.nearby_person.onCreated ->
    # console.log Template.parentData()
    # console.log @
    # console.log @data
    # L.marker([@data.current_lat, @data.current_long]).addTo(@map)
    #     .bindPopup('person')
    #     .openPopup();

    
# cursor = Meteor.users.find();
# cursor.observeChanges
#     added: (id, object) ->
#         console.log("person added")


Template.map.helpers
    nearby_people: ->
        Meteor.users.find
            light_mode:true
Template.map.events
    'click .goto_user': ->
        $('.main_content')
            .transition('fade out', 250)
            .transition('fade in', 250)
        
        Router.go "/user/#{@username}"
    
    'click .refresh': ->
        console.log Geolocation.currentLocation();
        navigator.geolocation.getCurrentPosition (position) =>
            console.log position
        pos = Geolocation.currentLocation()
        # pos.coords.latitude
        if pos
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


