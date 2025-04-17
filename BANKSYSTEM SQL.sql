USE master

IF EXISTS(SELECT * FROM sys.databases WHERE name = 'BankSystem')
   BEGIN
      ALTER DATABASE [BankSystem] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
      DROP DATABASE [BankSystem]
   END

         CREATE DATABASE [BankSystem];
         GO

         USE [BankSystem]
		 GO 



CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    PersonalNumber VARCHAR(12) UNIQUE NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Gender CHAR(1) NOT NULL,
    BirthDate DATE NOT NULL,
    StreetAddress NVARCHAR(255) NOT NULL,
    ZipCode VARCHAR(20) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) NOT NULL,
    Phone NVARCHAR(20) NOT NULL,
    Email NVARCHAR(255) UNIQUE NOT NULL,
    RegistrationDate DATETIME DEFAULT GETDATE()
);


CREATE TABLE AccountTypes (
    AccountTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50) NOT NULL,
    Description NVARCHAR(255),
    InterestRate DECIMAL(5,2) DEFAULT 0.00,
    MinimumBalance DECIMAL(15,2) DEFAULT 0.00
);


CREATE TABLE Accounts (
    AccountID INT PRIMARY KEY IDENTITY(1,1),
    AccountNumber VARCHAR(20) UNIQUE NOT NULL,
    AccountTypeID INT NOT NULL,
    Balance DECIMAL(15,2) DEFAULT 0.00,
    CreatedDate DATETIME DEFAULT GETDATE(),
    Status VARCHAR(20) DEFAULT 'Active',
    LastActivityDate DATETIME,
    FOREIGN KEY (AccountTypeID) REFERENCES AccountTypes(AccountTypeID)
);


CREATE TABLE CardTypes (
    CardTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50) NOT NULL,
    Description NVARCHAR(255),
    DailyLimit DECIMAL(15,2) NOT NULL,
    MonthlyLimit DECIMAL(15,2) NOT NULL
);


CREATE TABLE Cards (
    CardID INT PRIMARY KEY IDENTITY(1,1),
    CardNumber VARCHAR(50) UNIQUE NOT NULL,
    CardTypeID INT NOT NULL,
    IssueDate DATE NOT NULL,
    ExpiryMonth INT NOT NULL CHECK (ExpiryMonth BETWEEN 1 AND 12),
    ExpiryYear INT NOT NULL,
    CVV VARCHAR(3) NOT NULL,
    PinCode VARCHAR(4) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active',
    DailySpend DECIMAL(15,2) DEFAULT 0.00,
    MonthlySpend DECIMAL(15,2) DEFAULT 0.00,
    FOREIGN KEY (CardTypeID) REFERENCES CardTypes(CardTypeID)
);


CREATE TABLE LoanTypes (
    LoanTypeID INT PRIMARY KEY IDENTITY(1,1),
    TypeName VARCHAR(50) NOT NULL,
    Description NVARCHAR(255),
    MinAmount DECIMAL(15,2) NOT NULL,
    MaxAmount DECIMAL(15,2) NOT NULL,
    MinTermMonths INT NOT NULL,
    MaxTermMonths INT NOT NULL,
    BaseInterestRate DECIMAL(5,2) NOT NULL
);


CREATE TABLE Loans (
    LoanID INT PRIMARY KEY IDENTITY(1,1),
    LoanNumber VARCHAR(20) UNIQUE NOT NULL,
    LoanTypeID INT NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    InterestRate DECIMAL(5,2) NOT NULL,
    MonthlyPayment DECIMAL(15,2) NOT NULL,
    RemainingAmount DECIMAL(15,2) NOT NULL,
    Status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (LoanTypeID) REFERENCES LoanTypes(LoanTypeID)
);


CREATE TABLE Dispositions (
    DispositionID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    AccountID INT NOT NULL,
    CardID INT NULL,
    AccessType VARCHAR(20) NOT NULL,
    DispositionDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID),
    FOREIGN KEY (CardID) REFERENCES Cards(CardID)
);


CREATE TABLE CustomerLoans (
    CustomerLoanID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    LoanID INT NOT NULL,
    RelationshipType VARCHAR(20) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (LoanID) REFERENCES Loans(LoanID)
);


CREATE TABLE Transactions (
    TransactionID INT PRIMARY KEY IDENTITY(1,1),
    AccountID INT NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    TransactionType VARCHAR(20) NOT NULL,
    Description NVARCHAR(255),
    BalanceAfter DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);


CREATE TABLE CardTransactions (
    CardTransactionID INT PRIMARY KEY IDENTITY(1,1),
    CardID INT NOT NULL,
    Amount DECIMAL(15,2) NOT NULL,
    TransactionDate DATETIME DEFAULT GETDATE(),
    MerchantName NVARCHAR(100),
    MerchantCategory VARCHAR(50),
    Description NVARCHAR(255),
    FOREIGN KEY (CardID) REFERENCES Cards(CardID)
);



