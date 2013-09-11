/*
 * angular-loading-bar
 *
 * intercepts XHR requests and creates a loading bar when that shit happens.
 * Based on the excellent nprogress work by rstacruz (more info in readme)
 *
 * (c) 2013 Wes Cruver
 * License: MIT
 */


(function() {

  'use strict';

/**
 * loadingBarInterceptor service
 *
 * Registers itself as an Angular interceptor and listens for XHR requests.
 */
angular.module('chieffancypants.loadingBar', [])
  .config(['$httpProvider', function($httpProvider) {

    var interceptor = ['$q', 'cfpLoadingBar', function ($q, cfpLoadingBar) {

      /**
       * The total number of requests made
       */
      var reqsTotal = 0;

      /**
       * The number of requests completed (either successfully or not)
       */
      var reqsCompleted = 0;


      /**
       * calls cfpLoadingBar.complete() which removes the
       * loading bar from the DOM.
       */
      function setComplete() {
        cfpLoadingBar.complete();
        reqsCompleted = 0;
        reqsTotal = 0;
      }

      return {
        'request': function(config) {
          if (reqsTotal === 0) {
            cfpLoadingBar.start();
            console.log('start that shit', reqsCompleted, reqsTotal);
          }
          reqsTotal++;
          console.log('request', reqsCompleted, reqsTotal);
          return config;
        },

        'response': function(response) {
          reqsCompleted++;
          console.log('set complete', reqsCompleted, reqsTotal);
          if (reqsCompleted === reqsTotal) {
            setComplete();
          } else {
            cfpLoadingBar.set(reqsCompleted / reqsTotal);
          }
          return response;
        },

        'responseError': function(rejection) {
          reqsCompleted++;
          console.log('set complete fail', reqsCompleted, reqsTotal);
          if (reqsCompleted === reqsTotal) {
            setComplete();
          } else {
            cfpLoadingBar.set(reqsCompleted / reqsTotal);
          }
          return $q.reject(rejection);
        }
      };
    }];

    $httpProvider.interceptors.push(interceptor);
  }])


  /**
   * Loading Bar
   *
   * This service handles actually adding and removing the element from the DOM.
   * Because this is such a light-weight element, the
   */
  .factory('cfpLoadingBar', ['$document', '$timeout', function ($document, $timeout) {

    var $body = $document.find('body'),
      loadingBarContainer = angular.element('<div id="loading-bar"><div class="bar"><div class="peg"></div></div></div>'),
      loadingBar = loadingBarContainer.find('div').eq(0);

    var started = false,
      status = 0;


    /**
     * Inserts the loading bar element into the dom, and sets it to 1%
     */
    function _start() {
      started = true;
      $body.append(loadingBarContainer);
      loadingBar.css('width', '1%').css('opacity', 1);
    }

    /**
     * Set the loading bar's width to a certain percent.
     *
     * @param n any value between 0 and 1
     */
    function _set(n) {
      if (!started) {
        _start();
      }
      var pct = (n * 100) + '%';
      loadingBar.css('width', pct);
      status = n;

      // give the illusion that there is always progress...
      $timeout(function() {
        _inc();
      }, 500);
    }

    /**
     * Increments the loading bar by a random amount between .1% and .9%
     */
    function _inc() {
      if (_status() >= 1) {
        return;
      }
      var pct = _status() + (Math.random() / 10);
      _set(pct);
      console.log('status is', _status());
    }

    function _status() {
      return status;
    }

    return {
      start: _start,
      set: _set,
      status: _status,

      complete: function () {
        _set(1);
        $timeout(function() {
          loadingBar.css('opacity', 0);
          status = 0;
          started = false;
        }, 500);
      }

    };
  }]);


})();
