`import Ember from 'ember'`





class BandsRoute extends Ember.Route
    model: ->
      @store.findAll('band')

    actions:
      createBand: ->
        route = this
        controller = @get 'controller'
        band = @store.createRecord 'band', controller.getProperties 'name'

        band.save().then ->
          controller.set 'name', ''
          route.transitionTo 'bands.band.songs', band

      didTransition: ->
        band = @modelFor 'bands.band'
        if band
          Ember.$(document).attr 'title', "#{band.get 'name'} Bands - Rock & Roll"

`export default BandsRoute`
