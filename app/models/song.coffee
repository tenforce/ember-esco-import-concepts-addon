`import DS from 'ember-data'`


class Song extends DS.Model
  title:  DS.attr('string')
  rating: DS.attr('number')
  band:   DS.belongsTo('band', inverse:null)

`export default Song`
