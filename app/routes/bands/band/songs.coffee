`import Ember from 'ember'`

`import Song from '../../../models/song'`


class BandsBandSongsRoute extends Ember.Route
  model: -> @modelFor 'bands.band'

  queryParams:
    sortBy:
      as: 'sort'
      replace: true
    searchTerm:
      as: 's'
      replace: true

  actions:
    createSong: ->
      controller = @get 'controller'
      band = @modelFor 'bands.band'


      song = @store.createRecord 'song',
        title: controller.get 'title'
        band: band


      song.save().then ->
        controller.set 'title', ''
      band.get('songs').pushObject(song)
      band.save()

    updateRating: (params) ->
      song = params.item
      rating = params.rating

      if song.get('rating') is rating
        rating = 0

      song.set('rating', rating)
      song.save()



`export default BandsBandSongsRoute`
