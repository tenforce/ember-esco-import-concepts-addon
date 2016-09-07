`import Ember from 'ember'`

class BandsBandIndexRoute extends Ember.Route
  afterModel: (band) ->
    description = band.get 'description'
    if Ember.isEmpty description
      @transitionTo 'bands.band.songs'
    else
      @transitionTo 'bands.band.details'

`export default BandsBandIndexRoute`
