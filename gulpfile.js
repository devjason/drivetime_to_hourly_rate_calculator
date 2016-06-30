/* Gulpfile for building application
  Thanks to Dennis Reimann https://gist.github.com/dennisreimann/cd8d45eefaba43199dcd
*/
var gulp   = require('gulp');
var elm    = require('gulp-elm');
var uglify = require('gulp-uglify');
var del    = require('del');

var paths = {
  dest: 'dist',
  elm: 'src/*.elm',
  static: 'src/*.{html,css}'
};

gulp.task('clean', function(cb) {
  del([paths.dest], cb);
});

gulp.task('elm-init', elm.init);
gulp.task('elm', ['elm-init'], function() {
  return gulp.src(paths.elm)
    .pipe(elm())
    .pipe(uglify())
    .pipe(gulp.dest(paths.dest));
});

gulp.task('static', function() {
  return gulp.src(paths.static)
    .pipe(gulp.dest(paths.dest));
});

gulp.task('watch', function() {
  gulp.watch(paths.elm, ['elm']);
  gulp.watch(paths.static, ['static']);
});

gulp.task('default', ['elm', 'static']);
