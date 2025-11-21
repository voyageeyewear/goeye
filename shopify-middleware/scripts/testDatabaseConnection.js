require('dotenv').config();
const sequelize = require('../config/database');

async function testConnection() {
    console.log('🔌 Testing database connection...\n');
    
    const dbUrl = process.env.DATABASE_URL;
    if (!dbUrl) {
        console.error('❌ DATABASE_URL environment variable is not set!');
        console.log('\n📋 To fix this:');
        console.log('1. Go to Railway Dashboard → Your Project');
        console.log('2. Click on your middleware service');
        console.log('3. Go to "Variables" tab');
        console.log('4. Add DATABASE_URL variable');
        console.log('5. Value should be: ${{Postgres.DATABASE_URL}} (if you have Postgres service)');
        console.log('   OR manually add the connection string from your Postgres service');
        process.exit(1);
    }
    
    // Mask password in URL for display
    const maskedUrl = dbUrl.replace(/:([^:@]+)@/, ':****@');
    console.log(`📍 Database URL: ${maskedUrl}\n`);
    
    try {
        await sequelize.authenticate();
        console.log('✅ Database connection successful!\n');
        
        // Test query
        const [results] = await sequelize.query('SELECT version()');
        console.log('📊 PostgreSQL Version:', results[0].version);
        
        // Check if tables exist
        const [tables] = await sequelize.query(`
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
            ORDER BY table_name;
        `);
        
        console.log(`\n📋 Found ${tables.length} tables:`);
        tables.forEach(table => {
            console.log(`   - ${table.table_name}`);
        });
        
        // Check if we have data
        try {
            const { AppSection, AppTheme } = require('../models');
            const sectionCount = await AppSection.count();
            const themeCount = await AppTheme.count();
            
            console.log(`\n📦 Data Status:`);
            console.log(`   - Sections: ${sectionCount}`);
            console.log(`   - Theme Settings: ${themeCount}`);
            
            if (sectionCount === 0 && themeCount === 0) {
                console.log('\n⚠️  Database is empty. Run seed script:');
                console.log('   node scripts/seedDatabase.js');
            }
        } catch (err) {
            console.log('\n⚠️  Tables might not exist yet. Run seed script:');
            console.log('   node scripts/seedDatabase.js');
        }
        
        console.log('\n✅ Database is ready to use!');
        process.exit(0);
    } catch (error) {
        console.error('\n❌ Database connection failed!');
        console.error('Error:', error.message);
        console.error('\n🔧 Troubleshooting:');
        console.error('1. Check DATABASE_URL is correct');
        console.error('2. Verify PostgreSQL service is running on Railway');
        console.error('3. Check network connectivity');
        console.error('4. Ensure SSL is enabled (Railway requires SSL)');
        process.exit(1);
    }
}

testConnection();

