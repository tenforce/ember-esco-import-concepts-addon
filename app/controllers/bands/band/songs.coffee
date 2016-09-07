`import Ember from 'ember'`


class BandsBandSongsController extends Ember.Controller
  queryParams:
    sortBy: 'sort'
    searchTerm: 's'


  title: ''
  songCreationStarted: false

  isAddButtonDisabled: Ember.computed 'title', ->
    Ember.isEmpty @get('title')


  canCreateSong: Ember.computed 'songCreationStarted', 'model.songs.length', ->
    @get('songCreationStarted') or @get('model.songs.length')


  sortedSongs: Ember.computed.sort 'matchingSong', 'sortProperties'
  sortBy: 'ratingDesc'
  sortProperties: Ember.computed 'sortBy', ->
    options =
      "ratingDesc": "rating:desc,title:asc"
      "ratingAsc": "rating:asc,title:asc"
      "titleDesc": "title:desc"
      "titleAsc": "title:asc"
    options[@get('sortBy')].split(',')

  searchTerm: ''
  matchingSong: Ember.computed 'model.songs.@each.title', 'searchTerm', ->
    searchTerm = @get('searchTerm').toLowerCase()
    @get('model.songs').filter (song)->
      song.get('title').toLowerCase().indexOf(searchTerm) isnt -1


  actions:
    enableSongCreation: ->
      @set 'songCreationStarted', true
      false

    setSorting: (option) ->
      @set 'sortBy', option
      false


`export default BandsBandSongsController`
