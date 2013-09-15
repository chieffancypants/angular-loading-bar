

angular.module('LoadingBarExample', ['chieffancypants.loadingBar', 'ngAnimate'])
  .controller('ExampleCtrl', function ($scope, $http, $timeout, cfpLoadingBar) {
    $scope.posts = [];
    $scope.fakeIntro = true;
    $scope.section = null;
    $scope.subreddit = null;
    $scope.subreddits = ['cats', 'pics', 'funny', 'gaming', 'AdviceAnimals'];

    $scope.fetch = function() {
      $scope.subreddit = $scope.subreddits[Math.floor(Math.random() * $scope.subreddits.length)];
      console.log($scope.subreddit);

      $http.jsonp('http://www.reddit.com/r/' + $scope.subreddit + '.json?limit=50&jsonp=JSON_CALLBACK').success(function(data) {
        $scope.posts = data.data.children;
        // console.log(data.data.children[0].data);
        // console.log(data);
      });
    };

    $scope.start = function() {
      cfpLoadingBar.start();
    };

    $scope.complete = function () {
      cfpLoadingBar.complete();
    }

    $scope.start();
    $timeout(function() {
      $scope.complete();
      $scope.fakeIntro = false;
    }, 750);

  });
