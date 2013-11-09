
/**
 * Module dependencies.
 */

var express = require('express')
  , routes = require('./routes')
  , http = require('http')
  , path = require('path')
  , mongoose = require('mongoose')
  , passport = require('passport')
  , FacebookStrategy = require('passport-facebook').Strategy;

mongoose.connect('mongodb://localhost/norum');

var Signature = require('./signature');

passport.use(new FacebookStrategy({
    clientID: '441658239274026',
    clientSecret: 'afd01dad95a3917e7ddc47b36df38aa2',
    callbackURL: "http://stand-with-todd.herokuapp.com/sign/facebook/callback",
    profileFields: ['id', 'displayName', 'photos']
  },
  function(accessToken, refreshToken, profile, done) {
    Signature.findOrCreate({socialType: 'fb', socialId: 1}, function(err, user) {
      if (err) { return done(err); }

      try {
        var pictureUrl = profile._json.picture.data.url.replace('_q.jpg', '_n.jpg');
      } catch (err) {
        var pictureUrl = null;
      }

      user.name = profile.displayName;
      user.picture_url = pictureUrl;
      user.save();


      console.log(user);

      done(null, null);
    });
  }
));

var app = express();

app.set("trust proxy", true);

app.use(function(req,res,next){
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "X-Requested-With");
  next();
});

app.configure(function(){
  app.set('port', process.env.PORT || 3000);
  app.use(express.favicon());
  app.use(express.logger('dev'));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(express.cookieParser());
  app.use(express.session({ secret: 'asdlfkajsdflkjsdflfj' }));
  app.use(passport.initialize());
  app.use(passport.session());
  app.use(app.router);
  app.use(express.static(path.join(__dirname, 'public')));
});

app.configure('development', function(){
  app.use(express.errorHandler());
});

app.get('/', routes.index);
app.get('/more', routes.more);


app.get('/sign/facebook', passport.authenticate('facebook', { scope: 'email' }));
app.get('/sign/facebook/callback', passport.authenticate('facebook', {
  successRedirect: 'http://www.standwithtodd.com?signed=true', failureRedirect: 'http://www.standwithtodd.com?signed=true'
}));

http.createServer(app).listen(app.get('port'), function(){
  console.log("Express server listening on port " + app.get('port'));
});
