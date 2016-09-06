`import Ember from 'ember'`
`import Band from '../models/band'`
`import Song from '../models/song'`





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

#
# class BandsColletion extends Ember.Object
#   content: []
#   sortProperties: ['name:desc']
#   sortedContent: Ember.computed.sort 'content', 'sortProperties'

bands = []

ledZeppelin = new Band
  name: 'Led Zeppelin'
  songs: [blackDog]

pearlJam = new Band
  name: 'Pearl Jam'
  songs: [daughter, yellowLedbetter]

fooFighters = new Band
  name: 'Foo Fighters'
  songs: [pretender]

bands.pushObjects [ledZeppelin, pearlJam, fooFighters]



class BandsRoute extends Ember.Route
    model: -> bands

    actions:
      createBand: ->
        name = @get('controller').get('name')
        band = new Band
          name: name
        bands.pushObject band
        @get('controller').set('name', '')

`export default BandsRoute`
