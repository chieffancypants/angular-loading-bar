

angular.module('LoadingBarExample', ['chieffancypants.loadingBar'])
  .controller('ExampleCtrl', function ($scope, $http, cfpLoadingBar) {
    $scope.posts = [];

    $http.jsonp('http://reddit.com/.json?jsonp=JSON_CALLBACK').success(function(data) {
      $scope.posts = data.data.children;
      console.log(data);
    });
  });
