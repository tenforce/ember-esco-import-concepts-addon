`import Ember from 'ember'`

class Song extends Ember.Object
  title: ''
  rating: 0
  band: ''

blackDog = new Song
  title: 'Black Dog'
  band: 'Pearl Jam'
  rating: 3

yellowLedbetter = new Song
  title: 'Yellow Ledbetter'
  band: 'Pearl Jam'
  rating: 4

class SongColletion extends Ember.Object
  content: []
  sortProperties: ['rating:desc']
  sortedContent: Ember.computed.sort 'content', 'sortProperties'

songs = new SongColletion
songs.get('content').pushObjects [blackDog, yellowLedbetter]



window.songs = songs

alwaysWaiting = new Song
  title: 'Always Waiting'
  band: 'KP'
  rating: 7

window.newSong = alwaysWaiting


class ApplicationController extends Ember.Controller
  songs: songs.get 'content'


`export default ApplicationController`
