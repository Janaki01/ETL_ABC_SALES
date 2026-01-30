-- =========================
-- CUSTOMER
-- =========================
CREATE TABLE customer (
    customerid SERIAL PRIMARY KEY,
    customername VARCHAR(200) NOT NULL,
    address1 VARCHAR(200),
    address2 VARCHAR(200),
    city VARCHAR(100),
    state VARCHAR(100),
    country VARCHAR(100),
    status VARCHAR(50) NOT NULL DEFAULT 'Active',
    createdon TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedon TIMESTAMP
);
 
-- =========================
-- PRODUCT
-- =========================
CREATE TABLE product (
    productid SERIAL PRIMARY KEY,
    productname VARCHAR(200) NOT NULL,
    manufacturingdate DATE,
    shelflifeinmonths INT,
    rate DECIMAL(18,2) NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    createdon TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedon TIMESTAMP
);
 
-- =========================
-- DISCOUNT
-- =========================
CREATE TABLE discount (
    discountid SERIAL PRIMARY KEY,
    productid INT,
    discountamount DECIMAL(18,2),
    discountpercentage DECIMAL(5,2),
    status VARCHAR(50) NOT NULL DEFAULT 'Active',
    createdon TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedon TIMESTAMP,
    CONSTRAINT fk_discount_product FOREIGN KEY (productid)
        REFERENCES product(productid)
);
 
-- =========================
-- TAXATION
-- =========================
CREATE TABLE taxation (
    taxid SERIAL PRIMARY KEY,
    taxname VARCHAR(200) NOT NULL,
    taxtypeapplicable VARCHAR(50) NOT NULL CHECK (taxtypeapplicable IN ('Orders','Products')),
    taxamount DECIMAL(18,2),
    applicableyorn CHAR(1) NOT NULL CHECK (applicableyorn IN ('Y','N')),
    createdon TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedon TIMESTAMP
);
 
-- =========================
-- ORDER TRANSACTION
-- =========================
CREATE TABLE ordertransaction (
    orderid SERIAL PRIMARY KEY,
    customerid INT NOT NULL,
    taxid INT,
    totalamount DECIMAL(18,2),
    createdon TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedon TIMESTAMP,
 
    CONSTRAINT fk_order_customer FOREIGN KEY (customerid)
        REFERENCES customer(customerid),
 
    CONSTRAINT fk_order_tax FOREIGN KEY (taxid)
        REFERENCES taxation(taxid)
);
 
-- =========================
-- ORDER LINE ITEMS
-- =========================
CREATE TABLE orderlineitems (
    orderlineitemid SERIAL PRIMARY KEY,
    orderid INT NOT NULL,
    productid INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    uom VARCHAR(50),
    rate DECIMAL(18,2) NOT NULL,
    discountid INT,
    taxid INT,
    amount DECIMAL(18,2),
    createdon TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedon TIMESTAMP,
 
    CONSTRAINT fk_oli_order FOREIGN KEY (orderid)
        REFERENCES ordertransaction(orderid),
 
    CONSTRAINT fk_oli_product FOREIGN KEY (productid)
        REFERENCES product(productid),
 
    CONSTRAINT fk_oli_discount FOREIGN KEY (discountid)
        REFERENCES discount(discountid),
 
    CONSTRAINT fk_oli_tax FOREIGN KEY (taxid)
        REFERENCES taxation(taxid)
);