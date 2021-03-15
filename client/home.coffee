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
                    if doc
                        Docs.update parent._id,
                            $set:"#{@key}":res.public_id

    'blur .cloudinary_id': (e,t)->
        cloudinary_id = t.$('.cloudinary_id').val()
        parent = Template.parentData()
        Docs.update parent._id,
            $set:"#{@key}":cloudinary_id


    'click #remove_photo': ->
        parent = Template.parentData()

        if confirm 'remove photo?'
            # Docs.update parent._id,
            #     $unset:"#{@key}":1
            doc = Docs.findOne parent._id
            if doc
                Docs.update parent._id,
                    $unset:"#{@key}":1
                    
            
Template.textarea_edit.events
    # 'click .toggle_edit': (e,t)->
    #     t.editing.set !t.editing.get()

    'blur .edit_textarea': (e,t)->
        textarea_val = t.$('.edit_textarea').val()
        parent = Template.parentData()

        doc = Docs.findOne parent._id
        if doc
            Docs.update parent._id,
                $set:"#{@key}":textarea_val


Template.text_edit.events
    'blur .edit_text': (e,t)->
        val = t.$('.edit_text').val()
        parent = Template.parentData()

        doc = Docs.findOne parent._id
        if doc
            Docs.update parent._id,
                $set:"#{@key}":val


Template.number_edit.events
    'blur .edit_number': (e,t)->
        # console.log @
        parent = Template.parentData()
        val = parseInt t.$('.edit_number').val()
        doc = Docs.findOne parent._id
        if doc
            Docs.update parent._id,
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
                if doc
                    Docs.update parent._id,
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

        t.$('.new_element').focus()
        t.$('.new_element').val(element)

# Template.textarea.onCreated ->
#     @editing = new ReactiveVar false

# Template.textarea.helpers
#     is_editing: -> Template.instance().editing.get()

