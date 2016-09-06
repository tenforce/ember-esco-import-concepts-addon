`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'star-rating', 'Integration | Component | star rating', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{star-rating}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#star-rating}}
      template block text
    {{/star-rating}}
  """

  assert.equal @$().text().trim(), 'template block text'
