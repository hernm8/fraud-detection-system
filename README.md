# Fraud Detection System (SQL)

## Project Overview
This project aims to develop a fraud detection system using SQL to identify suspicious transactions by analyzing patterns, anomalies, and user behavior. The system detects fraud indicators such as unusual transaction amounts, rapid transaction frequency, and chargebacks. It processes payment data in smaller chunks to simulate real-time fraud detection.

The dataset used for this project is from Kaggle and represents an e-commerce business in the UK without predetermined fraud labels, making it an ideal source for unsupervised fraud detection. In the future, machine learning models will be integrated to improve the classification and prediction of fraudulent transactions.

## Key Features
- **SQL-based fraud detection**: Identify fraudulent transactions through anomaly detection and behavior analysis.
- **Real-time simulation**: Process data in chunks to simulate live fraud detection.
- **Scalable**: Designed to be easily extended for larger financial datasets and real-world systems.
- **Future enhancements**: Machine learning models will be added for better fraud prediction and classification.

## Methodology
- **Anomaly Detection**: Identifies transactions with significantly higher amounts than usual.
- **Burst Transactions**: Detects rapid, consecutive transactions from the same user.
- **Location-Based Anomalies**: Flags transactions made from geographically distant locations.
- **Repeated Chargebacks**: Flags users with multiple chargebacks as high-risk.
- **Merchant Risk Assessment**: Assesses transactions with merchants identified as high-risk.

## Dataset
The dataset used in this project is from Kaggle and represents e-commerce transactions for a UK-based online business. This dataset does not include predefined fraud labels, making it ideal for unsupervised fraud detection techniques. It includes transaction details like user ID, transaction amount, timestamp, merchant information, and location.

## Technologies Used
- **SQL**: For querying and processing transaction data.
- **SQL Jobs**: Automates fraud detection using scheduled queries.
- **Database**: PostgreSQL/MySQL/SQL Server.
- **Future**: Machine Learning (Random Forest, Isolation Forest) for fraud classification.

## Project Setup
1. **Database Setup**: Create SQL tables and load transaction data.
2. **Data Chunking**: Split data into smaller chunks to simulate real-time data processing.
3. **Run Queries**: Execute SQL queries to analyze the data and detect fraud.

## How to Run
1. Set up your SQL database (PostgreSQL/MySQL/SQL Server).
2. Create tables for `Transactions`, `Users`, `Chargebacks`, and `Merchants`.
3. Load the Kaggle e-commerce transaction data into the respective tables.
4. Execute the SQL queries to analyze the data and detect fraud.

## Future Enhancements
- **Machine Learning Integration**: Add models like Random Forest or Isolation Forest to improve fraud detection and prediction.
- **Real-time Monitoring**: Implement continuous fraud detection in real-time transactions.

## License
This project is open-source and can be freely used and modified.

## Contact
Feel free to reach out with any questions or suggestions via [LinkedIn](https://www.linkedin.com/in/michael-hernandez8/).
