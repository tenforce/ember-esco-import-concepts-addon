


wait = (value, delay)->
  console.log "Waiting"
  promise = if value.then && typeof value.then is 'function'
              value
            else
              Ember.RSVP.resolve value

  new Ember.RSVP.Promise (resolve) ->
    setTimeout ->
      promise.then (result) ->
        resolve result
    ,
    delay


`export default wait`
