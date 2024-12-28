const products = [
  {
    name: "iPhone 14 Pro",
    description: "Latest iPhone with advanced camera system",
    price: 999.99,
    category: "Electronics",
    brand: "Apple",
    stock: 50,
    images: ["https://example.com/iphone14.jpg"],
  },
  {
    name: "Samsung Galaxy S23",
    description: "Flagship Android smartphone with powerful features",
    price: 899.99,
    category: "Electronics",
    brand: "Samsung",
    stock: 45,
    images: ["https://example.com/s23.jpg"],
  },
  {
    name: "Nike Air Max",
    description: "Comfortable running shoes with air cushioning",
    price: 129.99,
    category: "Fashion",
    brand: "Nike",
    stock: 100,
    images: ["https://example.com/airmax.jpg"],
  },
  {
    name: "Sony WH-1000XM4",
    description: "Premium noise-cancelling headphones",
    price: 349.99,
    category: "Electronics",
    brand: "Sony",
    stock: 30,
    images: ["https://example.com/wh1000xm4.jpg"],
  },
  {
    name: "Levi's 501 Jeans",
    description: "Classic straight fit denim jeans",
    price: 69.99,
    category: "Fashion",
    brand: "Levi's",
    stock: 150,
    images: ["https://example.com/levis501.jpg"],
  }
];

const categories = [
  {
    name: "Electronics",
    description: "Electronic devices and accessories",
  },
  {
    name: "Fashion",
    description: "Clothing, shoes, and accessories",
  },
  {
    name: "Home & Living",
    description: "Furniture and home decor",
  },
  {
    name: "Books",
    description: "Physical and digital books",
  },
  {
    name: "Sports",
    description: "Sports equipment and accessories",
  }
];

// Function to initialize the database
async function initializeDB() {
  try {
    const response = await fetch('http://api.ecommerce.local/api/admin/init', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        products,
        categories,
      }),
    });

    const data = await response.json();
    console.log('Database initialized:', data);
  } catch (error) {
    console.error('Error initializing database:', error);
  }
}

initializeDB();
