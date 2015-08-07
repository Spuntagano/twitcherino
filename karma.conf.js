// Karma configuration
// Generated on Thu Aug 06 2015 09:58:34 GMT-0400 (Est (heure d’été))

module.exports = function(config) {
  config.set({

    // base path that will be used to resolve all patterns (eg. files, exclude)
    basePath: '',


    // frameworks to use
    // available frameworks: https://npmjs.org/browse/keyword/karma-adapter
    frameworks: ['mocha'],


    // list of files / patterns to load in the browser
    files: [
      "public/bower_components/jquery/dist/jquery.js",
      "public/bower_components/toastr/toastr.js",
      "public/bower_components/bootstrap/dist/js/bootstrap.js",
      "public/bower_components/angular/angular.js",
      "public/bower_components/angular-route/angular-route.js",
      "public/bower_components/angular-resource/angular-resource.js",
      "public/bower_components/angular-mocks/angular-mocks.js",
      "public/app/config.js",
      "public/app/app.js",
      "public/app/services.js",
      "public/app/directives.js",
      "public/app/controllers.js",
      "public/app/account/mvUserCtrl.js",
      "public/app/account/mvFollowCtrl.js",
      "public/app/account/mvLoginCtrl.js",
      "public/app/channel/mvChannelCtrl.js",
      "public/app/channels/mvChannelsCtrl.js",
      "public/app/games/mvGamesCtrl.js",
      "public/app/gameschannels/mvGamesChannelsCtrl.js",
      "public/app/account/mvUser.js",
      "public/app/account/mvIdentity.js",
      "public/app/account/mvAuth.js",
      "public/app/account/mvFollow.js",
      "public/app/common/mvNotifier.js",
      "public/app/common/mvRedirect.js",
      "public/app/navbar/mvNavbarCtrl.js",
      "public/bower_components/nginfinitescroll/build/ng-infinite-scroll.js",
      "public/bower_components/numeral/numeral.js",
      "public/vendors/js/attrchange.js",
      "public/app/scripts.js",

      //'server/**/*.js',
      'karma/**/*.js'
    ],


    // list of files to exclude
    exclude: [
    ],


    // preprocess matching files before serving them to the browser
    // available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
    preprocessors: {
    },


    // test results reporter to use
    // possible values: 'dots', 'progress'
    // available reporters: https://npmjs.org/browse/keyword/karma-reporter
    reporters: ['progress'],


    // web server port
    port: 9876,


    // enable / disable colors in the output (reporters and logs)
    colors: true,


    // level of logging
    // possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
    logLevel: config.LOG_INFO,


    // enable / disable watching file and executing tests whenever any file changes
    autoWatch: true,


    // start these browsers
    // available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
    browsers: ['Chrome'],


    // Continuous Integration mode
    // if true, Karma captures browsers, runs the tests and exits
    singleRun: false
  });
};
