`import Ember from 'ember';`
`import config from './config/environment';`

Router = Ember.Router.extend
  location: config.locationType


Router.map ->
  @route 'bands', ->
    @route 'band', {path:':slug'}, ->
      @route 'songs'

`export default Router;`
