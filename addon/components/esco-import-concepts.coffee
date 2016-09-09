`import Ember from 'ember'`
`import layout from '../templates/components/esco-import-concepts'`

`import wait from '../utils/wait';`



class EscoImportConceptsComponent extends Ember.Component
  layout: layout
  tagName: 'div'
  className: ['esco-import-concepts']


  importStatus: "Choose file"


  actions:
    importFile: ->
      @set 'importStatus', "Importing..."
      # import file (sync)
      wait true, 1000
      # validate file (async)
      @set 'importStatus', "Validating..."
      wait true, 1000
      # copy file (async)
      @set 'importStatus', "Validated. Copying file. "
      wait true, 1000


      false


`export default EscoImportConceptsComponent`
