`import Ember from 'ember'`


class BandsBandSongsController extends Ember.Controller
  title: ''
  songCreationStarted: false

  isAddButtonDisabled: Ember.computed 'title', ->
    Ember.isEmpty @get('title')


  canCreateSong: Ember.computed 'songCreationStarted', 'model.songs.length', ->
    @get('songCreationStarted') or @get('model.songs.length')


  actions:
    enableSongCreation: ->
      @set 'songCreationStarted', true
      false


`export default BandsBandSongsController`
