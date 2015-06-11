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

  it 'should not auto increment loadingBar if configured', (done) ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.autoIncrement = false
      return
    inject ($timeout, cfpLoadingBar) ->
      flag = false
      cfpLoadingBar.start()
      cfpLoadingBar.set(.5)
      runs ->
        setTimeout ->
          flag = true
        , 500

      waitsFor ->
        return flag
      , "500ms timeout"
      , 1000

      runs ->
        expect(cfpLoadingBar.status()).toBe .5;
        cfpLoadingBar.complete()
        $timeout.flush()

  it 'should auto increment loadingBar if configured', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.autoIncrement = true
      return
    inject ($timeout, cfpLoadingBar) ->
      cfpLoadingBar.start()
      $timeout.flush()
      cfpLoadingBar.set(.5)
      $timeout.flush()
      expect(cfpLoadingBar.status()).toBeGreaterThan .5
      cfpLoadingBar.complete()
      $timeout.flush()
