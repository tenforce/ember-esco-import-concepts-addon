`import Ember from 'ember'`

class IndexRoute extends Ember.Route
  beforeModel: ->
    @transitionTo 'bands'

`export default IndexRoute`
