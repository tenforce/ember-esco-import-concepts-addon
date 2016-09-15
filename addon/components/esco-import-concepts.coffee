`import Ember from 'ember'`



`import layout from '../templates/components/esco-import-concepts'`



class EscoImportConceptsComponent extends Ember.Component
  layout: layout
  tagName: 'div'
  className: ['esco-import-concepts']

  importStatus: "Select a file to import..."

  actions:
    importFile: ->
      # TODO check if there's a file
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
      false

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

  checkValidation: (fileName, id) ->
    Ember.$.ajax
      type: "GET"
      url: "/validations/results?graph=#{id}"
      success: (data) =>
        status = data.meta.status.match(/#(.+)$/)[1] #match the relevant status string
        switch status
          when "NotValidated", "underValidation"
            console.log "Busy: #{status}"
            Ember.run.later((()=>@checkValidation fileName, id), 1000) #poll every second
          when "Validated"
            @finishedValidation fileName, id
          when "Invalid"
            @set 'importStatus', "Validation not passed. #{fileName} with id #{id} is invalid."
          else
            @set 'importStatus', "Validation failed. Unknown status for #{fileName} with id #{id}: #{status}."
            console.log "Unknown status: #{status}."
      error: =>
        console.log "Call to validation service failed."
        @set 'importStatus', "Validation failed for #{fileName} with id #{id}. The validation service might be unavailable."

  finishedValidation: (fileName, id) ->
    @set 'importStatus', "#{fileName} with id #{id} is validated. Copying into application graph."
    Ember.$.ajax
        type: "POST"
        url: "/copy-graph"
        data: """{"id":"#{id}"}"""
        contentType: "application/json; charset=utf-8"
        dataType: "json"
        success: (data) =>
          @set 'importStatus', "Finished. #{fileName} with id #{id} is validated and copied into application graph."
        error: =>
          console.log "Call to copy-graph failed."
          @set 'importStatus', "Copying failed for #{fileName} with id #{id}. The copy-graph service might be unavailable, or the graph is not found. It might already be copied."

  # TODO cleanup after copy-graph

`export default EscoImportConceptsComponent`
