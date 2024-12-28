const express = require('express');
const router = express.Router();

// Bring in Models & Utils
const Product = require('../../models/product');
const Category = require('../../models/category');

router.post('/init', async (req, res) => {
  try {
    const { products, categories } = req.body;

    // Clear existing data
    await Product.deleteMany({});
    await Category.deleteMany({});

    // Insert categories
    const createdCategories = await Category.insertMany(categories);
    console.log('Categories created:', createdCategories.length);

    // Insert products
    const createdProducts = await Product.insertMany(products);
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
