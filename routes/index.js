
/*
 * GET home page.
 */

var Signature = require('../signature');

exports.index = function(req, res){
  Signature.find({}).sort('created').limit(10).exec(function(err, results){

    res.send({
      signed: false,
      signers: results
    });

  });
};

exports.more = function(req, res){

  Signature.find().sort('created').skip(parseInt(req.params.skip)).limit(20).exec(function(err, results){
    res.send({
      signers: results
    })
  });

};