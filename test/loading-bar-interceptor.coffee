isLoadingBarInjected = (doc) ->
  injected = false
  divs = angular.element(doc).find('div')
  for i in divs
    if angular.element(i).attr('id') is 'loading-bar'
      injected = true
      break
  return injected

describe 'loadingBarInterceptor Service', ->

  $http = $httpBackend = $document = $timeout = result = loadingBar = null
  response = {message:'OK'}
  endpoint = '/service'

  beforeEach ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      loadingBar = cfpLoadingBarProvider
      return

    result = null
    inject (_$http_, _$httpBackend_, _$document_, _$timeout_) ->
      $http = _$http_
      $httpBackend = _$httpBackend_
      $document = _$document_
      $timeout = _$timeout_

  afterEach ->
    $httpBackend.verifyNoOutstandingRequest()
    $timeout.verifyNoPendingTasks()


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
    $httpBackend.verifyNoOutstandingRequest()
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

    $httpBackend.verifyNoOutstandingRequest()
    $timeout.flush()



  it 'should insert the loadingbar into the DOM when a request is sent', ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $httpBackend.flush(1)
    divs = angular.element($document[0].body).find('div')

    injected = isLoadingBarInjected $document[0].body

    expect(injected).toBe true
    $httpBackend.flush()
    $timeout.flush()


  it 'should remove the loading bar when all requests have been received', ->
    $httpBackend.expectGET(endpoint).respond response
    $httpBackend.expectGET(endpoint).respond response
    $http.get(endpoint)
    $http.get(endpoint)

    $timeout.flush() # loading bar is animated, so flush timeout
    expect(isLoadingBarInjected($document[0].body)).toBe true

    $httpBackend.flush()
    $timeout.flush()

    expect(isLoadingBarInjected($document[0].body)).toBe false

  it 'should get and set status', inject (cfpLoadingBar) ->
    cfpLoadingBar.start()
    $timeout.flush()

    cfpLoadingBar.set(0.4)
    expect(cfpLoadingBar.status()).toBe 0.4

    cfpLoadingBar.set(0.9)
    expect(cfpLoadingBar.status()).toBe 0.9


    cfpLoadingBar.complete()
    $timeout.flush()
