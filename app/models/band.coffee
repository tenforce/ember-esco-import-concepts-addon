`import Ember from 'ember'`

class Band extends Ember.Object
  name: ''
  songs: []
  
  slug: Ember.computed 'name', ->
    console.log 'Recomputing slug'
    @get('name').dasherize()


`export default Band`