INSERT INTO AccountTypes (TypeName, Description, InterestRate, MinimumBalance)
VALUES 
('Savings', 'Basic savings account', 0.50, 100.00),
('Checking', 'Standard checking account', 0.00, 0.00),
('Premium', 'Premium account with benefits', 1.25, 5000.00);

INSERT INTO CardTypes (TypeName, Description, DailyLimit, MonthlyLimit)
VALUES 
('Debit', 'Standard debit card', 5000.00, 20000.00),
('Credit', 'Basic credit card', 10000.00, 30000.00),
('Gold', 'Premium credit card', 20000.00, 50000.00);

INSERT INTO LoanTypes (TypeName, Description, MinAmount, MaxAmount, MinTermMonths, MaxTermMonths, BaseInterestRate)
VALUES 
('Mortgage', 'Home mortgage loan', 500000.00, 5000000.00, 120, 360, 3.50),
('Personal', 'Personal loan', 10000.00, 100000.00, 12, 60, 5.99),
('Auto', 'Car loan', 50000.00, 500000.00, 12, 84, 4.25);


INSERT INTO Customers (PersonalNumber, FirstName, LastName, Gender, BirthDate, StreetAddress, ZipCode, City, Country, Phone, Email)
VALUES
('198501011234', 'Thomas', 'Yaro', 'M', '1995-01-01', 'Storgatan 1', '11111', 'Stockholm', 'Sweden', '+46701111111', 'Thomas.Yaro@gmail.com'),
('198602022345', 'Anna', 'Petterson', 'F', '1986-02-02', 'Lillvägen 2', '22222', 'Göteborg', 'Sweden', '+46702222222', 'Anna.Petterson@gmail.com'),
('198703033456', 'Mike', 'Tyson', 'M', '1987-03-03', 'Björkvägen 3', '33333', 'Malmö', 'Sweden', '+46703333333', 'Mike.Tyson@gmail.com'),
('198804044567', 'David', 'Beckham', 'M', '1988-04-04', 'Ekvägen 4', '44444', 'Uppsala', 'Sweden', '+46704444444', 'david.dahl@gmail.com'),
('198905055678', 'Michael', 'Jackson', 'M', '1989-05-05', 'Tallvägen 5', '55555', 'Linköping', 'Sweden', '+46705555555', 'Michael.Jackson@gmail.com'),
('199006066789', 'Björn', 'Borg', 'M', '1990-06-06', 'Granvägen 6', '66666', 'Västerås', 'Sweden', '+46706666666', 'Björn.Borg@hotmail.com'),
('199107077890', 'Optimus', 'Prime', 'O', '1991-07-07', 'Furuvägen 7', '77777', 'Örebro', 'Sweden', '+46707777777', 'Optimus.Prime@yahoo.com'),
('199208088901', 'DJ', 'Khaled', 'M', '1992-08-08', 'Cedervägen 8', '88888', 'Norrköping', 'Sweden', '+46708888888', 'DJKhaled@outlook.com'),
('199309099012', 'Floyd', 'Maywheather', 'M', '1993-09-09', 'Aspvägen 9', '99999', 'Helsingborg', 'Sweden', '+46709999999', 'Money.May@icloud.com'),
('199410101123', 'Oscar', 'De La Hoya', 'M', '1994-10-10', 'Pilvägen 10', '10101', 'Jönköping', 'Sweden', '+46701010101', 'Oscar.DeLaHoya@hotmail.com');


INSERT INTO Accounts (AccountNumber, AccountTypeID, Balance)
VALUES
('SE12345678901', 1, 15000.00),
('SE12345678902', 2, 5000.00),
('SE12345678903', 3, 250000.00),
('SE12345678904', 1, 3000.00),
('SE12345678905', 2, 7500.00),
('SE12345678906', 3, 500000.00),
('SE12345678907', 1, 12000.00),
('SE12345678908', 2, 2500.00),
('SE12345678909', 3, 100000.00),
('SE12345678910', 1, 8000.00);

INSERT INTO Cards (CardNumber, CardTypeID, IssueDate, ExpiryMonth, ExpiryYear, CVV, PinCode)
VALUES
('4111111111111111', 1, '2023-01-01', 12, 2027, '123', '1234'),
('4222222222222222', 2, '2023-02-01', 11, 2026, '234', '2345'),
('4333333333333333', 3, '2023-03-01', 10, 2025, '345', '3456'),
('4444444444444444', 1, '2023-04-01', 9, 2024, '456', '4567'),
('4555555555555555', 2, '2023-05-01', 8, 2023, '567', '5678'),
('4666666666666666', 3, '2023-06-01', 7, 2025, '678', '6789'),
('4777777777777777', 1, '2023-07-01', 6, 2026, '789', '7890'),
('4888888888888888', 2, '2023-08-01', 5, 2024, '890', '8901'),
('4999999999999999', 3, '2023-09-01', 4, 2025, '901', '9012'),
('4000000000000000', 1, '2023-10-01', 3, 2026, '012', '0123');


