CREATE DATABASE BankDB;
USE BankDB;
CREATE TABLE Customer (
    Customer_ID INT PRIMARY KEY,
    Customer_Name VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    City VARCHAR(50)
);
CREATE TABLE Account (
    Account_No INT PRIMARY KEY,
    Customer_ID INT,
    Account_Type VARCHAR(20),
    Balance DECIMAL(12,2) DEFAULT 0,
    Branch VARCHAR(50),
    Status VARCHAR(20) DEFAULT 'ACTIVE',
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer(Customer_ID)
);
CREATE TABLE Bank_Transaction (
    Transaction_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Transaction_Date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (Account_No)
    REFERENCES Account(Account_No)
);
CREATE TABLE Loan (
    Loan_ID INT PRIMARY KEY,
    Customer_ID INT,
    Loan_Type VARCHAR(30),
    Loan_Amount DECIMAL(12,2),
    Interest_Rate DECIMAL(5,2),
    FOREIGN KEY (Customer_ID)
    REFERENCES Customer(Customer_ID)
);
INSERT INTO Customer
(Customer_ID, Customer_Name, Phone, Email, City)
VALUES
(101, 'Ravi Kumar', '9876543210', 'ravi@gmail.com', 'Hyderabad'),
(102, 'Priya Sharma', '9876543211', 'priya@gmail.com', 'Vijayawada'),
(103, 'Arjun Reddy', '9876543212', 'arjun@gmail.com', 'Bangalore'),
(104, 'Sneha Rao', '9876543213', 'sneha@gmail.com', 'Chennai'),
(105, 'Kiran Kumar', '9876543214', 'kiran@gmail.com', 'Hyderabad'),
(106, 'Anjali Patel', '9876543215', 'anjali@gmail.com', 'Mumbai'),
(107, 'Rahul Verma', '9876543216', 'rahul@gmail.com', 'Delhi'),
(108, 'Meena Singh', '9876543217', 'meena@gmail.com', 'Pune'),
(109, 'Vikram Das', '9876543218', 'vikram@gmail.com', 'Kolkata'),
(110, 'Divya Nair', '9876543219', 'divya@gmail.com', 'Kochi');
INSERT INTO Account
(Account_No, Customer_ID, Account_Type, Balance, Branch, Status)
VALUES
(10001, 101, 'Savings', 50000, 'Hyderabad', 'ACTIVE'),
(10002, 102, 'Savings', 75000, 'Vijayawada', 'ACTIVE'),
(10003, 103, 'Current', 120000, 'Bangalore', 'ACTIVE'),
(10004, 104, 'Savings', 45000, 'Chennai', 'ACTIVE'),
(10005, 105, 'Current', 90000, 'Hyderabad', 'ACTIVE'),
(10006, 106, 'Savings', 60000, 'Mumbai', 'ACTIVE'),
(10007, 107, 'Savings', 80000, 'Delhi', 'ACTIVE'),
(10008, 108, 'Current', 110000, 'Pune', 'ACTIVE'),
(10009, 109, 'Savings', 55000, 'Kolkata', 'ACTIVE'),
(10010, 110, 'Savings', 70000, 'Kochi', 'ACTIVE');
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', 10000),
(10002, 'DEPOSIT', 15000),
(10003, 'WITHDRAW', 20000),
(10004, 'DEPOSIT', 5000),
(10005, 'WITHDRAW', 10000),
(10006, 'DEPOSIT', 8000),
(10007, 'WITHDRAW', 5000),
(10008, 'DEPOSIT', 12000),
(10009, 'DEPOSIT', 7000),
(10010, 'WITHDRAW', 6000),
(10001, 'WITHDRAW', 3000),
(10002, 'DEPOSIT', 5000),
(10003, 'DEPOSIT', 10000),
(10004, 'WITHDRAW', 4000),
(10005, 'DEPOSIT', 9000),
(10006, 'WITHDRAW', 7000),
(10007, 'DEPOSIT', 6000),
(10008, 'WITHDRAW', 8000),
(10009, 'WITHDRAW', 5000),
(10010, 'DEPOSIT', 11000);
INSERT INTO Loan
(Loan_ID, Customer_ID, Loan_Type, Loan_Amount, Interest_Rate)
VALUES
(501, 101, 'Home Loan', 5000000, 7.5),
(502, 102, 'Education Loan', 1000000, 6.5),
(503, 103, 'Car Loan', 800000, 8.2),
(504, 104, 'Personal Loan', 500000, 10.5),
(505, 105, 'Home Loan', 600000, 7.25),
(506, 106, 'Car Loan', 350000, 8.25),
(507, 107, 'Personal Loan', 150000, 10.5),
(508, 108, 'Home Loan', 700000, 7.0),
(509, 109, 'Education Loan', 180000, 6.75),
(510, 110, 'Car Loan', 400000, 8.5);
SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;
SELECT * FROM Loan;
DELIMITER //
CREATE PROCEDURE GetAllCustomers()
BEGIN
    SELECT * FROM Customer;
