`import Ember from 'ember'`

`import Song from '../../../models/song'`


class BandsBandSongsRoute extends Ember.Route
  model: -> @modelFor 'bands.band'

  actions:
    createSong: ->
      controller = @get 'controller'
      band = @modelFor 'bands.band'
      title = controller.get 'title'

      song = new Song
        title: title
        band: band
      band.get('songs').pushObject song
      controller.set 'title', ''

    updateRating: (params) ->
      song = params.item
      rating = params.rating

      song.set('rating', rating)



`export default BandsBandSongsRoute`
