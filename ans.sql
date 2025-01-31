CREATE DATABASE StudentExpensesDB;
USE StudentExpensesDB;

-- Students Table
CREATE TABLE Students (
    StudentID INT PRIMARY KEY AUTO_INCREMENT,
    Name VARCHAR(100) NOT NULL,
    Age INT,
    Gender ENUM('Male', 'Female', 'Other'),
    Major VARCHAR(100),
    YearInSchool VARCHAR(50)
);

-- Expenses Table
CREATE TABLE Expenses (
    ExpenseID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    Category VARCHAR(100) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);

-- Financial Aid Table
CREATE TABLE FinancialAid (
    AidID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    Type VARCHAR(100) NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Date DATE NOT NULL,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);

-- Performance Table
CREATE TABLE Performance (
    PerformanceID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID INT,
    GPA DECIMAL(3,2),
    Attendance INT CHECK (Attendance BETWEEN 0 AND 100),
    StudyHours INT,
    FOREIGN KEY (StudentID) REFERENCES Students(StudentID) ON DELETE CASCADE
);

-- Sample Data
INSERT INTO Students (Name, Age, Gender, Major, YearInSchool) VALUES
('Alice Johnson', 20, 'Female', 'Computer Science', 'Sophomore'),
('Bob Smith', 22, 'Male', 'Mechanical Engineering', 'Senior'),
('Charlie Davis', 19, 'Other', 'Business Administration', 'Freshman');

INSERT INTO Expenses (StudentID, Category, Amount, Date) VALUES
(1, 'Tuition', 5000.00, '2024-01-10'),
(1, 'Housing', 1200.00, '2024-01-15'),
(2, 'Food', 300.00, '2024-02-05'),
(3, 'Transportation', 100.00, '2024-03-12');

INSERT INTO FinancialAid (StudentID, Type, Amount, Date) VALUES
(1, 'Scholarship', 2000.00, '2024-01-01'),
(2, 'Loan', 3000.00, '2024-02-01'),
(3, 'Grant', 1500.00, '2024-03-01');

INSERT INTO Performance (StudentID, GPA, Attendance, StudyHours) VALUES
(1, 3.8, 95, 20),
(2, 3.5, 90, 15),
(3, 3.2, 85, 12);

-- Data Retrieval Queries

-- Get all students
SELECT * FROM Students;

-- Get all expenses by category
SELECT Category, SUM(Amount) AS TotalAmount FROM Expenses GROUP BY Category;

-- Get total financial aid received by each student
SELECT s.Name, SUM(f.Amount) AS TotalAid FROM Students s
JOIN FinancialAid f ON s.StudentID = f.StudentID
GROUP BY s.Name;

-- Get students with GPA greater than 3.5
SELECT Name, GPA FROM Performance WHERE GPA > 3.5;

-- Get expense-to-income ratio per student
SELECT s.Name, SUM(e.Amount) / (SELECT COALESCE(SUM(f.Amount), 0) FROM FinancialAid f WHERE f.StudentID = s.StudentID) AS ExpenseToIncomeRatio
FROM Students s
JOIN Expenses e ON s.StudentID = e.StudentID
GROUP BY s.Name;

-- Get the major with the highest total expenses
SELECT s.Major, SUM(e.Amount) AS TotalExpenses FROM Students s
JOIN Expenses e ON s.StudentID = e.StudentID
GROUP BY s.Major ORDER BY TotalExpenses DESC LIMIT 1;