`import Ember from 'ember'`

class BandsBandRoute extends Ember.Route
  model: (params) ->
    @store.findRecord 'band', params.id
    # bands = @modelFor 'bands'
    # bands.findBy 'slug', params.slug

  afterModel: (band) ->
    description = band.get 'description'
    if Ember.isEmpty description
      @transitionTo 'bands.band.songs'
    else
      @transitionTo 'bands.band.details'

`export default BandsBandRoute`
