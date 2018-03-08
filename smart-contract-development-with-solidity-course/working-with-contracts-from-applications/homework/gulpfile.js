const gulp = require('gulp');
const connect = require('gulp-connect');
const open = require('gulp-open');
const browserify = require('browserify'); // bundling js
const source = require('vinyl-source-stream'); //
const concat = require('gulp-concat'); // concatenates files

const config = {
    devBaseUrl: 'http://localhost',
    port: 3000,
    paths: {
        html: './src/*.html',
        js: './src/**/*.js',
        mainJs: './src/main.js',
        css: [
            './node_modules/bootstrap/dist/css/bootstrap.min.css',
            './node_modules/bootstrap/dist/css/bootstrap-theme.min.css',
            './node_modules/toastr/build/toastr.min.css'
        ],
        dist: './dist',
    }
}

gulp.task('connect', () => {
    connect.server({
        root: ['dist'],
        port: config.port,
        base: config.devBaseUrl,
        livereload: true
    });
});

gulp.task('open', ['connect'], () => {
    gulp
        .src('dist/index.html')
        .pipe(open({ url: `${config.devBaseUrl}:${config.port}/` }));

});

gulp.task('html', () => {
    gulp.src(config.paths.html)
        .pipe(gulp.dest(config.paths.dist))
        .pipe(connect.reload());
});

gulp.task('js', () => {
    browserify(config.paths.mainJs)
        .bundle()
        .on('error', console.error.bind(console))
        .pipe(source('bundle.js'))
        .pipe(gulp.dest(`${config.paths.dist}/scripts`))
        .pipe(connect.reload());
})

gulp.task('css', () => {
    gulp.src(config.paths.css)
        .pipe(concat('bundle.css'))
        .pipe(gulp.dest(`${config.paths.dist}/styles`))
});

gulp.task('watch', () => {
    gulp.watch(config.paths.html, ['html']);
    gulp.watch(config.paths.js, ['js']);
});

gulp.task('default', ['open', 'html', 'js', 'css', 'watch']);