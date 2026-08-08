	CREATE DATABASE db2;
    USE db2;
    CREATE TABLE bank_transactions (
    txn_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    branch_name VARCHAR(50),
    transaction_type VARCHAR(20),
    amount DECIMAL(10,2),
    transaction_date DATE
);
ALTER TABLE bank_transactions
ADD account_no VARCHAR(20);
ALTER TABLE bank_transactions
MODIFY customer_name VARCHAR(100);
RENAME TABLE bank_transactions TO customer_transactions;
TRUNCATE TABLE customer_transactions;
CREATE TABLE bank_backup(
cus_name CHAR(50),
id_number INT
);
DROP TABLE bank_backup;
INSERT INTO customer_transactions VALUES
(101,'Ravi','Hyderabad','Deposit',5000,'2024-01-05','ACC1'),
(102,'Sita','Hyderabad','Withdrawal',2000,'2024-01-06','ACC2'),
(103,'Kiran','Vijayawada','Deposit',12000,'2024-01-08','ACC3'),
(104,'Anil','Vizag','Deposit',8000,'2024-01-10','ACC4'),
(105,'Priya','Hyderabad','Withdrawal',3500,'2024-01-11','ACC5'),
(106,'Ramesh','Vizag','Deposit',15000,'2024-01-12','ACC6'),
(107,'Keerthi','Vijayawada','Withdrawal',1000,'2024-01-13','ACC7'),
(108,'Rahul','Hyderabad','Deposit',9000,'2024-01-14','ACC8'),
(109,'Sneha','Vizag','Withdrawal',4000,'2024-01-15','ACC9'),
(110,'Madhu','Vijayawada','Deposit',11000,'2024-01-16','ACC10');
UPDATE customer_transactions
SET amount = 5000
WHERE txn_id = 105;
DELETE FROM customer_transactions 
WHERE txn_id=111;
SELECT * FROM customer_transactions;
DROP TABLE customer_transactions; 
SELECT * FROM customer_transactions;