INSERT INTO Loans (LoanNumber, LoanTypeID, Amount, StartDate, EndDate, InterestRate, MonthlyPayment, RemainingAmount)
VALUES
('LN12345678', 1, 2500000.00, '2022-01-01', '2052-01-01', 3.50, 11226.10, 2500000.00),
('LN23456789', 2, 50000.00, '2022-02-01', '2027-02-01', 5.99, 966.60, 50000.00),
('LN34567890', 3, 300000.00, '2022-03-01', '2032-03-01', 4.25, 2779.80, 300000.00),
('LN45678901', 1, 3500000.00, '2022-04-01', '2052-04-01', 3.50, 15716.54, 3500000.00),
('LN56789012', 2, 75000.00, '2022-05-01', '2027-05-01', 5.99, 1449.90, 75000.00),
('LN67890123', 3, 200000.00, '2022-06-01', '2032-06-01', 4.25, 1853.20, 200000.00),
('LN78901234', 1, 1800000.00, '2022-07-01', '2052-07-01', 3.50, 8082.79, 1800000.00),
('LN89012345', 2, 100000.00, '2022-08-01', '2027-08-01', 5.99, 1933.20, 100000.00),
('LN90123456', 3, 400000.00, '2022-09-01', '2032-09-01', 4.25, 3706.40, 400000.00),
('LN01234567', 1, 4200000.00, '2022-10-01', '2052-10-01', 3.50, 18859.85, 4200000.00);


INSERT INTO Dispositions (CustomerID, AccountID, CardID, AccessType)
VALUES
(1, 1, 1, 'Owner'),
(2, 2, 2, 'Owner'),
(3, 3, 3, 'Owner'),
(4, 4, 4, 'Owner'),
(5, 5, 5, 'Owner'),
(6, 6, 6, 'Owner'),
(7, 7, 7, 'Owner'),
(8, 8, 8, 'Owner'),
(9, 9, 9, 'Owner'),
(10, 10, 10, 'Owner');


INSERT INTO CustomerLoans (CustomerID, LoanID, RelationshipType)
VALUES
(1, 1, 'Primary Borrower'),
(2, 2, 'Primary Borrower'),
(3, 3, 'Primary Borrower'),
(4, 4, 'Primary Borrower'),
(5, 5, 'Primary Borrower'),
(6, 6, 'Primary Borrower'),
(7, 7, 'Primary Borrower'),
(8, 8, 'Primary Borrower'),
(9, 9, 'Primary Borrower'),
(10, 10, 'Primary Borrower');


INSERT INTO Transactions (AccountID, Amount, TransactionType, Description, BalanceAfter)
VALUES
(1, 10000.00, 'Deposit', 'Initial deposit', 10000.00),
(2, 5000.00, 'Deposit', 'Salary', 5000.00),
(3, 250000.00, 'Deposit', 'Investment', 250000.00),
(4, 3000.00, 'Deposit', 'Gift', 3000.00),
(5, -200.00, 'Withdrawal', 'Shopping', 7300.00),
(6, 500000.00, 'Deposit', 'Inheritance', 500000.00),
(7, -1000.00, 'Withdrawal', 'Rent', 11000.00),
(8, 2500.00, 'Deposit', 'Refund', 2500.00),
(9, -5000.00, 'Withdrawal', 'Car repair', 95000.00),
(10, -500.00, 'Withdrawal', 'ATM withdrawal', 9500.00);


INSERT INTO CardTransactions (CardID, Amount, MerchantName, MerchantCategory, Description)
VALUES
(1, 49.99, 'Amazon', 'Online Shopping', 'USB-C Cable'),
(2, 799.00, 'IKEA', 'Furniture', 'Desk Chair'),
(3, 129.95, 'Zalando', 'Clothing', 'Running Shoes'),
(4, 19.99, '7-Eleven', 'Convenience', 'Snacks & Drinks'),
(5, 7999.00, 'Elgiganten', 'Electronics', 'Gaming Laptop'),
(6, 79.50, 'Apoteket', 'Pharmacy', 'Pain Relievers'),
(7, 159.00, 'Netflix', 'Entertainment', 'Monthly Subscription'),
(8, 169.00, 'H&M', 'Clothing', 'Dress'),
(9, 72.75, 'Starbucks', 'Coffee', 'Weekly Coffee Orders'),
(10, 3250.00, 'Apple Store', 'Electronics', 'AirPods Pro')



SELECT 'Customers' AS TableName, COUNT(*) AS Count FROM Customers
UNION ALL
SELECT 'Accounts', COUNT(*) FROM Accounts
UNION ALL
SELECT 'Cards', COUNT(*) FROM Cards
UNION ALL
SELECT 'Loans', COUNT(*) FROM Loans
UNION ALL
SELECT 'Dispositions', COUNT(*) FROM Dispositions
UNION ALL
SELECT 'CustomerLoans', COUNT(*) FROM CustomerLoans
UNION ALL
SELECT 'Transactions', COUNT(*) FROM Transactions
UNION ALL
SELECT 'CardTransactions', COUNT(*) FROM CardTransactions;
