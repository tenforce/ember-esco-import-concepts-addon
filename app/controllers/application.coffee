`import Ember from 'ember'`

class Song extends Ember.Object
  title: ''
  rating: 0
  band: ''

blackDog = new Song
  title: 'Black Dog'
  band: 'Pearl Jam'
  rating: 9000

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



class ApplicationController extends Ember.Controller
  songs: songs.get 'sortedContent'


`export default ApplicationController`
