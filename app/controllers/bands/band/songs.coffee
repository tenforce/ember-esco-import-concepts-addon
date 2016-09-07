`import Ember from 'ember'`


class BandsBandSongsController extends Ember.Controller
  title: ''
  songCreationStarted: false

  isAddButtonDisabled: Ember.computed 'title', ->
    Ember.isEmpty @get('title')


  canCreateSong: Ember.computed 'songCreationStarted', 'model.songs.length', ->
    @get('songCreationStarted') or @get('model.songs.length')


  sortProperties: ['rating:desc', 'title:asc']
  sortedSongs: Ember.computed.sort 'model.songs', 'sortProperties'

  actions:
    enableSongCreation: ->
      @set 'songCreationStarted', true
      false


`export default BandsBandSongsController`
