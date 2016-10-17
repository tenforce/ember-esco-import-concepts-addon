**Note: this addon has been generalized to support all kinds of resources.**

# Ember-esco-import-concepts-addon

An Ember plugin to import resources to the triple store. In turn, the graph in the selected file is

 - Uploaded using the `import-concepts` microservice
 - Validated with `validation-microservice`
 - Moved into the application graph with the `move-graph` microservice

After completion or when something goes wrong, `clean-up-microservice` is called to remove temporary triples. 

# Usage

The addon takes two parameters

 - `importerEndpoint` specifies which HTTP endpoint of `import-concepts` should be used.
 - `startingMessage` sets the message the user sees before choosing the file.

Example usage

    {{esco-import-concepts importerEndpoint="/import/taxonomy" startingMessage="Select a taxonomy file to import..."}}
    