END //
DELIMITER ;
CALL GetAllCustomers();
DELIMITER //
CREATE PROCEDURE GetAccountDetails(
    IN p_Account_No INT
)
BEGIN
    SELECT *
    FROM Account
    WHERE Account_No = p_Account_No;
END //
DELIMITER ;
CALL GetAccountDetails(10001);
DELIMITER //
CREATE PROCEDURE GetCustomerAccounts(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_ID,
        C.Customer_Name,
        A.Account_No,
        A.Account_Type,
        A.Balance,
        A.Branch
    FROM Customer C
    JOIN Account A
    ON C.Customer_ID = A.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //
DELIMITER ;
CALL GetCustomerAccounts(101);
DELIMITER //
CREATE PROCEDURE DepositMoney(
    IN p_Account_No INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    IF p_Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Deposit amount must be greater than zero';
    ELSEIF NOT EXISTS (
        SELECT 1
        FROM Account
        WHERE Account_No = p_Account_No
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Account does not exist';
    ELSE
        INSERT INTO Bank_Transaction
        (Account_No, Transaction_Type, Amount)
        VALUES
        (p_Account_No, 'DEPOSIT', p_Amount);
    END IF;
END //
DELIMITER ;
CALL DepositMoney(10001, 5000);
DELIMITER //
CREATE PROCEDURE WithdrawMoney(
    IN p_Account_No INT,
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    IF p_Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Withdrawal amount must be greater than zero';
    ELSEIF NOT EXISTS (
        SELECT 1
        FROM Account
        WHERE Account_No = p_Account_No
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Account does not exist';
    ELSE
        INSERT INTO Bank_Transaction
        (Account_No, Transaction_Type, Amount)
        VALUES
        (p_Account_No, 'WITHDRAW', p_Amount);
    END IF;
END //
DELIMITER ;
CALL WithdrawMoney(10001, 3000);
DELIMITER //
CREATE TRIGGER CheckBalance
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.Balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Transaction failed: Insufficient balance';
    END IF;
END //
DELIMITER ;
UPDATE Account
SET Balance = Balance - 60000
WHERE Account_No = 10001;
DELIMITER //
CREATE TRIGGER CheckTransactionAmount
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    IF NEW.Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Transaction amount must be greater than zero';
    ELSEIF NEW.Transaction_Type NOT IN
    ('DEPOSIT', 'WITHDRAW') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid transaction type';
    END IF;
END //
DELIMITER ;
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', -5000);
CREATE TABLE Transaction_Audit (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Transaction_ID INT,
    Account_No INT,
    Transaction_Type VARCHAR(20),
    Amount DECIMAL(12,2),
    Audit_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER TransactionAudit
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    INSERT INTO Transaction_Audit
    (
        Transaction_ID,
        Account_No,
        Transaction_Type,
        Amount
    )
    VALUES
    (
        NEW.Transaction_ID,
        NEW.Account_No,
        NEW.Transaction_Type,
        NEW.Amount
    );
END //
DELIMITER ;
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', 2500);
SELECT * FROM Transaction_Audit;
DELIMITER //
CREATE TRIGGER UpdateBalanceAfterTransaction
AFTER INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    IF NEW.Transaction_Type = 'DEPOSIT' THEN
        UPDATE Account
        SET Balance = Balance + NEW.Amount
        WHERE Account_No = NEW.Account_No;
    ELSEIF NEW.Transaction_Type = 'WITHDRAW' THEN
        UPDATE Account
        SET Balance = Balance - NEW.Amount
        WHERE Account_No = NEW.Account_No;
    END IF;
END //
DELIMITER ;
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', 5000);
SELECT *
FROM Account
WHERE Account_No = 10001;
DELIMITER //
CREATE TRIGGER PreventInsufficientWithdrawal
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    DECLARE CurrentBalance DECIMAL(12,2);
    SELECT Balance
    INTO CurrentBalance
    FROM Account
    WHERE Account_No = NEW.Account_No;
    IF NEW.Transaction_Type = 'WITHDRAW'
       AND NEW.Amount > CurrentBalance THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Withdrawal failed: Insufficient balance';
    END IF;
END //
DELIMITER ;
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'WITHDRAW', 1000000);
DELIMITER //
CREATE PROCEDURE TransferMoney(
    IN SenderAccount INT,
    IN ReceiverAccount INT,
    IN TransferAmount DECIMAL(12,2)
)
BEGIN
    DECLARE SenderBalance DECIMAL(12,2);
    IF TransferAmount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Transfer amount must be greater than zero';
    ELSEIF NOT EXISTS (
        SELECT 1
        FROM Account
        WHERE Account_No = SenderAccount
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Sender account does not exist';
    ELSEIF NOT EXISTS (
        SELECT 1
        FROM Account
        WHERE Account_No = ReceiverAccount
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Receiver account does not exist';
    ELSEIF SenderAccount = ReceiverAccount THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Sender and receiver accounts must be different';
    ELSE
        SELECT Balance
        INTO SenderBalance
        FROM Account
        WHERE Account_No = SenderAccount;
        IF SenderBalance < TransferAmount THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Transfer failed: Insufficient balance';
        ELSE
            START TRANSACTION;
            INSERT INTO Bank_Transaction
            (Account_No, Transaction_Type, Amount)
            VALUES
            (SenderAccount, 'WITHDRAW', TransferAmount);
            INSERT INTO Bank_Transaction
            (Account_No, Transaction_Type, Amount)
            VALUES
            (ReceiverAccount, 'DEPOSIT', TransferAmount);
            COMMIT;
        END IF;
    END IF;
END //
DELIMITER ;
CALL TransferMoney(10001, 10002, 5000);
SELECT *
FROM Account
WHERE Account_No IN (10001,10002);
DELIMITER //
CREATE PROCEDURE GetCustomerLoans(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_Name,
        L.Loan_ID,
        L.Loan_Type,
        L.Loan_Amount,
        L.Interest_Rate
    FROM Customer C
    JOIN Loan L
    ON C.Customer_ID = L.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //
DELIMITER ;
CALL GetCustomerLoans(101);
DELIMITER //
CREATE PROCEDURE HighBalanceAccounts(
    IN MinimumBalance DECIMAL(12,2)
)
BEGIN
    SELECT *
    FROM Account
    WHERE Balance > MinimumBalance
    ORDER BY Balance DESC;
END //
DELIMITER ;
CALL HighBalanceAccounts(50000);
DELIMITER //
CREATE PROCEDURE GetBalance(
    IN p_Account_No INT,
    OUT p_Balance DECIMAL(12,2)
)
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM Account
        WHERE Account_No = p_Account_No
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Account does not exist';
    ELSE
        SELECT Balance
        INTO p_Balance
        FROM Account
        WHERE Account_No = p_Account_No;
    END IF;
END //
DELIMITER ;
CALL GetBalance(10001, @CurrentBalance);
SELECT @CurrentBalance;
SHOW TRIGGERS;
SHOW CREATE TRIGGER CheckBalance;
SHOW PROCEDURE STATUS
WHERE Db = 'BankDB';
DELIMITER //
CREATE PROCEDURE GetBranchAccounts(
    IN p_Branch VARCHAR(50)
)
BEGIN
    SELECT *
    FROM Account
    WHERE Branch = p_Branch;
END //
DELIMITER ;
CALL GetBranchAccounts('Hyderabad');
DELIMITER //
CREATE PROCEDURE GetCustomerAccountDetails(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_Name,
        C.Phone,
        C.Email,
        A.Account_No,
        A.Account_Type,
        A.Balance
    FROM Customer C
    JOIN Account A
    ON C.Customer_ID = A.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID;
END //
DELIMITER ;
CALL GetCustomerAccountDetails(101);
DELIMITER //
CREATE PROCEDURE GetTotalCustomerBalance(
    IN p_Customer_ID INT
)
BEGIN
    SELECT
        C.Customer_Name,
        SUM(A.Balance) AS Total_Balance
    FROM Customer C
    JOIN Account A
    ON C.Customer_ID = A.Customer_ID
    WHERE C.Customer_ID = p_Customer_ID
    GROUP BY
        C.Customer_ID,
        C.Customer_Name;
END //
DELIMITER ;
CALL GetTotalCustomerBalance(101);
DELIMITER //
CREATE PROCEDURE HighBalanceAccountsQ4(
    IN MinimumBalance DECIMAL(12,2)
)
BEGIN
    SELECT *
    FROM Account
    WHERE Balance > MinimumBalance
    ORDER BY Balance DESC;
END //
DELIMITER ;
CALL HighBalanceAccountsQ4(100000);
DELIMITER //
CREATE TRIGGER PreventNegativeBalance
BEFORE UPDATE ON Account
FOR EACH ROW
BEGIN
    IF NEW.Balance < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Account balance cannot become negative';
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE TRIGGER PreventInvalidTransactionAmount
BEFORE INSERT ON Bank_Transaction
FOR EACH ROW
BEGIN
    IF NEW.Amount <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Transaction amount must be greater than zero';
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE CalculateLoanInterest(
    IN p_Loan_Amount DECIMAL(12,2),
    IN p_Interest_Rate DECIMAL(5,2),
    IN p_Years INT
)
BEGIN
    DECLARE SimpleInterest DECIMAL(12,2);
    DECLARE TotalAmount DECIMAL(12,2);
    IF p_Loan_Amount <= 0
       OR p_Interest_Rate < 0
       OR p_Years <= 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Invalid input';
    ELSE
        SET SimpleInterest =
        (p_Loan_Amount * p_Interest_Rate * p_Years) / 100;
        SET TotalAmount =
        p_Loan_Amount + SimpleInterest;
        SELECT
            SimpleInterest,
            TotalAmount;
    END IF;
END //
DELIMITER ;
CALL CalculateLoanInterest(500000, 7.5, 5);
DELIMITER //
CREATE TRIGGER PreventCustomerDeletion
BEFORE DELETE ON Customer
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Account
        WHERE Customer_ID = OLD.Customer_ID
        AND Status = 'ACTIVE'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Customer cannot be deleted: Active account exists';
    END IF;
END //
DELIMITER ;
CREATE TABLE Account_Audit (
    Audit_ID INT PRIMARY KEY AUTO_INCREMENT,
    Account_No INT,
    Old_Balance DECIMAL(12,2),
    New_Balance DECIMAL(12,2),
    Changed_Date DATETIME DEFAULT CURRENT_TIMESTAMP
);
DELIMITER //
CREATE TRIGGER AccountBalanceAudit
AFTER UPDATE ON Account
FOR EACH ROW
BEGIN
    IF OLD.Balance <> NEW.Balance THEN
        INSERT INTO Account_Audit
        (
            Account_No,
            Old_Balance,
            New_Balance
        )
        VALUES
        (
            OLD.Account_No,
            OLD.Balance,
            NEW.Balance
        );
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE Top5Accounts()
BEGIN
    SELECT *
    FROM Account
    ORDER BY Balance DESC
    LIMIT 5;
END //
DELIMITER ;
CALL Top5Accounts();
DELIMITER //
CREATE PROCEDURE AccountCountByBranch()
BEGIN
    SELECT
        Branch,
        COUNT(*) AS Number_of_Accounts
    FROM Account
    GROUP BY Branch;
END //
DELIMITER ;
CALL AccountCountByBranch();
DELIMITER //
CREATE PROCEDURE CustomersWithHighLoans(
    IN p_Amount DECIMAL(12,2)
)
BEGIN
    SELECT
        C.Customer_ID,
        C.Customer_Name,
        L.Loan_ID,
        L.Loan_Type,
        L.Loan_Amount,
        L.Interest_Rate
    FROM Customer C
    JOIN Loan L
    ON C.Customer_ID = L.Customer_ID
    WHERE L.Loan_Amount > p_Amount;
END //
DELIMITER ;
CALL CustomersWithHighLoans(300000);
DELIMITER //
CREATE TRIGGER PreventAccountDeletion
BEFORE DELETE ON Account
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1
        FROM Bank_Transaction
        WHERE Account_No = OLD.Account_No
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT =
        'Account cannot be deleted: Transactions exist';
    END IF;
END //
DELIMITER ;
DELIMITER //
CREATE PROCEDURE GetTransactionHistory(
    IN p_Account_No INT
)
BEGIN
    SELECT
        Transaction_ID,
        Account_No,
        Transaction_Type,
        Amount,
        Transaction_Date
    FROM Bank_Transaction
    WHERE Account_No = p_Account_No
    ORDER BY Transaction_Date;
END //
DELIMITER ;
CALL GetTransactionHistory(10001);
DELIMITER //
CREATE PROCEDURE GetAccountSummary()
BEGIN
    SELECT
        A.Account_No,
        C.Customer_Name,
        A.Account_Type,
        A.Balance,
        A.Branch
    FROM Account A
    JOIN Customer C
    ON A.Customer_ID = C.Customer_ID;
END //
DELIMITER ;
CALL GetAccountSummary();
SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;
SELECT * FROM Transaction_Audit;
SELECT * FROM Account_Audit;
SELECT * FROM Loan;
CALL DepositMoney(10001, 5000);
SELECT *
FROM Account
WHERE Account_No = 10001;
CALL WithdrawMoney(10001, 3000);
SELECT *
FROM Account
WHERE Account_No = 10001;
CALL TransferMoney(10001, 10002, 5000);
SELECT *
FROM Account
WHERE Account_No IN (10001, 10002);
CALL GetTransactionHistory(10001);
CALL GetAccountSummary();
CALL WithdrawMoney(10001, 1000000);
CALL DepositMoney(10001, -5000);
CALL WithdrawMoney(10001, 0);
CALL TransferMoney(99999, 10002, 5000);
CALL TransferMoney(10001, 99999, 5000);
CALL TransferMoney(10001, 10002, 1000000);
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'DEPOSIT', -5000);
INSERT INTO Bank_Transaction
(Account_No, Transaction_Type, Amount)
VALUES
(10001, 'ABC', 5000);
DELETE FROM Customer
WHERE Customer_ID = 101;
DELETE FROM Account
WHERE Account_No = 10001;
SELECT * FROM Customer;
SELECT * FROM Account;
SELECT * FROM Bank_Transaction;
SELECT * FROM Transaction_Audit;
SELECT * FROM Account_Audit;
SELECT * FROM Loan;
SHOW TRIGGERS;
SHOW PROCEDURE STATUS
WHERE Db = 'BankDB';
