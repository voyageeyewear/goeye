const axios = require('axios');

const SHOPIFY_STORE = 'eyejack1907.myshopify.com';
const STOREFRONT_TOKEN = '0032c089ead422dfbfaa0ffcbbddcc97';

async function testLensQuery() {
  const query = `
    query getLensProducts {
      products(first: 10, query: "vendor:LensAdvizor OR title:upto") {
        edges {
          node {
            id
            title
            vendor
            variants(first: 5) {
              edges {
                node {
                  id
                  title
                  price {
                    amount
                  }
                }
              }
            }
          }
        }
      }
    }
  `;

  try {
    const response = await axios.post(
      `https://${SHOPIFY_STORE}/api/2025-01/graphql.json`,
      { query },
      {
        headers: {
          'X-Shopify-Storefront-Access-Token': STOREFRONT_TOKEN,
          'Content-Type': 'application/json'
        }
      }
    );

    const products = response.data.data.products.edges;
    console.log(`Found ${products.length} lens products:\n`);
    
    products.forEach(({ node }) => {
      console.log(`📦 ${node.title} (Vendor: ${node.vendor})`);
      console.log(`   Product ID: ${node.id}`);
      node.variants.edges.forEach(({ node: variant }) => {
        console.log(`   ✅ Variant: ${variant.title} | ₹${variant.price.amount}`);
        console.log(`      ID: ${variant.id}`);
      });
      console.log('');
    });
  } catch (error) {
    console.error('Error:', error.response?.data || error.message);
  }
}

testLensQuery();
