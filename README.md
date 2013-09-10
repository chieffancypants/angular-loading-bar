angular-loading-bar
===================

The idea is simple: Add a loading bar whenever an XHR request goes out in angular.  Multiple requests within the same time period get bundled together such that each response increments the progress bar by the appropriate amount.

This is mostly cool because you simply include it in your app, and it works, and it's pretty.  There's no complicated setup, or need to maintain the state of the loading bar.

## Requirements:
Angular 1.2+

## Why I created this

Two goals for this project:

1. Make it automatic
2. 100% code coverage

### Automated
There are a couple projects similar to this out there, but none are ideal.  All implementations I've seen are based on the excellent [nprogress](https://github.com/rstacruz/nprogress) by rstacruz, which requires that you maintain state on behalf of the loading bar.  In other words, you're setting the value of the loading/progress bar manually from potentially many different locations.  This becomes complicated when you have a very large application with several services all making independant XHR requests.

### Tested
The basis of Angular is that it's easy to test.  So it pains me to see angular modules without tests. This loading bar aims for 100% code coverage.
