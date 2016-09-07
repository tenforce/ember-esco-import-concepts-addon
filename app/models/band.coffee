`import Ember from 'ember'`

class Band extends Ember.Object
  name: ''


  init: ->
    @_super(arguments...)
    if not @get('songs')
      @set('songs', [])



  slug: Ember.computed 'name', ->
    console.log 'Recomputing slug'
    @get('name').dasherize()

`export default Band`
