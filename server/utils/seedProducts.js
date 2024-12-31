const path = require('path');
require('dotenv').config({ path: path.join(__dirname, '../../server/.env') });
const mongoose = require('mongoose');
const Product = require('../models/product');

const sampleProducts = [
  {
    sku: 'LP-001',
    name: 'MacBook Pro 16-inch',
    slug: 'macbook-pro-16-inch',
    description: 'Latest MacBook Pro with M1 Pro chip, 16-inch Retina display, 16GB RAM, 512GB SSD',
    quantity: 10,
    price: 2499.99,
    imageUrl: '/images/products/macbook-pro.jpg',
    isActive: true,
    taxable: true
  },
  {
    sku: 'SP-002',
    name: 'iPhone 13 Pro',
    slug: 'iphone-13-pro',
    description: 'iPhone 13 Pro with A15 Bionic chip, Pro camera system, 128GB storage',
    quantity: 15,
    price: 999.99,
    imageUrl: '/images/products/iphone-13-pro.jpg',
    isActive: true,
    taxable: true
  },
  {
    sku: 'AUD-003',
    name: 'AirPods Pro',
    slug: 'airpods-pro',
    description: 'Active noise cancellation, Transparency mode, Adaptive EQ',
    quantity: 30,
    price: 249.99,
    imageUrl: '/images/products/airpods-pro.jpg',
    isActive: true,
    taxable: true
  },
  {
    sku: 'TAB-004',
    name: 'iPad Air',
    slug: 'ipad-air',
    description: 'iPad Air with M1 chip, 10.9-inch Liquid Retina display, 256GB',
    quantity: 20,
    price: 749.99,
    imageUrl: '/images/products/ipad-air.jpg',
    isActive: true,
    taxable: true
  },
  {
    sku: 'SW-005',
    name: 'Apple Watch Series 7',
    slug: 'apple-watch-series-7',
    description: 'Always-On Retina display, Blood oxygen sensor, ECG app',
    quantity: 25,
    price: 399.99,
    imageUrl: '/images/products/apple-watch.jpg',
    isActive: true,
    taxable: true
  }
];

const seedProducts = async () => {
  try {
    // Connect to MongoDB
    const mongoUri = process.env.MONGO_URI;
    console.log('Connecting to MongoDB at:', mongoUri);
    
    await mongoose.connect(mongoUri);
    console.log('Connected to MongoDB');

    // Clear existing products
    await Product.deleteMany({});
    console.log('Cleared existing products');

    // Insert sample products
    const insertedProducts = await Product.insertMany(sampleProducts);
    console.log(`Added ${insertedProducts.length} sample products`);

    console.log('Database seeding completed!');
    process.exit(0);
  } catch (error) {
    console.error('Error seeding database:', error);
    process.exit(1);
  }
};

seedProducts();
