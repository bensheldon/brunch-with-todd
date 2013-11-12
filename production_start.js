// Production only: runs the bare server without brunch
require('coffee-script')
require('./server').startServer(process.env.PORT)
