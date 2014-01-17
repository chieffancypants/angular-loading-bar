angular-loading-bar
===================

The idea is simple: Add a loading bar / progress bar whenever an XHR request goes out in angular.  Multiple requests within the same time period get bundled together such that each response increments the progress bar by the appropriate amount.

This is mostly cool because you simply include it in your app, and it works.  There's no complicated setup, and no need to maintain the state of the loading bar; it's all handled automatically by the interceptor.

**Requirements:** AngularJS 1.2+


## Usage:

1. include the loading bar as a dependency for your app.  If you want animations, include `ngAnimate` as well.

    ```js
    angular.module('myApp', ['chieffancypants.loadingBar', 'ngAnimate'])
    ```
    
2. include the supplied CSS file (or create your own).
3. That's it -- you're done!

#### via bower:
```
$ bower install angular-loading-bar
```
#### via npm:
```
$ npm install angular-loading-bar
```


## Why I created this
There are a couple projects similar to this out there, but none were ideal for me.  All implementations I've seen require that you maintain state on behalf of the loading bar.  In other words, you're setting the value of the loading/progress bar manually from potentially many different locations.  This becomes complicated when you have a very large application with several services all making independant XHR requests. It becomes even more complicated if you want these services to be loosly coupled.

Additionally, Angular was created as a highly testable framework, so it pains me to see Angular modules without tests.  That is not the case here as this loading bar ships with 100% code coverage.


**Goals for this project:**

1. Make it automatic
2. Unit tests, 100% coverage
3. Must work well with ngAnimate
4. Must be styled via external CSS (not inline)
5. No jQuery dependencies


## Configuration

**Turn the spinner on or off:**  
The insertion of the spinner can be controlled through configuration.  It's on by default, but if you'd like to turn it off, simply configure the service:

```js
angular.module('myApp', ['chieffancypants.loadingBar'])
  .config(function(cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = false;
  })
```

**Turn the loading bar on or off:**  
Like the spinner configuration above, the loading bar can also be turned off for cases where you only want the spinner:

```js
angular.module('myApp', ['chieffancypants.loadingBar'])
  .config(function(cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeBar = false;
  })
```

**Ignoring particular XHR requests:**  
The loading bar can also be forced to ignore certain requests, for example, when long-polling or periodically sending debugging information back to the server.

```js
// ignore particular $http requests:
$http.get('/status', {
  ignoreLoadingBar: true
});

```


```js
// ignore particular $resource requests:
.factory('Restaurant', function($resource) {
  return $resource('/api/restaurant/:id', {id: '@id'}, {
    query: {
      method: 'GET',
      isArray: true,
      ignoreLoadingBar: true
    }
  });
});

```




## How it works:
This library is split into two components, an $http `interceptor`, and a `service`:

**Interceptor**  
The interceptor simply listens for all outgoing XHR requests, and then instructs the loadingBar service to start, stop, and increment accordingly.  There is no public API for the interceptor.

**Service**  
The service is responsible for the presentation of the loading bar.  It injects the loading bar into the DOM, adjusts the width whenever `set()` is called, and `complete()`s the whole show by removing the loading bar from the DOM.

## Service API (advanced usage)
Under normal circumstances you won't need to use this.  However, if you wish to use the loading bar without the interceptor, you can do that as well.  Simply include the loading bar service as a dependency instead of the interceptor in your angular module:

```js
angular.module('myApp', ['cfpLoadingBar'])
```


```js

cfpLoadingBar.start();
// will insert the loading bar into the DOM, and display its progress at 1%.
// It will automatically call `inc()` repeatedly to give the illusion that the page load is progressing.

cfpLoadingBar.inc();
// increments the loading bar by a random amount.
// It is important to note that the auto incrementing will begin to slow down as
// the progress increases.  This is to prevent the loading bar from appearing
// completed (or almost complete) before the XHR request has responded. 

cfpLoadingBar.set(0.3) // Set the loading bar to 30%
cfpLoadingBar.status() // Returns the loading bar's progress.
// -> 0.3

cfpLoadingBar.complete()
// Set the loading bar's progress to 100%, and then remove it from the DOM.

```

## Credits: 
Credit goes to [rstacruz](https://github.com/rstacruz) for his excellent [nProgress](https://github.com/rstacruz/nprogress).

## License:
Licensed under the MIT license


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/chieffancypants/angular-loading-bar/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

