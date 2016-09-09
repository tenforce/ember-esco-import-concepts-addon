`import { test, moduleForComponent } from 'ember-qunit'`
`import hbs from 'htmlbars-inline-precompile'`

moduleForComponent 'esco-import-concepts', 'Integration | Component | esco import concepts', {
  integration: true
}

test 'it renders', (assert) ->
  assert.expect 2

  # Set any properties with @set 'myProperty', 'value'
  # Handle any actions with @on 'myAction', (val) ->

  @render hbs """{{esco-import-concepts}}"""

  assert.equal @$().text().trim(), ''

  # Template block usage:
  @render hbs """
    {{#esco-import-concepts}}
      template block text
    {{/esco-import-concepts}}
  """

  assert.equal @$().text().trim(), 'template block text'
