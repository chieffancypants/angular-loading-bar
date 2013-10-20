isLoadingBarInjected = (rootEl) ->
  injected = false
  divs = angular.element(rootEl).find('div')
  for i in divs
    if angular.element(i).attr('id') is 'loading-bar'
      injected = true
      break
  return injected

findById = (rootEl, id) ->
  divs = angular.element(rootEl).find('div')
  for i in divs
    i = angular.element(i)
    if i.attr('id') is id
      return i

endpoint = '/service'
response = {message: 'OK'}


describe 'loadingBar Interceptor', ->

  $http = $httpBackend = $timeout = null

  beforeEach ->
    module 'chieffancypants.loadingBar'

    inject (_$http_, _$httpBackend_, _$timeout_) ->
      $http = _$http_
      $httpBackend = _$httpBackend_
      $timeout = _$timeout_

  afterEach ->
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.verifyNoPendingTasks()


  it 'should not increment if the response is cached in a cacheFactory', inject (cfpLoadingBar, $cacheFactory) ->
    cache = $cacheFactory('loading-bar')
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint, cache: cache).then (data) ->
      result = data

    expect(cfpLoadingBar.status()).toBe 0
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()

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
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()

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
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    cfpLoadingBar.complete() # set as complete
    $timeout.flush()

    $http.get(endpoint, cache: true).then (data) ->
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
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 1
    $timeout.flush()


    $httpBackend.expectPOST(endpoint).respond response
    $http.post(endpoint, {message: 'post'}).then (data) ->
      result = data
    expect(cfpLoadingBar.status()).toBe 0
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
    $httpBackend.flush(1)
    expect(cfpLoadingBar.status()).toBe 0.5
    $httpBackend.flush()
    expect(cfpLoadingBar.status()).toBe 1

    $timeout.flush()



describe 'Loading Bar Service', ->

  $http = $httpBackend = $rootElement = $timeout = result = loadingBar = $document = null

  beforeEach ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.includeSpinner = false
      loadingBar = cfpLoadingBarProvider
      return

    result = null
    inject (_$http_, _$httpBackend_, _$rootElement_, _$document_, _$timeout_) ->
      $http = _$http_
      $httpBackend = _$httpBackend_
      $timeout = _$timeout_
      $rootElement = _$rootElement_
      $document = _$document_

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


  it 'should insert the loadingbar into the DOM when a request is sent', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $httpBackend.flush(1)

    injected = isLoadingBarInjected $rootElement

    expect(injected).toBe true
    $httpBackend.flush()
    $timeout.flush()

  it 'should insert the loadingbar into a specified parent element', inject (cfpLoadingBar) ->
    cfpLoadingBar.parentSelector = 'div'
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $httpBackend.flush(1)

    injected = isLoadingBarInjected $rootElement

    expect(injected).toBe true
    $httpBackend.flush()
    $timeout.flush()

  it 'should remove the loading bar when all requests have been received', inject (cfpLoadingBar) ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $timeout.flush() # loading bar is animated, so flush timeout
    expect(isLoadingBarInjected($rootElement)).toBe true

    $httpBackend.flush()
    $timeout.flush()

    expect(isLoadingBarInjected($rootElement)).toBe false

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
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(3, 6)

    cfpLoadingBar.set(0.2)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(3, 6)

    # increments between 0 - 3%
    cfpLoadingBar.set(0.25)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 3)

    cfpLoadingBar.set(0.5)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 3)

    # increments between 0 - 2%
    cfpLoadingBar.set(0.65)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 2)

    cfpLoadingBar.set(0.75)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBeBetween(0, 2)

    # increments 0.5%
    cfpLoadingBar.set(0.9)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBe 0.5

    cfpLoadingBar.set(0.97)
    lbar = findById($rootElement, 'loading-bar')
    width = lbar.children().css('width').slice(0, -1)
    $timeout.flush()
    width2 = lbar.children().css('width').slice(0, -1)
    expect(width2).toBeGreaterThan width
    expect(width2 - width).toBe 0.5

    # stops incrementing:
    cfpLoadingBar.set(0.99)
    lbar = findById($rootElement, 'loading-bar')
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



describe 'Tests around non-defaults', ->

  $http = $httpBackend = $rootElement = $timeout = loadingBar = $document = null

  beforeEach ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.includeSpinner = false
      # cfpLoadingBarProvider.parentSelector = 'div'
      loadingBar = cfpLoadingBarProvider
      return

    inject (_$http_, _$httpBackend_, _$rootElement_, _$document_, _$timeout_) ->
      $http = _$http_
      $httpBackend = _$httpBackend_
      $timeout = _$timeout_
      $rootElement = _$rootElement_
      $document = _$document_

  it 'should hide the spinner if configured', inject (cfpLoadingBar) ->
    cfpLoadingBar.start()
    spinner = findById($rootElement, 'loading-bar-spinner')
    expect(spinner).toBeNull
    cfpLoadingBar.complete()
    $timeout.flush()

