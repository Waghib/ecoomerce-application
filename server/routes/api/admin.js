const express = require('express');
const router = express.Router();

// Bring in Models & Utils
const Product = require('../../models/product');
const Category = require('../../models/category');
const auth = require('../../middleware/auth');
const role = require('../../middleware/role');
const { ROLES } = require('../../constants');

console.log('Admin route loaded');

router.post('/init', auth, role.checkRole(ROLES.Admin), async (req, res) => {
  console.log('Received init request');
  try {
    const { products: numProducts = 2, categories: numCategories = 2 } = req.body;
    console.log('Received data:', { products: numProducts, categories: numCategories });

    // Clear existing data
    await Product.deleteMany({});
    await Category.deleteMany({});
    console.log('Cleared existing data');

    // Sample categories
    const sampleCategories = [
      {
        name: 'Electronics',
        description: 'Electronic items',
        slug: 'electronics',
        isActive: true
      },
      {
        name: 'Clothing',
        description: 'Clothing items',
        slug: 'clothing',
        isActive: true
      }
    ].slice(0, numCategories);

    // Insert categories
    const createdCategories = await Category.insertMany(sampleCategories);
    console.log('Categories created:', createdCategories.length);

    // Sample products with slugs
    const sampleProducts = [
      {
        name: 'Laptop',
        description: 'High-performance laptop',
        slug: 'laptop',
        price: 999.99,
        isActive: true,
        taxable: false
      },
      {
        name: 'T-Shirt',
        description: 'Cotton T-Shirt',
        slug: 't-shirt',
        price: 19.99,
        isActive: true,
        taxable: false
      }
    ].slice(0, numProducts);

    // Insert products
    const createdProducts = await Product.insertMany(sampleProducts);
    console.log('Products created:', createdProducts.length);

    res.status(200).json({
      success: true,
      categories: createdCategories,
      products: createdProducts
    });
  } catch (error) {
    console.error('Error initializing database:', error);
    res.status(400).json({
      error: 'Your request could not be processed. Please try again.'
    });
  }
});

module.exports = router;
