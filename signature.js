var mongoose = require('mongoose');
var findOrCreate = require('mongoose-findorcreate')

var signatureSchema = new mongoose.Schema({
  socialType: String,
  socialId: Number,
  name: String,
  picture_url: String,
  created: { type: Date, default: Date.now }
});

signatureSchema.plugin(findOrCreate);

module.exports = mongoose.model('Signature', signatureSchema);
