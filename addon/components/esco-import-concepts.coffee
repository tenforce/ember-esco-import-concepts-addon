`import Ember from 'ember'`
`import layout from '../templates/components/esco-import-concepts'`

EscoImportConceptsComponent = Ember.Component.extend
# Addon parameters

# eg "/import/taxonomy"
  importerEndpoint: Ember.K
# eg "Select a taxonomy file to import..."
  startingMessage: Ember.K

  layout: layout
  tagName: 'div'
  className: ['esco-import-concepts']
  encoding: 'utf-8'

  errorTitle: Ember.computed.alias 'serverError.title'
  errorDetail: Ember.computed.alias 'serverError.detail'

  showError: Ember.computed 'serverError', ->
    @get('serverError') isnt undefined

  importStatus: Ember.computed 'startingMessage', ->
    "Status: " + @get 'startingMessage'

  shouldDisable: Ember.computed 'fileToUpload', ->
    @get('fileToUpload') is undefined or @get('fileToUpload') is ""

  isFileLoaded: Ember.computed 'shouldDisable', ->
# No time to waste on making something pretty, should set that status somewhere else though
    if @get('shouldDisable') then return false
    else
      @set 'importStatus', "Status: Ready to import"
      return true

  didInsertElement: ->
    Ember.$('#fileForm').submit (event) =>
      event.preventDefault()
      @importFile event

  importFile: (e) ->
    myevent = window.event or e
    myevent = Ember.$.event.fix myevent
    @sendAction('toggleValidations', false)
    controller = @get 'controller'
    importerEndpoint = @get 'importerEndpoint'
    fileContent = myevent.currentTarget[0].files[0]
    fileName = fileContent.name
    effort = @get('mappingEffort')
    @set 'importStatus', "Uploading #{fileName}."

    Ember.$.ajax
      type: "POST"
      url: "/import-concepts#{importerEndpoint}?uuid=#{effort.get('id')}&encoding=#{@get('encoding')}"
      data: fileContent
      processData: false
      success: (data) =>
        @set 'serverError', undefined
        @validateFile fileName, data.id
      error: (err) =>
        console.log "Call to import-concepts failed."
        if err.responseJSON
          @set('serverError', err.responseJSON.errors[0])
        else # Error 500, no response JSON object received, microservice may be broken.
          @set('serverError', { title: undefined, detail: "Upload failed for #{fileName}. The import-concepts service might be unavailable or #{fileName} might be corrupt."})
    false

# Start validation
  validateFile: (fileName, id) ->
    @set 'importStatus', "Validating #{fileName} with id #{id}."
    Ember.$.ajax
      type: "POST"
      url: "/validation/run?graph=#{id}"
      data: {}
      success: (data) =>
        @checkValidation fileName, id
      error: =>
        console.log "Call to validation service failed."
        @set 'importStatus', "Validation failed for #{fileName} with id #{id}. The validation service might be unavailable."

# Poll validation status
  checkValidation: (fileName, id) ->
    Ember.$.ajax
      type: "GET"
      url: "/validation/results?graph=#{id}"
      success: (data) =>
        console.log data
        status = data.meta.status.match(/#(.+)$/)[1] #match the relevant status string
        switch status
          when "NotValidated", "underValidation"
            console.log "Busy: #{status}"
            Ember.run.later((()=>@checkValidation fileName, id), 1000) #poll every second
          when "Validated"
            @moveGraph fileName, id
          when "Invalid"
            @set 'importStatus', "Validation not passed. #{fileName} with id #{id} is invalid."
            @sendAction('graphIdReceived', id)
            @sendAction('toggleValidations', true)
          else
            @set 'importStatus', "Validation failed. Unknown status for #{fileName} with id #{id}: #{status}."
            @sendAction('graphIdReceived', id)
            @sendAction('toggleValidations', true)
            console.log "Unknown status: #{status}."
      error: =>
        console.log "Call to validation service failed."
        @set 'importStatus', "Validation failed for #{fileName} with id #{id}. The validation service might be unavailable."

# Move temp graph into application graph
  moveGraph: (fileName, id) ->
    @set 'importStatus', "#{fileName} with id #{id} is validated. Moveing into application graph."
    Ember.$.ajax
      type: "GET"
      url: "/move-graph/move?uuid=#{id}"
      success: (data) =>
        @set 'importStatus', "Finished. #{fileName} with id #{id} is validated and copied into application graph."
        @sendAction('dataImported', data)
      error: =>
        console.log "Call to move-graph failed."
        @set 'importStatus', "Moveing failed for #{fileName} with id #{id}. The move-graph service might be unavailable, or the graph is not found. It might already be copied."

  actions:
    radioButtonSelected: (value) ->
      @set('encoding', value)


`export default EscoImportConceptsComponent`
