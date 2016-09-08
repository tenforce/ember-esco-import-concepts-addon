`import Ember from 'ember'`
`import wait from '../utils/wait';`




class BandsRoute extends Ember.Route
    model: ->
      bands = @store.findAll('band')
      # wait bands, 250

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
