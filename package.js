// package metadata file for Meteor.js
var packageName = 'vinaynb:angular-loading-bar';
var where = 'client'; // where to install: 'client' or 'server'. For both, pass nothing.
var version = '0.8.0';
var summary = 'An automatic loading bar for AngularJS';
var gitLink = 'https://github.com/chieffancypants/angular-loading-bar';
var documentationFile = 'README.md';

// Meta-data
Package.describe({
  name: packageName,
  version: version,
  summary: summary,
  git: gitLink,
  documentation: documentationFile
});

Package.onUse(function(api) {
  api.versionsFrom(['METEOR@0.9.0', 'METEOR@1.0']); // Meteor versions

  api.use('angular:angular@1.2.9', where); // Dependencies  

  api.addFiles('build/loading-bar.js', where); // Files in use
  api.addFiles('build/loading-bar.css', where); // Files in use
});