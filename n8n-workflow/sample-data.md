# Sample Excel Data Structure for ShopKeeping

This document describes the recommended Excel file structure for the ShopKeeping voice chat workflow.

## 📊 Recommended Sheet Structure

### 1. Products Sheet
| ProductID | ProductName | Category | Price | Stock | Description |
|-----------|-------------|----------|-------|-------|-------------|
| P001 | Laptop Dell XPS | Electronics | 1299.99 | 15 | High-performance laptop for business |
| P002 | Wireless Mouse | Accessories | 29.99 | 50 | Ergonomic wireless mouse |
| P003 | Office Chair | Furniture | 199.99 | 8 | Ergonomic office chair |

### 2. Customers Sheet
| CustomerID | Name | Email | Phone | Address | JoinDate |
|------------|------|-------|-------|---------|----------|
| C001 | John Smith | john@email.com | +1-555-0101 | 123 Main St | 2024-01-01 |
| C002 | Sarah Johnson | sarah@email.com | +1-555-0102 | 456 Oak Ave | 2024-01-02 |

### 3. Orders Sheet
| OrderID | CustomerID | ProductID | Quantity | OrderDate | Status | Total |
|---------|------------|-----------|----------|-----------|--------|-------|
| O001 | C001 | P001 | 1 | 2024-01-15 | Delivered | 1299.99 |
| O002 | C002 | P002 | 2 | 2024-01-16 | Processing | 59.98 |

### 4. FAQ Sheet
| QuestionID | Question | Answer | Category |
|------------|----------|--------|----------|
| FAQ001 | What is your return policy? | 30-day return policy with receipt | Returns |
| FAQ002 | Do you offer shipping? | Free shipping on orders over $50 | Shipping |
| FAQ003 | What payment methods do you accept? | Credit cards, PayPal, and cash | Payment |

### 5. Policies Sheet
| PolicyID | PolicyName | Description | EffectiveDate |
|----------|------------|-------------|---------------|
| POL001 | Return Policy | 30-day return window | 2024-01-01 |
| POL002 | Shipping Policy | Free shipping over $50 | 2024-01-01 |
| POL003 | Warranty Policy | 1-year manufacturer warranty | 2024-01-01 |

## 🔧 Excel File Setup Instructions

### 1. Create the Excel File
- Use Microsoft Excel, Google Sheets, or LibreOffice Calc
- Save as `.xlsx` format
- Place in the `./data/` directory

### 2. File Naming
- Recommended: `shopkeeping-data.xlsx`
- Update `EXCEL_FILE_PATH` in environment variables

### 3. Data Validation
- Ensure all required columns are present
- Use consistent data formats
- Avoid empty cells in key fields

### 4. Sample Data Population
- Start with sample data for testing
- Gradually add real business data
- Keep data updated and accurate

## 📝 AI Context Integration

The workflow uses this data to provide context-aware responses:

### Product Queries
- Customer asks about specific products
- AI references product details, stock, and pricing
- Provides accurate product information

### Order Status
- Customer inquires about order status
- AI checks order history and provides updates
- Offers relevant order information

### Policy Questions
- Customer asks about return/shipping policies
- AI references policy sheet for accurate answers
- Ensures consistent policy communication

### Customer Support
- AI uses FAQ data for common questions
- Provides immediate, accurate responses
- Reduces support ticket volume

## 🚀 Data Enhancement Ideas

### Additional Sheets
- **Inventory**: Real-time stock levels
- **Suppliers**: Vendor information
- **Promotions**: Current deals and offers
- **Reviews**: Customer feedback and ratings

### Data Relationships
- Link products to categories
- Connect customers to order history
- Associate policies with specific products

### Automation
- Auto-update stock levels
- Generate order confirmations
- Track customer preferences

## 📊 Data Export/Import

### From Existing Systems
- Export from current inventory system
- Import from accounting software
- Migrate from legacy databases

### Regular Updates
- Daily stock updates
- Weekly order summaries
- Monthly customer analytics

## 🔒 Data Security

### Access Control
- Limit file access to authorized users
- Use read-only access for workflow
- Regular backup procedures

### Data Privacy
- Anonymize customer data if needed
- Comply with data protection regulations
- Secure storage and transmission

## 📈 Performance Optimization

### File Size
- Keep file under 10MB for optimal performance
- Remove unnecessary data
- Use efficient data formats

### Query Optimization
- Index frequently accessed columns
- Use consistent data types
- Avoid complex formulas in data cells

## 🧪 Testing with Sample Data

### Initial Setup
1. Create Excel file with sample data
2. Test workflow with sample queries
3. Verify AI responses are accurate
4. Check audio generation works

### Data Validation
1. Test with various product queries
2. Verify order status responses
3. Check policy question handling
4. Validate FAQ responses

### Performance Testing
1. Test with larger datasets
2. Monitor response times
3. Check memory usage
4. Validate error handling

