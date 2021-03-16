Template.boolean_edit.helpers
    boolean_toggle_class: ->
        parent = Template.parentData()
        if parent["#{@key}"] then 'active' else 'basic'


Template.boolean_edit.events
    'click .toggle_boolean': (e,t)->
        # if @direct
        parent = Template.parentData()
        # $(e.currentTarget).closest('.button').transition('pulse', 100)

        doc = Docs.findOne parent._id
        user = Meteor.users.findOne parent._id
        if doc
            Docs.update parent._id,
                $set:"#{@key}":!parent["#{@key}"]
        else if user
            Meteor.users.update parent._id,
                $set:"#{@key}":!parent["#{@key}"]
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
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $unset:"#{@key}":1
           else 
                Meteor.users.update user._id,
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
        val = parseInt(t.$('.edit_number').val())
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

