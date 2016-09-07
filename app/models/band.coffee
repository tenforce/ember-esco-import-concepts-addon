`import DS from 'ember-data'`


class Band extends DS.Model
  name:         DS.attr('string')
  description:  DS.attr()
  songs:        DS.hasMany('song', inverse:null)
  # disable automatic inverse relationship updates, it causes bugs

`export default Band`
