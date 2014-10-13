Changelog
==========

## 0.6.0
- Customize progress bar template: ([#111](https://github.com/chieffancypants/angular-loading-bar/pull/111))
- Only append bar to first parent found ([#108](https://github.com/chieffancypants/angular-loading-bar/pull/108))

## 0.5.2:
Fixes for Angular 1.3 breaking changes:
- Circular dependencies: ([#98](https://github.com/chieffancypants/angular-loading-bar/issues/98)), ([#101](https://github.com/chieffancypants/angular-loading-bar/pull/101))
- $animate no longer accepts callbacks: ([#102](https://github.com/chieffancypants/angular-loading-bar/pull/102))

## 0.5.1
- Reworked cache logic to allow cache:true ([#96](https://github.com/chieffancypants/angular-loading-bar/pull/96))

## 0.5.0
- Added spinner template configuration ([#82](https://github.com/chieffancypants/angular-loading-bar/pull/82))
- $timeout was not canceled properly ([#79](https://github.com/chieffancypants/angular-loading-bar/pull/79))

## 0.4.3
- update z-index to work with other css frameworks ([#69](https://github.com/chieffancypants/angular-loading-bar/pull/69))
- ignoreLoadingBar not ignored when calculating percentage complete ([#70](https://github.com/chieffancypants/angular-loading-bar/pull/70))

## 0.4.2
- Split loading bar into different modules so they can be included separately ([#46](https://github.com/chieffancypants/angular-loading-bar/issues/46))

## 0.4.1
- Fix for route views defined on body where loading bar is also attached ([#56](https://github.com/chieffancypants/angular-loading-bar/issues/56))

## 0.4.0
- Initial load percentage is now configurable ([#47](https://github.com/chieffancypants/angular-loading-bar/issues/47))
- Peg graphic reworked so the loadingbar does not require CSS changes when not at the very top of the page ([#42](https://github.com/chieffancypants/angular-loading-bar/issues/42), [#45](https://github.com/chieffancypants/angular-loading-bar/issues/45), [#10](https://github.com/chieffancypants/angular-loading-bar/issues/10))
- z-index of spinner increased to work with Bootstrap 3 z-indexes ([#53](https://github.com/chieffancypants/angular-loading-bar/issues/53))

## 0.3.0
- Loading bar only appears on XHR requests with high latency ([#27](https://github.com/chieffancypants/angular-loading-bar/issues/27))

## 0.2.0
- Progression bar not calculated correctly for consecutive calls within the 500ms delay ([#29](https://github.com/chieffancypants/angular-loading-bar/issues/29), [#32](https://github.com/chieffancypants/angular-loading-bar/issues/32))
- Event broadcasts when loading (#31)

## 0.1.1
- Alias chieffancypants.loadingbar to angular-loading-bar (#25, #19)

## 0.1.0
- Fixed issues with Angular 1.2-rc3+
- Ability to ignore particular XHR requests (#21)
- Broadcasting of events (#18)
