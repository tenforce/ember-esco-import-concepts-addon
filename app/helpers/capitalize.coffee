`import Ember from 'ember'`

# This function receives the params `params, hash`
capitalize = (input) ->
  words = input.toString().split(/\s+/).map( (word) ->
    word.toLowerCase().capitalize())
  words.join(' ')
  
CapitalizeHelper = Ember.Helper.helper capitalize

`export { capitalize }`

`export default CapitalizeHelper`
