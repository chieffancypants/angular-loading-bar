isLoadingBarInjected = (doc) ->
  injected = false
  divs = angular.element(doc).find('div')
  for i in divs
    if angular.element(i).attr('id') is 'loading-bar'
      injected = true
      break
  return injected

describe 'loadingBarInterceptor Service', ->

  $http = $httpBackend = $document = $timeout = result = loadingBar = $animate = null
  response = {message:'OK'}
  endpoint = '/service'

  beforeEach ->
    module 'ngAnimateMock', 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      loadingBar = cfpLoadingBarProvider
      return

    result = null
    inject (_$http_, _$httpBackend_, _$document_, _$timeout_, _$animate_) ->
      $http = _$http_
      $httpBackend = _$httpBackend_
      $document = _$document_
      $timeout = _$timeout_
      $animate = _$animate_

  beforeEach ->
    this.addMatchers
      toBeBetween: (high, low) ->
        if low > high
          temp = low
          low = high
          high = temp
        return this.actual > low && this.actual < high


  afterEach ->
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.verifyNoPendingTasks()


  it 'should not increment if the response is cached in a cacheFactory', inject (cfpLoadingBar, $cacheFactory) ->
    cache = $cacheFactory('loading-bar')
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint, cache: cache).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()
    $animate.triggerCallbacks()


    $http.get(endpoint, cache: cache).then (data) ->
      result = data
    # no need to flush $httpBackend since the response is cached
    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.flush() # loading bar is animated, so flush timeout


  it 'should not increment if the response is cached using $http.defaults.cache', inject (cfpLoadingBar, $cacheFactory) ->
    $http.defaults.cache = $cacheFactory('loading-bar')
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()
    $animate.triggerCallbacks()


    $http.get(endpoint).then (data) ->
      result = data
    # no need to flush $httpBackend since the response is cached
    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.flush() # loading bar is animated, so flush timeout


  it 'should not increment if the response is cached', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint, cache: true).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()
    $animate.triggerCallbacks()


    $http.get(endpoint, cache: true).then (data) ->
      result = data
    # no need to flush $httpBackend since the response is cached
    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.flush() # loading bar is animated, so flush timeout

  it 'should use default cache when $http.defaults.cache is true', inject (cfpLoadingBar, $cacheFactory) ->
    # $http.defaults.cache = $cacheFactory('loading-bar')
    $http.defaults.cache = true
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()
    $animate.triggerCallbacks()


    $http.get(endpoint).then (data) ->
      result = data
    # no need to flush $httpBackend since the response is cached
    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.flush() # loading bar is animated, so flush timeout

  it 'should not cache when the request is a POST', inject (cfpLoadingBar) ->
    $httpBackend.expectPOST(endpoint).respond response
    $http.post(endpoint, {message: 'post'}).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    $timeout.flush()
    $animate.triggerCallbacks()


    $httpBackend.expectPOST(endpoint).respond response
    $http.post(endpoint, {message: 'post'}).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush()
    expect(cfpLoadingBar.status()).toBe 1
    $timeout.flush()

  it 'should increment the loading bar when not all requests have been recieved', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint).then (data) ->
      result = data
    $http.get(endpoint).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 0.5

    $httpBackend.flush()
    expect(cfpLoadingBar.status()).toBe 1
    $timeout.flush() # loading bar is animated, so flush timeout


  it 'should count http errors as responses so the loading bar can complete', inject (cfpLoadingBar) ->
    # $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond 401
    $httpBackend.expectGET(endpoint).respond 401
    $http.get(endpoint)
    $http.get(endpoint)

    expect(cfpLoadingBar.status()).toBe 0
    $timeout.flush()
    $timeout.flush()
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 0.5
    $httpBackend.flush()
    expect(cfpLoadingBar.status()).toBe 1

    $timeout.flush()



  it 'should insert the loadingbar into the DOM when a request is sent', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $httpBackend.flush(1)
    $timeout.flush() # flush the latencyThreshold timeout

    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe true

    $httpBackend.flush()
    $timeout.flush()


  it 'should remove the loading bar when all requests have been received', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $httpBackend.flush(1)
    $timeout.flush() # flush the latencyThreshold timeout

    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe true

    $httpBackend.flush()
    $timeout.flush()

    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe false

  it 'should get and set status', inject (cfpLoadingBar) ->
    cfpLoadingBar.start()
    $timeout.flush()

    cfpLoadingBar.set(0.4)
    expect(cfpLoadingBar.status()).toBe 0.4

    cfpLoadingBar.set(0.9)
    expect(cfpLoadingBar.status()).toBe 0.9


    cfpLoadingBar.complete()
    $timeout.flush()

  it 'should increment things randomly', inject (cfpLoadingBar) ->
    cfpLoadingBar.start()
    $timeout.flush()

    # increments between 3 - 6%
    cfpLoadingBar.set(0.1)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(3, 6)

    cfpLoadingBar.set(0.2)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(3, 6)

    # increments between 0 - 3%
    cfpLoadingBar.set(0.25)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 3)

    cfpLoadingBar.set(0.5)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 3)

    # increments between 0 - 2%
    cfpLoadingBar.set(0.65)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 2)

    cfpLoadingBar.set(0.75)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 2)

    # increments 0.5%
    cfpLoadingBar.set(0.9)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBe 0.5

    cfpLoadingBar.set(0.97)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBe 0.5

    # stops incrementing:
    cfpLoadingBar.set(0.99)
    lbar = angular.element(document.getElementById('loading-bar'))
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBe width


    cfpLoadingBar.complete()
    $timeout.flush()


  it 'should not set the status if the loading bar has not yet been started', inject (cfpLoadingBar) ->
    cfpLoadingBar.set(0.5)
    expect(cfpLoadingBar.status()).toBe 0
    cfpLoadingBar.set(0.3)
    expect(cfpLoadingBar.status()).toBe 0

    cfpLoadingBar.start()
    cfpLoadingBar.set(0.3)
    expect(cfpLoadingBar.status()).toBe 0.3

    cfpLoadingBar.complete()
    $timeout.flush()

  it 'should broadcast started and completed events', inject (cfpLoadingBar, $rootScope) ->
    startedEventCalled = false
    completedEventCalled = false

    $rootScope.$on 'cfpLoadingBar:started', (event) ->
      startedEventCalled = true

    $rootScope.$on 'cfpLoadingBar:completed', (event) ->
      completedEventCalled = true

    expect(startedEventCalled).toBe false
    expect(completedEventCalled).toBe false

    cfpLoadingBar.start()
    expect(startedEventCalled).toBe true

    cfpLoadingBar.complete()
    expect(completedEventCalled).toBe true
    $timeout.flush()

  it 'should debounce the calls to start()', inject (cfpLoadingBar, $rootScope) ->
    startedEventCalled = 0
    $rootScope.$on 'cfpLoadingBar:started', (event) ->
      startedEventCalled += 1

    cfpLoadingBar.start()
    expect(startedEventCalled).toBe 1
    cfpLoadingBar.start()
    expect(startedEventCalled).toBe 1 # Should still be one, as complete was never called:
    cfpLoadingBar.complete()
    $timeout.flush()
    $animate.triggerCallbacks()


    cfpLoadingBar.start()
    expect(startedEventCalled).toBe 2
    cfpLoadingBar.complete()
    $timeout.flush()

  it 'should ignore requests when ignoreLoadingBar is true', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint, {ignoreLoadingBar: true})
    $httpBackend.flush()

    injected = isLoadingBarInjected $document.find(cfpLoadingBar.parentSelector)
    expect(injected).toBe false

    $timeout.flush()

  it 'should ignore responses when ignoreLoadingBar is true (#70)', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET('/service2').respond response

    $http.get(endpoint, {ignoreLoadingBar: true})
    $http.get('/service2')

    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.flush(1) # flush only the ignored request
    expect(cfpLoadingBar.status()).toBe 0

    $timeout.flush()
    $httpBackend.flush()

    expect(cfpLoadingBar.status()).toBe 1
    $timeout.flush() # loading bar is animated, so flush timeout

  it 'should ignore errors when ignoreLoadingBar is true (#70)', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond 400
    $httpBackend.expectGET('/service2').respond 400

    $http.get(endpoint, {ignoreLoadingBar: true})
    $http.get('/service2')

    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.flush(1) # flush only the ignored request
    expect(cfpLoadingBar.status()).toBe 0

    $timeout.flush()
    $httpBackend.flush()

    expect(cfpLoadingBar.status()).toBe 1
    $timeout.flush() # loading bar is animated, so flush timeout



