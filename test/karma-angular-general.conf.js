// Karma configuration
// Generated on Sun Sep 15 2013 20:18:09 GMT-0400 (EDT)

module.exports = function (config) {
  config.set({
  
    // base path, that will be used to resolve files and exclude
    basePath: '../',
  
  
    // frameworks to use
    frameworks: ['jasmine'],
  
  
    // list of files / patterns to load in the browser
    files: [
      'test/*.js',
      'src/*.js',
      'test/*.coffee'
    ],
  
  
    // list of files to exclude
    exclude: [],
    
    
    // test results reporter to use
    // possible values: 'dots', 'progress', 'junit', 'growl', 'coverage'
    reporters: ['progress', 'coverage'],
  
  
    // web server port
    port: 9876,
  
  
    // enable / disable colors in the output (reporters and logs)
    colors: true,
  
  
    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,
  
  
    // enable / disable watching file and executing tests whenever any file changes
  
  
    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],
  
    coverageReporter: {
      type: 'html',
      dir: 'coverage/'
    },
  
    preprocessors: {
      'src/*.js': ['coverage', 'webpack'],
      'test/*.js': ['webpack'],
      'test/*.coffee': ['coffee']
    },
  
    webpack: require('../webpack.config.test'),
    webpackMiddleware: {
      noInfo: true
    },
    coffeePreprocessor: {
      options: {
        bare: true,
        sourceMap: false
      },
      transformPath: function (path) {
        return path.replace(/\.coffee$/, '.js')
      }
    },
    plugins: [
      require('karma-jasmine'),
      require('karma-junit-reporter'),
      require('karma-coverage'),
      require('karma-phantomjs-launcher'),
      require('karma-coffee-preprocessor'),
      require('karma-webpack')
    ],
    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 60000,
  
  
    // Continuous Integration mode
    // if true, it capture browsers, run tests and exit
    singleRun: true,
    autoWatch: false
  });
};
