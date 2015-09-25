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

  it 'should append the loadingbar as the first child of the parent container if empty', ->
    emptyEl = angular.element '<div id="empty"></div>'
    angular.element(document).find('body').eq(0).append emptyEl

    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.parentSelector = '#empty'
      return
    inject ($timeout, $document, cfpLoadingBar) ->
      cfpLoadingBar.start()
      parent = $document[0].querySelector(cfpLoadingBar.parentSelector)
      children = parent.childNodes
      expect(children.length).toBe 2
      expect(children[0].id).toBe 'loading-bar'
      expect(children[1].id).toBe 'loading-bar-spinner'
      cfpLoadingBar.complete()
      $timeout.flush()

  it 'should append the loading bar to the body if parentSelector is empty', ->
    module 'chieffancypants.loadingBar', (cfpLoadingBarProvider) ->
      cfpLoadingBarProvider.parentSelector = '#doesnotexist'
      return
    inject ($timeout, $document, cfpLoadingBar) ->
      parent = $document[0].querySelector(cfpLoadingBar.parentSelector)
      expect(parent).toBeFalsy;
      body = $document[0].querySelector 'body'
      cfpLoadingBar.start()
      bar = angular.element(body.querySelector '#loading-bar');
      spinner = angular.element(body.querySelector '#loading-bar-spinner');
      expect(bar.length).toBe 1
      expect(spinner.length).toBe 1
      cfpLoadingBar.complete()
      $timeout.flush()
