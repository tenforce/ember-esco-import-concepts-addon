`import Ember from 'ember'`



`import layout from '../templates/components/esco-import-concepts'`



class EscoImportConceptsComponent extends Ember.Component
  layout: layout
  tagName: 'div'
  className: ['esco-import-concepts']


  store: Ember.inject.service()

  importStatus: "Choose file"


  actions:
    importFile: ->
      # TODO check if there's a file
      controller = @get 'controller'
      fileContent = event.path[0][0].files[0]
      fileName = fileContent.name

      @set 'importStatus', "Uploading #{fileName}"

      Ember.$.ajax
        type: "POST"
        url: "/import-concepts/import/taxonomy"
        data: fileContent
        processData: false
        success: (data) => @validateFile fileName, data.id
        error: => console.log "Call to import-concepts failed."
      false


  validateFile: (fileName, id) ->
    @set 'importStatus', "Validating #{fileName} as #{id}"
    Ember.$.ajax
      type: "POST"
      url: "/validations/run?graph=#{id}"
      data: {}
      success: (data) => @checkValidation fileName, id
      error: => console.log "Call to validation service failed."

  checkValidation: (fileName, id) ->
    Ember.$.ajax
      type: "GET"
      url: "/validations/results?graph=#{id}"
      success: (data) =>
        console.log data
        status = data.meta.status.match(/#(.+)$/)[1]
        switch status
          when "NotValidated", "underValidation"
            console.log status
            Ember.run.later((()=>@checkValidation fileName, id), 500)
          when "Validated" then @finishedValidation fileName, id
          when "Invalid" then @set 'importStatus', "#{fileName} as #{id} is invalid."
          else console.log "Unknown status: #{status}."
      error: => console.log "Call to validation service failed."

  finishedValidation: (fileName, id) ->
    @set 'importStatus', "#{fileName} as #{id} is validated. Copying into application graph."
    Ember.$.ajax
        type: "POST"
        url: "/copy-graph"
        data: '{"id":"'+id+'"}'
        contentType: "application/json; charset=utf-8"
        dataType: "json"
        success: (data) => console.log "Copied: " + data
        error: => console.log "Call to copy-graph failed."





      #"Importing..."
      # import file (sync)
      # validate file (async)
      # @set 'importStatus', "Validating..."
      # wait true, 1000
      # copy file (async)
      # @set 'importStatus', "Validated. Copying file. "
      # wait true, 1000




`export default EscoImportConceptsComponent`
