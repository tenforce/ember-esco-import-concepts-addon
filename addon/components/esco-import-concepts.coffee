`import Ember from 'ember'`



`import layout from '../templates/components/esco-import-concepts'`



class EscoImportConceptsComponent extends Ember.Component
  # Addon parameters

  # eg "/import/taxonomy"
  importerEndpoint: Ember.K
  # eg "Select a taxonomy file to import..."
  startingMessage: Ember.K


  layout: layout
  tagName: 'div'
  className: ['esco-import-concepts']

  importStatus: Ember.computed 'startingMessage', ->
    @get 'startingMessage'

  shouldDisable: Ember.computed 'fileToUpload', ->
    unless @get('fileToUpload') is undefined then return false
    return true

  actions:
    importFile: ->
      @sendAction('toggleValidations', false)
      controller = @get 'controller'
      importerEndpoint = @get 'importerEndpoint'
      fileContent = event.path[0][0].files[0]
      fileName = fileContent.name

      @set 'importStatus', "Uploading #{fileName}."

      Ember.$.ajax
        type: "POST"
        url: "/import-concepts#{importerEndpoint}"
        data: fileContent
        processData: false
        success: (data) =>
          @validateFile fileName, data.id
        error: =>
          console.log "Call to import-concepts failed."
          @set 'importStatus', "Upload failed for #{fileName}. The import-concepts service might be unavailable or #{fileName} might be corrupt."
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
            @sendAction('toggleValidations', true)
          else
            @set 'importStatus', "Validation failed. Unknown status for #{fileName} with id #{id}: #{status}."
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



`export default EscoImportConceptsComponent`
