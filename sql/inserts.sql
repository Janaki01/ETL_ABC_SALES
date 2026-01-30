INSERT INTO customer (customername, city, state, country) VALUES
('Haynes','Gandhinagar','Gujrat','India'),
('Sneha','Bangalore','Karnataka','India'),
('Tamanna','Delhi','Delhi','India'),
('Janaki','Hyderabad','Telangana','India'),
('Krishna','Hyderabad','Telangana','India'),
('Rashmi','Noida','Uttar Pradesh','India'),
('Akhila','Gandhinagar','Gujrat','India'),
('Pranjali','Mumbai','Maharashtra','India'),
('Rohit','Gandhinagar','Gujrat','India'),
('Gaurav','Pune','Maharashtra','India');

INSERT INTO product (productname, manufacturingdate, shelflifeinmonths, rate, quantity) VALUES
('Laptop','2025-01-10',24,65000,30),
('Smartphone','2025-02-15',18,45000,50),
('Tablet','2025-03-20',18,30000,40),
('Monitor','2025-01-05',36,12000,25),
('Keyboard','2025-04-12',48,1500,100),
('Mouse','2025-04-18',48,800,120),
('Printer','2025-02-22',24,9000,15),
('WiFi Router','2025-03-28',36,3500,35),
('External Hard Drive','2025-01-09',24,6000,20),
('Webcam','2025-02-11',36,2500,60);

INSERT INTO taxation (taxname, taxtypeapplicable, taxamount, applicableyorn) VALUES
('GST 5%','Products',5,'Y'),
('GST 12%','Products',12,'Y'),
('GST 18%','Products',18,'Y'),
('GST 28%','Products',28,'Y'),
('GST Exempt','Products',NULL,'N'),
('Service Charge 5%','Orders',5,'Y'),
('Service Charge 10%','Orders',10,'Y'),
('Packaging Tax 2%','Orders',2,'Y'),
('Delivery Tax','Orders',NULL,'N');

INSERT INTO discount (productid, discountamount, discountpercentage) VALUES
(1, NULL, 8),
(2, 1000, NULL),
(3, NULL, 5),
(4, 1000, NULL),
(5, NULL, 10),
(6, NULL, 5),
(7, 500, NULL),
(8, NULL, 12),
(9, 750, NULL),
(10, NULL, 7);
 