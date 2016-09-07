`import Ember from 'ember'`









class BandsRoute extends Ember.Route
    model: ->
      @store.findAll('band')

    actions:
      createBand: ->
        # name = @get('controller').get('name')
        # band = new Band
        #   name: name
        # bands.pushObject band
        # @get('controller').set('name', '')
        # @transitionTo 'bands.band.songs', band

        route = this
        controller = @get 'controller'
        band = @store.createRecord 'band', controller.getProperties('name')

        band.save().then ->
          controller.set 'name', ''
          route.transitionTo 'bands.band.songs', band




      didTransition: ->
        band = @modelFor 'bands.band'
        Ember.$(document).attr 'title', "#{band.get 'name'} Bands - Rock & Roll"

`export default BandsRoute`
