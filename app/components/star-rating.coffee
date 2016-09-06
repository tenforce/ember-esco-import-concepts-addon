`import Ember from 'ember'`

class StarRatingComponent extends Ember.Component
  tagName: 'div'
  classNames: ['rating-panel']

  rating: 0
  maxRating: 5
  item: null
  setAction: ''

  stars: Ember.computed 'rating', 'maxRating', ->
    {rating: i, full: i <=  @get('rating')} for i in [1.. @get('maxRating')]

  actions:
    set: (newRating) ->
      @sendAction 'setAction',
        item: @get 'item'
        rating: newRating


`export default StarRatingComponent`
