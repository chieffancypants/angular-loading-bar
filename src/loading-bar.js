/*
 * angular-loading-bar
 *
 * intercepts XHR requests and creates a loading bar.
 * Based on the excellent nprogress work by rstacruz (more info in readme)
 *
 * (c) 2013 Wes Cruver
 * License: MIT
 */


(function() {

'use strict';

// Alias the loading bar for various backwards compatibilities since the project has matured:
angular.module('angular-loading-bar', ['cfp.loadingBarInterceptor']);
angular.module('chieffancypants.loadingBar', ['cfp.loadingBarInterceptor']);


/**
 * loadingBarInterceptor service
 *
 * Registers itself as an Angular interceptor and listens for XHR requests.
 */
angular.module('cfp.loadingBarInterceptor', ['cfp.loadingBar'])
  .config(['$httpProvider', function ($httpProvider) {

    var interceptor = ['$q', '$cacheFactory', '$timeout', '$rootScope', '$log', 'cfpLoadingBar', function ($q, $cacheFactory, $timeout, $rootScope, $log, cfpLoadingBar) {

      /**
       * The total number of requests made
       */
      var reqsTotal = 0;

      /**
       * The number of requests completed (either successfully or not)
       */
      var reqsCompleted = 0;

      /**
       * The amount of time spent fetching before showing the loading bar
       */
      var latencyThreshold = cfpLoadingBar.latencyThreshold;

      /**
       * $timeout handle for latencyThreshold
       */
      var startTimeout;


      /**
       * calls cfpLoadingBar.complete() which removes the
       * loading bar from the DOM.
       */
      function setComplete() {
        $timeout.cancel(startTimeout);
        cfpLoadingBar.complete();
        reqsCompleted = 0;
        reqsTotal = 0;
      }

      /**
       * Determine if the response has already been cached
       * @param  {Object}  config the config option from the request
       * @return {Boolean} retrns true if cached, otherwise false
       */
      function isCached(config) {
        var cache;
        var defaultCache = $cacheFactory.get('$http');
        var defaults = $httpProvider.defaults;

        // Choose the proper cache source. Borrowed from angular: $http service
        if ((config.cache || defaults.cache) && config.cache !== false &&
          (config.method === 'GET' || config.method === 'JSONP')) {
            cache = angular.isObject(config.cache) ? config.cache
              : angular.isObject(defaults.cache) ? defaults.cache
              : defaultCache;
        }

        var cached = cache !== undefined ?
          cache.get(config.url) !== undefined : false;

        if (config.cached !== undefined && cached !== config.cached) {
          return config.cached;
        }
        config.cached = cached;
        return cached;
      }


      return {
        'request': function(config) {
          // Check to make sure this request hasn't already been cached and that
          // the requester didn't explicitly ask us to ignore this request:
          if (!config.ignoreLoadingBar && !isCached(config)) {
            $rootScope.$broadcast('cfpLoadingBar:loading', {url: config.url});
            if (reqsTotal === 0) {
              startTimeout = $timeout(function() {
                cfpLoadingBar.start();
              }, latencyThreshold);
            }
            reqsTotal++;
            cfpLoadingBar.set(reqsCompleted / reqsTotal);
          }
          return config;
        },

        'response': function(response) {
          if (!response || !response.config) {
            $log.error('Broken interceptor detected: Config object not supplied in response:\n https://github.com/chieffancypants/angular-loading-bar/pull/50');
            return response;
          }

          if (!response.config.ignoreLoadingBar && !isCached(response.config)) {
            reqsCompleted++;
            if (reqsCompleted >= reqsTotal) {
              $rootScope.$broadcast('cfpLoadingBar:loaded', {url: response.config.url, result: response});
              setComplete();
            } else {
              cfpLoadingBar.set(reqsCompleted / reqsTotal);
            }
          }
          return response;
        },

        'responseError': function(rejection) {
          if (!rejection || !rejection.config) {
            $log.error('Broken interceptor detected: Config object not supplied in rejection:\n https://github.com/chieffancypants/angular-loading-bar/pull/50');
            return $q.reject(rejection);
          }

          if (!rejection.config.ignoreLoadingBar && !isCached(rejection.config)) {
            reqsCompleted++;
            if (reqsCompleted >= reqsTotal) {
              $rootScope.$broadcast('cfpLoadingBar:loaded', {url: rejection.config.url, result: rejection});
              setComplete();
            } else {
              cfpLoadingBar.set(reqsCompleted / reqsTotal);
            }
          }
          return $q.reject(rejection);
        }
      };
    }];

    $httpProvider.interceptors.push(interceptor);
  }]);


/**
 * Loading Bar
 *
 * This service handles adding and removing the actual element in the DOM.
 * Generally, best practices for DOM manipulation is to take place in a
 * directive, but because the element itself is injected in the DOM only upon
 * XHR requests, and it's likely needed on every view, the best option is to
 * use a service.
 */
angular.module('cfp.loadingBar', [])
  .provider('cfpLoadingBar', function() {

    this.autoIncrement = true;
    this.includeSpinner = true;
    this.includeBar = true;
    this.latencyThreshold = 100;
    this.startSize = 0.02;
    this.parentSelector = 'body';
    this.spinnerTemplate = '<div id="loading-bar-spinner"><div class="spinner-icon"></div></div>';
    this.loadingBarTemplate = '<div id="loading-bar"><div class="bar"><div class="peg"></div></div></div>';
    this.fadeOutDuration = 350;

    function LoadingBar($document, $timeout, options) {
      var _this = this;
      var loadingBarContainer = angular.element(options.loadingBarTemplate);
      var loadingBar = loadingBarContainer.find('div').eq(0);
      var spinner = angular.element(options.spinnerTemplate);
      var incTimeout,
        status = 0;

      var init = function() {
        var document = $document[0];
        var parent = document.querySelector ?
            document.querySelector(options.parentSelector)
            : $document.find(options.parentSelector)[0]
          ;

        if(!parent) {
          parent = document.getElementsByTagName('body')[0];
        }

        var $parent = angular.element(parent);

        if(options.includeBar) {
          $parent.append(loadingBarContainer);
        }

        if(options.includeSpinner) {
          $parent.append(spinner);
        }
      };

      init();

      this.activate = function() {
        _this.set(options.startSize);
      };

      this.status = function() {
        return status;
      };

      this.set = function(n) {
        var pct = (n * 100) + '%';
        loadingBar.css('width', pct);
        status = n;

        // increment loadingbar to give the illusion that there is always
        // progress but make sure to cancel the previous timeouts so we don't
        // have multiple incs running at the same time.
        if (options.autoIncrement) {
          $timeout.cancel(incTimeout);

          incTimeout = $timeout(function() {
            _this.inc();
          }, 250);
        }
      };

      this.inc = function() {
        if (_this.status() >= 1) {
          return;
        }

        var rnd = 0;

        // TODO: do this mathmatically instead of through conditions

        var stat = _this.status();
        if (stat >= 0 && stat < 0.25) {
          // Start out between 3 - 6% increments
          rnd = (Math.random() * (5 - 3 + 1) + 3) / 100;
        } else if (stat >= 0.25 && stat < 0.65) {
          // increment between 0 - 3%
          rnd = (Math.random() * 3) / 100;
        } else if (stat >= 0.65 && stat < 0.9) {
          // increment between 0 - 2%
          rnd = (Math.random() * 2) / 100;
        } else if (stat >= 0.9 && stat < 0.99) {
          // finally, increment it .5 %
          rnd = 0.005;
        } else {
          // after 99%, don't increment:
          rnd = 0;
        }

        var pct = _this.status() + rnd;
        _this.set(pct);
      };

      this.cleanup = function() {
        spinner.addClass('out');
        loadingBarContainer.addClass('out');

        $timeout(function() {
          spinner.remove();
          loadingBarContainer.remove();
        }, options.fadeOutDuration);
      };
    }

    this.$get = ['$injector', '$document', '$timeout', '$rootScope', function ($injector, $document, $timeout, $rootScope) {
      var _this = this;

      var options = {
        parentSelector: _this.parentSelector,
        loadingBarTemplate: _this.loadingBarTemplate,
        spinnerTemplate: _this.spinnerTemplate,
        autoIncrement: _this.autoIncrement,
        includeSpinner: _this.includeSpinner,
        includeBar: _this.includeBar,
        startSize: _this.startSize,
        fadeOutDuration: _this.fadeOutDuration
      };

      var completeTimeout,
        currentBar = null;

      /**
       * Inserts the loading bar element into the dom, and sets it to 2%
       */
      function _start() {
        $timeout.cancel(completeTimeout);

        // do not continually broadcast the started event:
        if (currentBar) {
          return;
        }

        currentBar = new LoadingBar($document, $timeout, options);
        currentBar.activate();

        $rootScope.$broadcast('cfpLoadingBar:started');
      }

      /**
       * Set the loading bar's width to a certain percent.
       *
       * @param n any value between 0 and 1
       */
      function _set(n) {
        if (currentBar) currentBar.set(n);
      }

      /**
       * Increments the loading bar by a random amount
       * but slows down as it progresses
       */
      function _inc() {
        if (currentBar) currentBar.inc();
      }

      function _status() {
        return currentBar ? currentBar.status() : 0;
      }

      function _complete() {
        if (!currentBar) {
          return;
        }

        _set(1);
        $timeout.cancel(completeTimeout);

        // Attempt to aggregate any start/complete calls within 500ms:
        completeTimeout = $timeout(function() {
          currentBar.cleanup();
          currentBar = null;
          $rootScope.$broadcast('cfpLoadingBar:completed');
        }, 500);
      }

      return {
        start            : _start,
        set              : _set,
        status           : _status,
        inc              : _inc,
        complete         : _complete,
        autoIncrement    : this.autoIncrement,
        includeSpinner   : this.includeSpinner,
        latencyThreshold : this.latencyThreshold,
        parentSelector   : this.parentSelector,
        startSize        : this.startSize
      };


    }];     //
  });       // wtf javascript. srsly
})();       //
