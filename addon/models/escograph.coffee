`import DS from 'ember-data';`

Graph =  DS.Model.extend
  nocClassification : DS.attr('string')
  nocVersion : DS.attr('string')
  databaseUrl : DS.attr('string')
  documentID : DS.attr('string')
  graph : DS.attr('string')
  status : DS.attr('string')


`export default Graph`
