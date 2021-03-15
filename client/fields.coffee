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
