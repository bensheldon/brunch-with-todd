# GLOBALS
APP_HOST = process.env.APP_HOST || "http://stand-with-todd.herokuapp.com"
REDIRECT_AFTER_SIGNED = process.env.REDIRECT_AFTER_SIGNED || "http://www.lettoddwork.org?signed=true"

MONGOHQ_URL = process.env.MONGOHQ_URL || "mongodb://localhost/stand-with-todd"

EXPRESS_SESSION_SECRET = process.env.EXPRESS_SESSION_SECRET

FACEBOOK_CLIENT_ID = process.env.FACEBOOK_CLIENT_ID
FACEBOOK_CLIENT_SECRET = process.env.FACEBOOK_CLIENT_SECRET
TWITTER_CONSUMER_KEY = process.env.TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET = process.env.TWITTER_CONSUMER_SECRET


# DEPENDENCIES
express = require("express")
http = require("http")
path = require("path")
mongoose = require("mongoose")
findOrCreate = require("mongoose-findorcreate")
passport = require("passport")
FacebookStrategy = require("passport-facebook").Strategy
TwitterStrategy = require("passport-twitter").Strategy

# MONGOOSE + SIGNATURE MODEL
mongoose.connect MONGOHQ_URL
signatureSchema = new mongoose.Schema(
  socialType: String
  socialId: String
  name: String
  picture_url:
    type: String
    index: true

  created:
    type: Date
    default: Date.now
    index: true
)
signatureSchema.plugin findOrCreate
Signature = mongoose.model("Signature", signatureSchema)
createSignature = (socialType, socialId, userParams, cb) ->
  Signature.findOrCreate
    socialType: socialType
    socialId: socialId
  , userParams, (err, user) ->
    return err  if err
    cb()

# BOILERPLATE EXPRESS SETUP
app = express()
app.set "trust proxy", true
app.use (req, res, next) ->
  res.header "Access-Control-Allow-Origin", "*"
  res.header "Access-Control-Allow-Headers", "X-Requested-With"
  next()

app.configure ->
  app.use express.favicon()
  app.use express.logger("dev")
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session(secret: EXPRESS_SESSION_SECRET)
  app.use passport.initialize()
  app.use passport.session()
  app.use app.router
  app.use express.static(path.join(__dirname, "public"))

app.configure "development", ->
  app.use express.errorHandler()


# MAIN API ENDPOINT
app.get "/api", (req, res) ->
  Signature.count (err, count) ->
    Signature
      .find(
        picture_url:
          $ne: null
      )
      .sort("-created")
      .skip(parseInt(req.query.skip || 0))
      .limit(parseInt(req.query.limit || 20))
      .exec (err, results) ->
        res.send
          signers: results
          count: count

# PASSPORT STRATEGIES
passport.use new FacebookStrategy(
  clientID: FACEBOOK_CLIENT_ID
  clientSecret: FACEBOOK_CLIENT_SECRET
  callbackURL: APP_HOST + "/sign/facebook/callback"
  profileFields: ["id", "displayName", "photos"]
, (accessToken, refreshToken, profile, done) ->
  createSignature "fb", profile.id,
    name: profile.displayName
    picture_url: (profile.photos[0] and profile.photos[0].value.replace("_q.jpg", "_n.jpg"))
  , done
)
passport.use new TwitterStrategy(
  consumerKey: TWITTER_CONSUMER_KEY
  consumerSecret: TWITTER_CONSUMER_SECRET
  callbackURL: APP_HOST + "/sign/twitter/callback"
, (token, tokenSecret, profile, done) ->
  createSignature "twitter", profile.id,
    name: profile.displayName
    picture_url: (profile.photos[0] and profile.photos[0].value.replace("_normal", ""))
  , done
)
passport_redirects =
  successRedirect: "#{APP_HOST}/?signed=true"
  failureRedirect: "#{APP_HOST}/?signed=true"

app.get "/sign/facebook", passport.authenticate("facebook", { scope: "email" })
app.get "/sign/facebook/callback", passport.authenticate("facebook", passport_redirects)
app.get "/sign/twitter", passport.authenticate("twitter")
app.get "/sign/twitter/callback", passport.authenticate("twitter", passport_redirects)

exports.startServer = (port, path, callback) ->
  http.createServer(app).listen port, ->
    console.log "Express server listening on port #{port}"
