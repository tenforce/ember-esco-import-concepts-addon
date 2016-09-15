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
        error: => console.log "Upload failed"
      false


  validateFile: (fileName, id) ->
    @set 'importStatus', "Validating #{fileName} as #{id}"
    Ember.$.ajax
      type: "POST"
      url: "/validations/run?graph=" + id
      data: {}
      success: (data) => @checkValidation fileName, id

  checkValidation: (fileName, id) ->
    @get('store').query('escograph','filter[id]': id).then (res) =>
      status = res.objectAt(0).get('status')
      switch status
        when "Waiting"
          console.log "Busy"
          Ember.run.later((()=>@checkValidation fileName, id), 500)
        when "Validated" then @finishedValidation fileName, id
        when "Invalid" then @set 'importStatus', "#{fileName} is invalid."
        else console.log status

  finishedValidation: (fileName, id) ->
    # TODO copy





      #"Importing..."
      # import file (sync)
      # validate file (async)
      # @set 'importStatus', "Validating..."
      # wait true, 1000
      # copy file (async)
      # @set 'importStatus', "Validated. Copying file. "
      # wait true, 1000




`export default EscoImportConceptsComponent`
