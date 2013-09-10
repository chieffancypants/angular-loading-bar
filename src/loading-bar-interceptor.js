/*
 * angular-loading-bar
 *
 * intercepts XHR requests and creates a loading bar when that shit happens.
 * Based on the excellent nprogress work by rstacruz (more info in readme)
 * 
 * (c) 2013 Wes Cruver
 * License: MIT
 */



/**
 * loadingBarInterceptor service
 *
 * Registers itself as an Angular interceptor and listens for XHR requests.
 */
angular.module('chieffancypants.loadingBar', [])
  .factory('loadingBarInterceptor', function($q, loadingBar) {

    /**
     * The total number of requests made
     * @type {Number}
     */
    var reqsTotal = 0;

    /**
     * The number of requests completed (either successfully or not)
     * @type {Number}
     */
    var reqsCompleted = 0;


    /**
     * increments the reqsCompleted, and checks if all XHR requests have
     * completed.  If so, it calls loadingBar.complete() which removes the 
     * loading bar from the DOM.
     */
    function checkComplete() {
      reqsCompleted++;
      if (reqsCompleted === reqsTotal) {
        loadingBar.complete();
      }
    }

    return {
      'request': function(config) {
        reqsTotal++;
        return config;
      },

      'response': function(response) {
        checkComplete();
        loadingBar.set(reqsCompleted / reqsTotal);
        return response;
      },

      'responseError': function(rejection) {
        checkComplete();
        loadingBar.set(reqsCompleted / reqsTotal);
        return $q.reject(rejection);
      }

    };
  })

  /**
   * Loading Bar
   *
   * This service handles actually adding and removing the element from the DOM.
   * Because this is such a light-weight element, the 
   */
  .factory('cfpLoadingBar', ['$document', '$timeout', function ($document, $timeout) {
    'use strict';

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
      var pct = _status() + (Math.random() / 100);
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
        $timeout(function() {
          loadingBar.css('opacity', 0);
          started = false;
        }, 500);
      }

    };
  }]);

