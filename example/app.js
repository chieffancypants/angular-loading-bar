

angular.module('LoadingBarExample', ['chieffancypants.loadingBar'])
  .controller('ExampleCtrl', function ($scope, $http, cfpLoadingBar) {
    $scope.posts = [];

    $scope.fetch = function(subreddit) {
      console.log('trying to load', subreddit);
      if (subreddit) {
        subreddit = '/r/' + subreddit;
      } else {
        subreddit = '';
      }
      $http.jsonp('http://reddit.com/' + subreddit + '.json?jsonp=JSON_CALLBACK').success(function(data) {
        $scope.posts = data.data.children;
        console.log(data.data.children[0].data);
      });
    };

    $scope.fetch();


  });
