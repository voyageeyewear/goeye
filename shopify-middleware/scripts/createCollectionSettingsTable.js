require('dotenv').config();
const { sequelize, CollectionPageSettings } = require('../models');

async function createTable() {
  try {
    console.log('🔌 Connecting to database...');
    await sequelize.authenticate();
    console.log('✅ Database connection established');

    console.log('📋 Creating collection_page_settings table...');
    await CollectionPageSettings.sync({ force: false });
    console.log('✅ Table created successfully');

    // Create default settings if they don't exist
    const existingSettings = await CollectionPageSettings.findOne();
    if (!existingSettings) {
      console.log('📝 Creating default settings...');
      await CollectionPageSettings.create({});
      console.log('✅ Default settings created');
    } else {
      console.log('ℹ️  Default settings already exist');
    }

    console.log('\n🎉 Setup complete!');
    process.exit(0);
  } catch (error) {
    console.error('❌ Error:', error);
    process.exit(1);
  }
}

createTable();

