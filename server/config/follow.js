var User, mongoose;

mongoose = require('mongoose');

User = mongoose.model('User');

exports.addFollow = function(req, res, next) {
  if (!req.user) {
    return res.send({
      success: false
    });
  } else {
    switch (req.body.platform) {
      case 'twitch':
        return User.update({
          username: req.user.username
        }, {
          $addToSet: {
            twitchFollows: req.body.channelTitle
          }
        }).exec(function(err, collection) {
          if (err) {
            res.status(400);
            res.send({
              reason: err.toString
            });
          }
          return res.send({
            success: true
          });
        });
      case 'hitbox':
        return User.update({
          username: req.user.username
        }, {
          $addToSet: {
            hitboxFollows: req.body.channelTitle
          }
        }).exec(function(err, collection) {
          if (err) {
            res.status(400);
            res.send({
              reason: err.toString
            });
          }
          return res.send({
            success: true
          });
        });
    }
  }
};

exports.removeFollow = function(req, res, next) {
  if (!req.user) {
    return res.send({
      success: false
    });
  } else {
    switch (req.body.platform) {
      case 'twitch':
        return User.update({
          username: req.user.username
        }, {
          $pull: {
            twitchFollows: req.body.channelTitle
          }
        }).exec(function(err, collection) {
          if (err) {
            res.status(400);
            res.send({
              reason: err.toString
            });
          }
          return res.send({
            success: true
          });
        });
      case 'hitbox':
        return User.update({
          username: req.user.username
        }, {
          $pull: {
            hitboxFollows: req.body.channelTitle
          }
        }).exec(function(err, collection) {
          if (err) {
            res.status(400);
            res.send({
              reason: err.toString
            });
          }
          return res.send({
            success: true
          });
        });
    }
  }
};
