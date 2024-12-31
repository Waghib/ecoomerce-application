const checkRole = role => (req, res, next) => {
  if (!req.user) {
    return res.status(401).send('Unauthorized');
  }

  if (req.user.role !== role) {
    return res.status(403).send('You are not allowed to make this request.');
  }

  return next();
};

const check =
  (...roles) =>
  (req, res, next) => {
    if (!req.user) {
      return res.status(401).send('Unauthorized');
    }

    const hasRole = roles.find(role => req.user.role === role);
    if (!hasRole) {
      return res.status(403).send('You are not allowed to make this request.');
    }

    return next();
  };

module.exports = { checkRole, check };
