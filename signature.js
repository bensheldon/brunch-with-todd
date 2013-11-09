var mongoose = require('mongoose');

var signatureSchema = new mongoose.Schema({
  name: String,
  picture_url: String,
  created: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Signature', signatureSchema);
