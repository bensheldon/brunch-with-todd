
/*
 * GET home page.
 */

var Signature = require('../signature');

exports.index = function(req, res){
  Signature.count(function(err, count){
    Signature.find({ picture_url: {'$ne': null } })
             .sort('-created')
             .skip(parseInt(req.query.skip || 0))
             .limit(parseInt(req.query.limit || 20))
             .exec(function(err, results){

      res.send({
        signers: results,
        count: count
      });

    });
  });
};
