module.exports = function(grunt) {
  grunt.initConfig({
    pkg: grunt.file.readJSON('package.json'),
    concat: {
      css: {
        src: [
          '_includes/css/vendor/normalize.min.css',
          '_includes/css/vendor/h5bp.css',
          '_includes/css/vendor/colorbox.css',
          '_includes/css/main.css',
          '_includes/css/gallery.css',          
          '_includes/css/vendor/slicknav.css',
          '_includes/css/media.css',
          '_includes/css/print.css',
          '_includes/css/vendor/pygment_solarized.css',
        ],
        dest: '_includes/css/grunt.css'
      },
      js : {
        src : [
          '_includes/scripts/vendor/jquery.slicknav.js', 
          '_includes/scripts/vendor/jquery.colorbox-min.js',
          '_includes/scripts/plugins.js',
          '_includes/scripts/main.js'
        ],
        dest : '_includes/scripts/grunt.js'
      }
    },
    cssmin : {
      css:{
        src: '_includes/css/grunt.css',
        dest: 'assets/css/main.min.css'
      }
    },
    uglify : {
      js: {
        files: {
          'assets/scripts/main.min.js' : [ '_includes/scripts/grunt.js' ]
        }
      }
    }
  });
  grunt.loadNpmTasks('grunt-contrib-concat');
  grunt.loadNpmTasks('grunt-contrib-uglify');
  grunt.loadNpmTasks('grunt-contrib-watch');
  grunt.loadNpmTasks('grunt-contrib-cssmin');
  grunt.registerTask('default', [ 'concat:css', 'cssmin:css', 'concat:js', 'uglify:js' ]);
};