var mongoose = require('mongoose');
var findOrCreate = require('mongoose-findorcreate')

var signatureSchema = new mongoose.Schema({
  socialType: String,
  socialId: String,
  name: String,
  picture_url: { type: String, index: true },
  created: { type: Date, default: Date.now, index: true }
});

signatureSchema.plugin(findOrCreate);

module.exports = mongoose.model('Signature', signatureSchema);
