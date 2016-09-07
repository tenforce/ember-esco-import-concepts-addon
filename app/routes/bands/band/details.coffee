`import Ember from 'ember'`

class BandsBandDetailsRoute extends Ember.Route
  model: -> @modelFor 'bands.band'

  actions:
    willTransition: (transition) ->
      controller = @get 'controller'

      if controller.get 'isEditing'
        leave = window.confirm "You have unsaved changes. Are you sure you want to leave?"
        if leave
          controller.set 'isEditing', false
        else
          transition.abort()

`export default BandsBandDetailsRoute`
