angular-loading-bar
===================

Automatically add a loading bar to your angular apps, automatically.  Automatic.


## Why I created this

I made this for two reasons:
1. To make sure it was automatic
2. To make sure it was fully tested

### Automated
There are a couple projects similar to this out there, but none are ideal.  All implementations I've seen are based on the excellent [nprogress](https://github.com/rstacruz/nprogress) by rstacruz, which requires that you maintain state on behalf of the loading bar.  In other words, you're setting the value of the loading/progress bar manually from potentially many different locations.  This becomes complicated when you have a very large application with several services all making independant XHR requests.

### Tested
The basis of Angular is that it's easy to test.  So it pains me to see angular modules without tests. This loading bar aims for 100% code coverage.
