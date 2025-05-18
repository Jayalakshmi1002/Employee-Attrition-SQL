
USE crm_system;

-- Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(15),
    address VARCHAR(255),
    created_date DATE DEFAULT CURDATE()
);

-- Sales Opportunities Table
CREATE TABLE SalesOpportunities (
    opportunity_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    opportunity_name VARCHAR(100) NOT NULL,
    opportunity_stage ENUM('Lead', 'Qualified', 'Proposal', 'Closed Won', 'Closed Lost') NOT NULL,
    estimated_value DECIMAL(10, 2),
    expected_close_date DATE,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Leads Table
CREATE TABLE Leads (
    lead_id INT AUTO_INCREMENT PRIMARY KEY,
    lead_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone_number VARCHAR(15),
    source VARCHAR(50),
    status ENUM('New', 'Contacted', 'Qualified', 'Converted', 'Closed') NOT NULL
);

-- Support Tickets Table
CREATE TABLE SupportTickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    subject VARCHAR(255) NOT NULL,
    description TEXT,
    status ENUM('Open', 'In Progress', 'Resolved', 'Closed') DEFAULT 'Open',
    created_date DATE DEFAULT CURDATE(),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Campaigns Table
CREATE TABLE Campaigns (
    campaign_id INT AUTO_INCREMENT PRIMARY KEY,
    campaign_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10, 2),
    description TEXT
);

-- Procedures
DELIMITER $$

CREATE PROCEDURE GetCustomerDetails(IN cust_id INT)
BEGIN
    SELECT * FROM Customers WHERE customer_id = cust_id;
END$$

CREATE PROCEDURE GetOpportunitiesByCustomer(IN cust_id INT)
BEGIN
    SELECT * FROM SalesOpportunities WHERE customer_id = cust_id;
END$$

CREATE PROCEDURE GetLeadsByStatus(IN lead_status ENUM('New', 'Contacted', 'Qualified', 'Converted', 'Closed'))
BEGIN
    SELECT * FROM Leads WHERE status = lead_status;
END$$

CREATE PROCEDURE GetSupportTicketsByCustomer(IN cust_id INT)
BEGIN
    SELECT * FROM SupportTickets WHERE customer_id = cust_id;
END$$

CREATE PROCEDURE GetCampaignsByBudget(IN min_budget DECIMAL(10, 2))
BEGIN
    SELECT * FROM Campaigns WHERE budget >= min_budget;
END$$

DELIMITER ;

-- Sample Data
INSERT INTO Customers (customer_name, email, phone_number, address)
VALUES ('John Doe', 'john.doe@example.com', '1234567890', '123 Main St, Cityville');

INSERT INTO SalesOpportunities (customer_id, opportunity_name, opportunity_stage, estimated_value, expected_close_date)
VALUES (1, 'Website Redesign', 'Proposal', 15000.00, '2024-08-15');

INSERT INTO Leads (lead_name, email, phone_number, source, status)
VALUES ('Jane Smith', 'jane.smith@example.com', '0987654321', 'Website', 'Contacted');

INSERT INTO SupportTickets (customer_id, subject, description, status)
VALUES (1, 'Login Issue', 'Customer cannot log in to the portal', 'Open');

INSERT INTO Campaigns (campaign_name, start_date, end_date, budget, description)
VALUES ('Summer Sale', '2024-06-01', '2024-08-01', 10000.00, 'Discounts on summer products');

-- Test Calls
CALL GetCustomerDetails(1);
CALL GetOpportunitiesByCustomer(1);
CALL GetLeadsByStatus('Contacted');
CALL GetSupportTicketsByCustomer(1);
CALL GetCampaignsByBudget(5000);
