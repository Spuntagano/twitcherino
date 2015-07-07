module.exports = (grunt) ->

	# configuration
	grunt.initConfig

		# grunt sass
		sass:
			compile:
				options:
					style: 'expanded'
				files: [
					expand: true
					cwd: 'public/sass'
					src: ['**/*.scss']
					dest: 'public/css'
					ext: '.css'
				]

		# grunt coffee
		coffee:
			compile:
				files: [
					{
						expand: true
						cwd: 'public/app/coffee'
						src: ['**/*.coffee']
						dest: 'public/app'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'public/app/common/coffee'
						src: ['**/*.coffee']
						dest: 'public/app/common'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'public/app/account/coffee'
						src: ['**/*.coffee']
						dest: 'public/app/account'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'server/config/coffee'
						src: ['**/*.coffee']
						dest: 'server/config'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'server/controllers/coffee'
						src: ['**/*.coffee']
						dest: 'server/controllers'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'server/utilities/coffee'
						src: ['**/*.coffee']
						dest: 'server/utilities'
						ext: '.js'
					},
					{
						expand: true
						cwd: 'server/models/coffee'
						src: ['**/*.coffee']
						dest: 'server/models'
						ext: '.js'
					},
					{
						'server.js': 'server.coffee'
					}
				]
			options:
				bare: true
				preserve_dirs: true

		# grunt watch (or simply grunt)
		watch:
			html:
				files: ['**/*.html']
			sass:
				files: '<%= sass.compile.files[0].src %>'
				tasks: ['sass']
			coffee:
				files: ['<%= coffee.compile.files.src %>', '<%= coffee.compile.files[1].src %>', '<%= coffee.compile.files[2].src %>', '<%= coffee.compile.files[3].src %>', '<%= coffee.compile.files[4].src %>', '<%= coffee.compile.files[5].src %>', '<%= coffee.compile.files[6].src %>']
				tasks: ['coffee']
			options:
				livereload: true

		# load plugins
		grunt.loadNpmTasks 'grunt-contrib-sass'
		grunt.loadNpmTasks 'grunt-contrib-coffee'
		grunt.loadNpmTasks 'grunt-contrib-watch'

		# tasks
		grunt.registerTask 'default', ['sass', 'coffee', 'watch']