describe 'LoadingBar only', ->
  cfpLoadingBar = $document = $timeout = $animate = null

  beforeEach ->
    module 'cfp.loadingBar', 'ngAnimateMock'

    inject (_$http_, _$httpBackend_, _$document_, _$timeout_, _$animate_, _cfpLoadingBar_) ->
      $timeout = _$timeout_
      $document = _$document_
      $animate = _$animate_
      cfpLoadingBar = _cfpLoadingBar_

  it 'should be capable of being used alone', ->
    # just a simple quick test to make sure:
    cfpLoadingBar.start()
    $timeout.flush()

    # test setting progress
    cfpLoadingBar.set(0.4)
    expect(cfpLoadingBar.status()).toBe 0.4

    # make sure it was injected into the DOM:
    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe true

    cfpLoadingBar.set(0.9)
    expect(cfpLoadingBar.status()).toBe 0.9

    # test the complete call, which should remove it from the DOM
    cfpLoadingBar.complete()
    $timeout.flush()
    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe false

  it 'should start after multiple calls to complete()', ->
    cfpLoadingBar.start()
    $timeout.flush()
    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe true

    cfpLoadingBar.complete()
    cfpLoadingBar.complete()
    cfpLoadingBar.start()
    $timeout.flush()
    $animate.triggerCallbacks()

    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe true

    cfpLoadingBar.complete()
    $timeout.flush()
    $animate.triggerCallbacks()

    expect(isLoadingBarInjected($document.find(cfpLoadingBar.parentSelector))).toBe false

