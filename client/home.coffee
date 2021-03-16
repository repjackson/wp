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

Template.body.events
    'click a': ->
        $('.main_content')
            .transition('fade out', 250)
            .transition('fade in', 250)


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
        @map = L.map('mapid').setView([Session.get('current_lat'), Session.get('current_long')], 17);
        # L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
        #     attribution: 'Map data &copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors, Imagery © <a href="https://www.mapbox.com/">Mapbox</a>',
        #     maxZoom: 18,
        #     id: 'mapbox/streets-v11',
        #     tileSize: 512,
        #     zoomOffset: -1,
        #     accessToken: 'your.mapbox.access.token'
        # }).addTo(mymap);
        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            accessToken:"pk.eyJ1IjoicmVwamFja3NvbiIsImEiOiJja21iN3V5OWgwMGI4Mm5temU0ZHk3bjVsIn0.3nq7qTUAh0up18iIIuOPrQ"
            maxZoom: 21,
            minZoom: 18,
            id: 'mapbox/streets-v11',
            tileSize: 512,
            zoomOffset: -1,
        }).addTo(map);
        L.marker([Session.get('current_lat'), Session.get('current_long')]).addTo(map)
            .bindPopup('you')
            .openPopup();
        L.circle([Session.get('current_lat'), Session.get('current_long')], {
            color: 'blue',
            weight: 0
            fillColor: '#3b5998',
            fillOpacity: 0.16,
            radius: 200
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
    #     id: 'mapbox/streets-v11',
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


# Template.nearby_person.onCreated ->
#     console.log @data
#     L.marker([51.5, -0.09]).addTo(map)
#         .bindPopup('person')
#         .openPopup();

    

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
        #     id: 'mapbox/streets-v11',
        #     tileSize: 512,
        #     zoomOffset: -1,
        #     accessToken: 'your.mapbox.access.token'
        # }).addTo(mymap);
        L.tileLayer('https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
            accessToken:"pk.eyJ1IjoicmVwamFja3NvbiIsImEiOiJja21iN3V5OWgwMGI4Mm5temU0ZHk3bjVsIn0.3nq7qTUAh0up18iIIuOPrQ"
            maxZoom: 21,
            minZoom: 18,
            id: 'mapbox/streets-v11',
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


Template.image_edit.events
    "change input[name='upload_image']": (e) ->
        files = e.currentTarget.files
        parent = Template.parentData()
        Cloudinary.upload files[0],
            # folder:"secret" # optional parameters described in http://cloudinary.com/documentation/upload_images#remote_upload
            # model:"private" # optional: makes the image accessible only via a signed url. The signed url is available publicly for 1 hour.
            (err,res) => #optional callback, you can catch with the Cloudinary collection as well
                if err
                    console.error 'Error uploading', err
                else
                    doc = Docs.findOne parent._id
                    user = Meteor.users.findOne parent._id
                    if doc
                        Docs.update parent._id,
                            $set:"#{@key}":res.public_id
                    else 
                        Meteor.users.update parent._id,
                            $set:"#{@key}":res.public_id




    'blur .cloudinary_id': (e,t)->
        cloudinary_id = t.$('.cloudinary_id').val()
        parent = Template.parentData()
        Docs.update parent._id,
            $set:"#{@key}":cloudinary_id


    'click #remove_photo': ->
        parent = Template.parentData()

        user = Meteor.users.findOne parent._id
        if confirm 'remove photo?'
            # Docs.update parent._id,
            #     $unset:"#{@key}":1
            doc = Docs.findOne parent._id
            if doc
                Docs.update parent._id,
                    $unset:"#{@key}":1
           else 
                Meteor.users.update parent._id,
                    $unset:"#{@key}":1
         
            
Template.textarea_edit.events
    # 'click .toggle_edit': (e,t)->
    #     t.editing.set !t.editing.get()

    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent = Template.parentData()
        user = Meteor.users.findOne parent._id

        doc = Docs.findOne parent._id
        if doc
            Docs.update parent._id,
                $set:"#{@key}":textarea_val
        else 
            Meteor.users.update parent._id,
                $set:"#{@key}":textarea_val


Template.text_edit.events
    'blur .edit_text': (e,t)->
        val = t.$('.edit_text').val()
        parent = Template.parentData()
        user = Meteor.users.findOne parent._id

        doc = Docs.findOne parent._id
        if doc
            Docs.update parent._id,
                $set:"#{@key}":val
        else 
            Meteor.users.update parent._id,
                $set:"#{@key}":val


Template.number_edit.events
    'blur .edit_number': (e,t)->
        # console.log @
        parent = Template.parentData()
        val = parseInt t.$('.edit_number').val()
        doc = Docs.findOne parent._id
        user = Meteor.users.findOne parent._id

        if doc
            Docs.update parent._id,
                $set:"#{@key}":val
        else 
            Meteor.users.update parent._id,
                $set:"#{@key}":val

Template.array_edit.events
    # 'click .touch_element': (e,t)->
    #     $(e.currentTarget).closest('.touch_element').transition('slide left')
        
    'click .pick_tag': (e,t)->
        # console.log @
        picked_tags.clear()
        picked_tags.push @valueOf()
        # Router.go "/g/#{Router.current().params.group}"
        Router.go "/"

    'keyup .new_element': (e,t)->
        if e.which is 13
            element_val = t.$('.new_element').val().trim().toLowerCase()
            if element_val.length>0
                parent = Template.parentData()
                doc = Docs.findOne parent._id
                user = Meteor.users.findOne parent._id
                
                if doc
                    Docs.update parent._id,
                        $addToSet:"#{@key}":element_val
                else 
                    Meteor.users.update parent._id,
                        $addToSet:"#{@key}":element_val
                # window.speechSynthesis.speak new SpeechSynthesisUtterance element_val
                t.$('.new_element').val('')

    'click .remove_element': (e,t)->
        $(e.currentTarget).closest('.touch_element').transition('slide left', 1000)

        element = @valueOf()
        field = Template.currentData()
        parent = Template.parentData()

        doc = Docs.findOne parent._id
        if doc
            Docs.update parent._id,
                $pull:"#{field.key}":element
        else 
            Meteor.users.update parent._id,
                $pull:"#{field.key}":element

        t.$('.new_element').focus()
        t.$('.new_element').val(element)

# Template.textarea.onCreated ->
#     @editing = new ReactiveVar false

# Template.textarea.helpers
#     is_editing: -> Template.instance().editing.get()

