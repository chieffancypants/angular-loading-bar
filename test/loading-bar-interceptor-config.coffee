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

  it 'should set loadingBar template', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.setLoadingBarTemplate('<div class="custom-loading-bar-template"></div>')
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      customTemplate = document.querySelector('.custom-loading-bar-template')
      expect(customTemplate).not.toBeNull
      cfpLoadingBar.complete()
      $timeout.flush()

  it 'should set spinner template', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.setSpinnerTemplate('<div class="custom-spinner-template"></div>')
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      customTemplate = document.querySelector('.custom-spinner-template')
      expect(customTemplate).not.toBeNull
      cfpLoadingBar.complete()
      $timeout.flush()