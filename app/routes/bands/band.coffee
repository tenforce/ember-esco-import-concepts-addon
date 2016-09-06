`import Ember from 'ember'`

class BandsBandRoute extends Ember.Route
  model: (params) ->
    bands = @modelFor 'bands'
    bands.findBy 'slug', params.slug

`export default BandsBandRoute`
