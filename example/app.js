

angular.module('LoadingBarExample', ['chieffancypants.loadingBar', 'ngAnimate'])
  .config(function(cfpLoadingBarProvider) {
    cfpLoadingBarProvider.includeSpinner = true;
  })

  .controller('ExampleCtrl', function ($scope, $http, $timeout, $q, cfpLoadingBar) {
    $scope.posts = [];
    $scope.section = null;
    $scope.subreddit = null;
    $scope.subreddits = ['cats', 'pics', 'funny', 'gaming', 'AdviceAnimals', 'aww'];
    $scope.subweather = null;
    $scope.forecasts = [];

    var getRandomSubreddit = function() {
      var sub = $scope.subreddits[Math.floor(Math.random() * $scope.subreddits.length)];

      // ensure we get a new subreddit each time.
      if (sub === $scope.subreddit) {
        return getRandomSubreddit();
      }

      return sub;
    };

    var weatherCities = [
      "Fort Worth,Texas",
      "Lincoln,NE",
      "Kansas City,Missouri",
      "Rock Springs,WY",
      "Milwaukee,Wisconsin",
      "Augusta,Maine",
      "Bloomington,Minnesota",
      "Kansas City,MO",
      "St. Petersburg,FL",
      "Cedar Rapids,IA",
      "Tacoma,WA",
      "Missoula,MT",
      "Rochester,Minnesota",
      "West Jordan,UT",
      "Kenosha,WI",
      "Springfield,Massachusetts",
      "Anchorage,AK",
      "Colorado Springs,CO",
      "Erie,Pennsylvania",
      "Jacksonville,Florida",
      "Grand Island,Nebraska",
      "Butte,Montana",
      "Boise,Idaho",
      "Casper,WY",
      "Rockford,Illinois",
      "Madison,Wisconsin",
      "Tampa,Florida",
      "Springdale,AR",
      "Portland,ME",
      "Missoula,MT",
      "Wyoming,Wyoming",
      "Pittsburgh,PA",
      "Columbus,GA",
      "Casper,Wyoming",
      "Overland Park,KS",
      "Seattle,WA",
      "Vancouver,Washington",
      "Aurora,IL",
      "Lawton,OK",
      "Virginia Beach,VA",
      "Boise,Idaho",
      "Lakewood,Colorado",
      "Dover,DE",
      "Houston,TX",
      "Glendale,AZ",
      "Miami,Florida",
      "Cedar Rapids,IA",
      "Kenosha,WI",
      "Fort Smith,Arkansas",
      "Stamford,Connecticut",
      "Shreveport,LA",
      "Idaho Falls,ID",
      "Saint Louis,Missouri",
      "Austin,Texas",
      "Grand Island,Nebraska",
      "Bridgeport,CT",
      "Louisville,Kentucky",
      "Little Rock,Arkansas",
      "Oklahoma City,Oklahoma",
      "St. Petersburg,Florida",
      "New Haven,Connecticut",
      "Springdale,AR",
      "New Orleans,Louisiana",
      "Louisville,KY",
      "Tuscaloosa,Alabama",
      "Hilo,Hawaii",
      "Owensboro,Kentucky",
      "Tucson,AZ",
      "Nashville,Tennessee",
      "Great Falls,MT",
      "Olathe,KS",
      "Salt Lake City,Utah",
      "Memphis,TN",
      "Wyoming,Wyoming",
      "Great Falls,Montana",
      "Memphis,Tennessee",
      "Pocatello,Idaho",
      "Great Falls,MT",
      "Jonesboro,AR",
      "Sterling Heights,Michigan",
      "Kaneohe,HI",
      "Gary,Indiana",
      "Norfolk,VA",
      "Wyoming,Wyoming",
      "Mesa,Arizona",
      "Nashville,Tennessee",
      "Jefferson City,MO",
      "Racine,Wisconsin",
      "Fort Wayne,IN",
      "Madison,WI",
      "Montpelier,VT",
      "Aurora,IL",
      "Georgia,Georgia",
      "Baltimore,Maryland",
      "Clarksville,Tennessee",
      "Rockville,MD",
      "Minneapolis,Minnesota",
      "Wichita,Kansas",
      "Chesapeake,VA",
      "Juneau,AK"
    ];

    $scope.fetch = function() {
      $scope.subweather = null;
      $scope.subreddit = getRandomSubreddit();
      $http.jsonp('http://www.reddit.com/r/' + $scope.subreddit + '.json?limit=50&jsonp=JSON_CALLBACK').success(function(data) {
        $scope.posts = data.data.children;
      });
    };

    $scope.fetchChain = function() {
      $scope.subreddit = null;
      $scope.subweather = true;
      $scope.forecasts = [];
      var initialDeferred = $q.defer();
      var promises = [initialDeferred.promise];
      var weatherUrl = 'http://api.openweathermap.org/data/2.5/weather?q=';

      var currentCity;
      var makeRequestForCity = function(city, setExpectedRequests) {
        return function() {
          var config = {};
          if (setExpectedRequests) {
            config.loadingBarShouldExpect = weatherCities.length;
          }
          return $http.get(weatherUrl + city, config).success(function(data) {
            $scope.forecasts.push({
              city: data.name,
              condition: data.weather.pop().description
            });
          });
        };
      };

      var cities = angular.copy(weatherCities);

      while ((currentCity = cities.pop())) {
        var newPromise = promises[promises.length - 1].finally(makeRequestForCity(currentCity, promises.length === 1));
        promises.push(newPromise);
      }

      initialDeferred.resolve();
    };

    $scope.start = function() {
      cfpLoadingBar.start();
    };

    $scope.complete = function () {
      cfpLoadingBar.complete();
    };


    // fake the initial load so first time users can see it right away:
    $scope.start();
    $scope.fakeIntro = true;
    $timeout(function() {
      $scope.complete();
      $scope.fakeIntro = false;
    }, 750);

  });
