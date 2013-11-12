# See http://brunch.io/#documentation for docs.
exports.config =
  paths:
    public: 'public'

  files:
    javascripts:
      defaultExtension: 'coffee'
      joinTo:
        'javascripts/app.js': /^app/
        'javascripts/vendor.js': /^(vendor|bower_components)/

    stylesheets:
      defaultExtension: 'styl'
      joinTo:
        'stylesheets/app.css': /^(app|vendor(\/|\\)(?!test))/

   plugins:
      jade:
        options:          # can be added all the supported jade options
          pretty: yes     # Adds pretty-indentation whitespaces to output (false by default)
                          # ...
        locals:           # locals can be added
          foo: 'jade is cool'
      jaded:
        staticPatterns: /^app(\/|\\)(.+)\.html.jade$/

  # http://hackerpreneurialism.com/post/43379675961/nodejs-with-bunch-io#
  server:
    path: 'server.coffee'
    port: 3000
    base: '/'
    run: yes
