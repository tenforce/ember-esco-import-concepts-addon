`import Ember from 'ember'`



`import layout from '../templates/components/esco-import-concepts'`



class EscoImportConceptsComponent extends Ember.Component
  layout: layout
  tagName: 'div'
  className: ['esco-import-concepts']

  importStatus: "Select a file to import..."

  actions:
    importFile: ->
      controller = @get 'controller'
      fileContent = event.path[0][0].files[0]
      fileName = fileContent.name

      @set 'importStatus', "Uploading #{fileName}."

      Ember.$.ajax
        type: "POST"
        url: "/import-concepts/import/taxonomy"
        data: fileContent
        processData: false
        success: (data) =>
          @validateFile fileName, data.id
        error: =>
          console.log "Call to import-concepts failed."
          @set 'importStatus', "Upload failed for #{fileName}. The import-concepts service might be unavailable or #{fileName} might be corrupt."
          @cleanUp()
      false

  # Start validation
  validateFile: (fileName, id) ->
    @set 'importStatus', "Validating #{fileName} with id #{id}."
    Ember.$.ajax
      type: "POST"
      url: "/validations/run?graph=#{id}"
      data: {}
      success: (data) =>
        @checkValidation fileName, id
      error: =>
        console.log "Call to validation service failed."
        @set 'importStatus', "Validation failed for #{fileName} with id #{id}. The validation service might be unavailable."
        @cleanUp()

  # Poll validation status
  checkValidation: (fileName, id) ->
    Ember.$.ajax
      type: "GET"
      url: "/validations/results?graph=#{id}"
      success: (data) =>
        console.log data
        status = data.meta.status.match(/#(.+)$/)[1] #match the relevant status string
        switch status
          when "NotValidated", "underValidation"
            console.log "Busy: #{status}"
            Ember.run.later((()=>@checkValidation fileName, id), 1000) #poll every second
          when "Validated"
            @copyGraph fileName, id
          when "Invalid"
            @set 'importStatus', "Validation not passed. #{fileName} with id #{id} is invalid."
          else
            @set 'importStatus', "Validation failed. Unknown status for #{fileName} with id #{id}: #{status}."
            console.log "Unknown status: #{status}."
      error: =>
        console.log "Call to validation service failed."
        @set 'importStatus', "Validation failed for #{fileName} with id #{id}. The validation service might be unavailable."
        @cleanUp()

  # Copy temp graph into application graph
  copyGraph: (fileName, id) ->
    @set 'importStatus', "#{fileName} with id #{id} is validated. Copying into application graph."
    Ember.$.ajax
        type: "POST"
        url: "/copy-graph"
        data: """{"id":"#{id}"}"""
        contentType: "application/json; charset=utf-8"
        dataType: "json"
        success: (data) =>
          @set 'importStatus', "Finished. #{fileName} with id #{id} is validated and copied into application graph."
          @cleanUp()
        error: =>
          console.log "Call to copy-graph failed."
          @set 'importStatus', "Copying failed for #{fileName} with id #{id}. The copy-graph service might be unavailable, or the graph is not found. It might already be copied."
          @cleanUp()

  # Clean up the temp graph after importing to application graph
  cleanUp: ->
    Ember.$.ajax
      type: "POST"
      url: "/cleanup/clean?delete=import"
      data: {}
      success: (data) =>
        console.log "Cleanup succeeded."
      error: =>
        console.log "Call to cleanup service failed."


`export default EscoImportConceptsComponent`
