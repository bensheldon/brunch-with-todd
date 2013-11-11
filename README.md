stand-with-todd-backend
=======================

backend for #LetToddWork. just a simple platform for collecting "signatures" via Twitter or Facebook. doesn't actually store any information beyond a user's social ID, name, and picture url.

#### To run:

> Make sure you have [foreman](https://github.com/ddollar/foreman) installed.

1. copy `.env.example` to `.env` and configure with proper environment variables
2. `foreman start -f Procfile_dev`

#### To deploy on Heroku

1. `heroku create STACKNAME`
2. `heroku addons:add mongohq`
3. `heroku config:set [all the environment variables]`
4. `git push heroku master`
