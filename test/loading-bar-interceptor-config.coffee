describe 'loadingBarInterceptor Service - config options', ->

  it 'should hide the spinner if configured', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.includeSpinner = false
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      spinner = document.getElementById('loading-bar-spinner')
      expect(spinner).toBeNull
      cfpLoadingBar.complete()
      $timeout.flush()

  it 'should show the spinner if configured', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.includeSpinner = true
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      spinner = document.getElementById('loading-bar-spinner')
      expect(spinner).not.toBeNull
      cfpLoadingBar.complete()
      $timeout.flush()

  it 'should hide the loadingBar if configured', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.includeBar = false
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      spinner = document.getElementById('loading-bar-spinner')
      expect(spinner).toBeNull
      cfpLoadingBar.complete()
      $timeout.flush()

  it 'should show the loadingBar if configured', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.includeBar = true
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      spinner = document.getElementById('loading-bar-spinner')
      expect(spinner).not.toBeNull
      cfpLoadingBar.complete()
      $timeout.flush()

