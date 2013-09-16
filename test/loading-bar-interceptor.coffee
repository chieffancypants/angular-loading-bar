describe 'loadingBarInterceptor Service', ->

	$http = $httpBackend = $document = result = null
	response = {message:'OK'}
	endpoint = '/service'

	beforeEach ->
		angular.module 'chieffancypants.loadingBar'
		result = null
		inject (_$http_, _$httpBackend_, _$document_) ->
			$http = _$http_
			$httpBackend = _$httpBackend_
			$document = _$document_

	it 'should insert the loadingbar when a request is sent', ->
		$httpBackend.expectGET(endpoint).respond response
		$http.get(endpoint).then (data) ->
			result = data


		$httpBackend.flush()
		expect(result.data.message).toBe 'OK'




		# $httpBackend.expectGET(endpoint).respond 401, {result: 'failure'}
