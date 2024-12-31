const router = require('express').Router();

const authRoutes = require('./auth');
const productRoutes = require('./product');
const categoryRoutes = require('./category');
const brandRoutes = require('./brand');
const contactRoutes = require('./contact');
const merchantRoutes = require('./merchant');
const cartRoutes = require('./cart');
const orderRoutes = require('./order');
const reviewRoutes = require('./review');
const userRoutes = require('./user');
const addressRoutes = require('./address');
const wishlistRoutes = require('./wishlist');
const newsletterRoutes = require('./newsletter');
const adminRoutes = require('./admin');

// auth routes
router.use('/auth', authRoutes);

// product routes
router.use('/product', productRoutes);

// category routes
router.use('/category', categoryRoutes);

// brand routes
router.use('/brand', brandRoutes);

// contact routes
router.use('/contact', contactRoutes);

// merchant routes
router.use('/merchant', merchantRoutes);

// cart routes
router.use('/cart', cartRoutes);

// order routes
router.use('/order', orderRoutes);

// review routes
router.use('/review', reviewRoutes);

// user routes
router.use('/user', userRoutes);

// address routes
router.use('/address', addressRoutes);

// wishlist routes
router.use('/wishlist', wishlistRoutes);

// newsletter routes
router.use('/newsletter', newsletterRoutes);

// admin routes
router.use('/admin', adminRoutes);

module.exports = router;
