`import Ember from 'ember'`

class Band extends Ember.Object
  name: ''
  language: 'com'
  slug: Ember.computed 'name', ->
    console.log 'Recomputing slug'
    @get('name').dasherize()
  site: Ember.computed 'slug', 'language', ->
    console.log 'Recomputing site'
    'http://bands.com/' + @get 'slug' + '.' + @get 'language'


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

daughter = new Song
  title: 'Daughter'
  band: 'Pearl Jam'
  rating: 5

pretender = new Song
  title: 'The Pretender'
  band: 'Foo Fighters'
  rating: 2


class BandsColletion extends Ember.Object
  content: []
  sortProperties: ['name:desc']
  sortedContent: Ember.computed.sort 'content', 'sortProperties'

bands = new BandsColletion

ledZeppelin = new Band
  name: 'Led Zeppelin'
  songs: [blackDog]

pearlJam = new Band
  name: 'Pearl Jam'
  songs: [daughter, yellowLedbetter]

fooFighters = new Band
  name: 'Foo Fighters'
  songs: [pretender]

bands.get('content').pushObjects [ledZeppelin, pearlJam, fooFighters]



class BandsRoute extends Ember.Route
    model: -> bands.get 'sortedContent'

`export default BandsRoute`
