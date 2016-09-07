`import Ember from 'ember'`

class BandsBandDetailsController extends Ember.Controller
  isEditing: false

  actions:
    edit: ->
      @set 'isEditing', true
      false

    save: ->
      @set 'isEditing', false
      false

`export default BandsBandDetailsController`
