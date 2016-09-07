`import Ember from 'ember'`

class BandsController extends Ember.Controller
  name: ''

  isAddButtonDisabled: Ember.computed 'name', ->
    Ember.isEmpty @get('name')

`export default BandsController`
