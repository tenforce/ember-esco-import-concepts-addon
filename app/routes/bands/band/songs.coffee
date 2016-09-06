`import Ember from 'ember'`

class BandsBandSongsRoute extends Ember.Route
  model: -> @modelFor 'bands.band'

`export default BandsBandSongsRoute`
