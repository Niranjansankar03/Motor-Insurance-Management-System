CREATE DATABASE motor_insurance_db;
USE motor_insurance_db;
CREATE TABLE customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    dob DATE,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(200)
);
CREATE TABLE vehicle (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    registration_no VARCHAR(20) UNIQUE,
    vehicle_type ENUM('Car', 'Bike'),
    make_name VARCHAR(50),
    model_name VARCHAR(50),
    manufacture_year YEAR,
    color VARCHAR(30),
    CONSTRAINT fk_vehicle_customer FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id)
);
CREATE TABLE insurance_company (
    company_id INT AUTO_INCREMENT PRIMARY KEY,
    company_name VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(100)
);
CREATE TABLE policy (
    policy_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_number VARCHAR(20) UNIQUE NOT NULL,
    customer_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    company_id INT NOT NULL,
    policy_type ENUM('Third Party', 'Comprehensive', 'Own Damage') NOT NULL,
    premium_amount DECIMAL(10 , 2 ) NOT NULL,
    issue_date DATE NOT NULL,
    start_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    policy_status ENUM('Active', 'Expired', 'Cancelled') DEFAULT 'Active',
    CONSTRAINT fk_policy_customer FOREIGN KEY (customer_id)
        REFERENCES customer (customer_id),
    CONSTRAINT fk_policy_vehicle FOREIGN KEY (vehicle_id)
        REFERENCES vehicle (vehicle_id),
    CONSTRAINT fk_policy_company FOREIGN KEY (company_id)
        REFERENCES insurance_company (company_id)
);
CREATE TABLE payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    payment_date DATE NOT NULL,
    payment_mode ENUM('Cash', 'Credit Card', 'Debit Card', 'UPI', 'Net Banking') NOT NULL,
    amount DECIMAL(10 , 2 ) NOT NULL,
    payment_status ENUM('Paid', 'Pending', 'Failed') NOT NULL,
    CONSTRAINT fk_payment_policy FOREIGN KEY (policy_id)
        REFERENCES policy (policy_id)
);
CREATE TABLE claim_details (
    claim_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    claim_number VARCHAR(20) UNIQUE NOT NULL,
    claim_date DATE NOT NULL,
    claim_amount DECIMAL(10 , 2 ) NOT NULL,
    claim_reason VARCHAR(100),
    claim_status ENUM('Pending', 'Approved', 'Rejected') NOT NULL,
    CONSTRAINT fk_claim_policy FOREIGN KEY (policy_id)
        REFERENCES policy (policy_id)
);
CREATE TABLE agent (
    agent_id INT AUTO_INCREMENT PRIMARY KEY,
    agent_name VARCHAR(100) NOT NULL,
    gender ENUM('Male', 'Female') NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    experience_years INT NOT NULL,
    commission_percent DECIMAL(5 , 2 ) NOT NULL,
    city VARCHAR(50) NOT NULL
);
CREATE TABLE branch (
    branch_id INT AUTO_INCREMENT PRIMARY KEY,
    branch_name VARCHAR(100) NOT NULL,
    company_id INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    CONSTRAINT fk_branch_company FOREIGN KEY (company_id)
        REFERENCES insurance_company (company_id)
);
CREATE TABLE policy_assignment (
    assignment_id INT AUTO_INCREMENT,
    policy_id INT NOT NULL,
    agent_id INT NOT NULL,
    branch_id INT NOT NULL,
    assignment_date DATE NOT NULL,
    remarks VARCHAR(100),
    CONSTRAINT pk_assignment PRIMARY KEY (assignment_id),
    CONSTRAINT fk_assignment_policy FOREIGN KEY (policy_id)
        REFERENCES policy (policy_id),
    CONSTRAINT fk_assignment_agent FOREIGN KEY (agent_id)
        REFERENCES agent (agent_id),
    CONSTRAINT fk_assignment_branch FOREIGN KEY (branch_id)
        REFERENCES branch (branch_id)
);
CREATE TABLE nominee (
    nominee_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    nominee_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50) NOT NULL,
    age INT NOT NULL,
    phone VARCHAR(15) UNIQUE,

    CONSTRAINT fk_nominee_customer
    FOREIGN KEY (customer_id)
    REFERENCES customer(customer_id)
);
CREATE TABLE garage (
    garage_id INT AUTO_INCREMENT,
    garage_name VARCHAR(100) NOT NULL,
    company_id INT NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    garage_type ENUM('Authorized','Network','Local') NOT NULL,

    CONSTRAINT pk_garage
    PRIMARY KEY (garage_id),

    CONSTRAINT fk_garage_company
    FOREIGN KEY (company_id)
    REFERENCES insurance_company(company_id)
);
CREATE TABLE service_record (
    service_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    garage_id INT NOT NULL,
    service_date DATE NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    service_cost DECIMAL(10,2) NOT NULL,
    service_status ENUM('Completed','Pending','In Progress') NOT NULL,

    CONSTRAINT fk_service_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES vehicle(vehicle_id),

    CONSTRAINT fk_service_garage
    FOREIGN KEY (garage_id)
    REFERENCES garage(garage_id)
);
CREATE TABLE renewal (
    renewal_id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    renewal_date DATE NOT NULL,
    expiry_date DATE NOT NULL,
    renewal_premium DECIMAL(10,2) NOT NULL,
    renewal_status ENUM('Completed','Pending','Cancelled') NOT NULL,
    payment_status ENUM('Paid','Pending') NOT NULL,

    CONSTRAINT fk_renewal_policy
    FOREIGN KEY (policy_id)
    REFERENCES policy(policy_id)
);
CREATE TABLE accident (
    accident_id INT AUTO_INCREMENT PRIMARY KEY,
    vehicle_id INT NOT NULL,
    policy_id INT NOT NULL,
    accident_date DATE NOT NULL,
    accident_location VARCHAR(100) NOT NULL,
    damage_level ENUM('Minor','Moderate','Major') NOT NULL,
    estimated_loss DECIMAL(10,2) NOT NULL,
    accident_status ENUM('Reported','Under Investigation','Closed') NOT NULL,

    CONSTRAINT fk_accident_vehicle
    FOREIGN KEY (vehicle_id)
    REFERENCES vehicle(vehicle_id),

    CONSTRAINT fk_accident_policy
    FOREIGN KEY (policy_id)
    REFERENCES policy(policy_id)
);
CREATE TABLE document (
    document_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    policy_id INT NOT NULL,
    document_name VARCHAR(100) NOT NULL,
    document_type ENUM('RC Book','Driving License','Aadhaar Card','PAN Card','Insurance Copy') NOT NULL,
    upload_date DATE NOT NULL,
    verification_status ENUM('Verified','Pending','Rejected') NOT NULL,

    CONSTRAINT fk_document_customer
    FOREIGN KEY (customer_id)
    REFERENCES customer(customer_id),

    CONSTRAINT fk_document_policy
    FOREIGN KEY (policy_id)
    REFERENCES policy(policy_id)
);

INSERT INTO customer (customer_name, gender, dob, phone, email, address) 
VALUES
('Arun Kumar','Male','1995-02-10','9876543201','arun@gmail.com','Chennai'),
('Priya Sharma','Female','1997-05-12','9876543202','priya@gmail.com','Coimbatore'),
('Rahul Singh','Male','1993-07-15','9876543203','rahul@gmail.com','Madurai'),
('Sneha Reddy','Female','1998-09-20','9876543204','sneha@gmail.com','Salem'),
('Vijay Kumar','Male','1992-11-11','9876543205','vijay@gmail.com','Trichy'),
('Anjali Devi','Female','1999-01-18','9876543206','anjali@gmail.com','Erode'),
('Rohit Jain','Male','1996-03-25','9876543207','rohit@gmail.com','Vellore'),
('Kavya Nair','Female','1997-04-19','9876543208','kavya@gmail.com','Tirunelveli'),
('Ajith Kumar','Male','1994-08-30','9876543209','ajith@gmail.com','Chennai'),
('Meena Rao','Female','1995-10-05','9876543210','meena@gmail.com','Karur'),
('Suresh Babu','Male','1991-06-17','9876543211','suresh@gmail.com','Namakkal'),
('Divya Raj','Female','1996-12-22','9876543212','divya@gmail.com','Dindigul'),
('Kiran Das','Male','1998-05-16','9876543213','kiran@gmail.com','Thoothukudi'),
('Pooja Patel','Female','1993-09-09','9876543214','pooja@gmail.com','Kanchipuram'),
('Hari Prasad','Male','1997-07-07','9876543215','hari@gmail.com','Chennai'),
('Nisha Gupta','Female','1999-11-14','9876543216','nisha@gmail.com','Hosur'),
('Deepak Singh','Male','1992-04-28','9876543217','deepak@gmail.com','Thanjavur'),
('Asha Kumari','Female','1995-02-26','9876543218','asha@gmail.com','Cuddalore'),
('Ganesh Kumar','Male','1994-01-01','9876543219','ganesh@gmail.com','Chennai'),
('Lakshmi Devi','Female','1998-03-03','9876543220','lakshmi@gmail.com','Tiruppur'),
('Manoj Kumar','Male','1991-12-12','9876543221','manoj@gmail.com','Madurai'),
('Keerthana','Female','1997-08-08','9876543222','keerthana@gmail.com','Salem'),
('Prakash Raj','Male','1990-10-10','9876543223','prakash@gmail.com','Erode'),
('Swathi R','Female','1996-06-06','9876543224','swathi@gmail.com','Chennai'),
('Naveen Kumar','Male','1995-09-19','9876543225','naveen@gmail.com','Coimbatore');

INSERT INTO vehicle (customer_id, registration_no, vehicle_type, make_name, model_name, manufacture_year, color) 
VALUES
(1,'TN01AB1001','Car','Hyundai','i20',2022,'White'),
(2,'TN02AB1002','Bike','Honda','Shine',2021,'Black'),
(3,'TN03AB1003','Car','Maruti','Swift',2023,'Blue'),
(4,'TN04AB1004','Bike','TVS','Apache',2022,'Red'),
(5,'TN05AB1005','Car','Tata','Punch',2024,'Grey'),
(6,'TN06AB1006','Bike','Yamaha','FZ',2022,'Blue'),
(7,'TN07AB1007','Car','Mahindra','XUV300',2021,'White'),
(8,'TN08AB1008','Bike','Bajaj','Pulsar',2023,'Black'),
(9,'TN09AB1009','Car','Kia','Seltos',2022,'Silver'),
(10,'TN10AB1010','Bike','Hero','Splendor',2020,'Red'),
(11,'TN11AB1011','Car','Toyota','Glanza',2023,'Blue'),
(12,'TN12AB1012','Bike','Suzuki','Access',2022,'Grey'),
(13,'TN13AB1013','Car','Honda','City',2021,'White'),
(14,'TN14AB1014','Bike','Royal Enfield','Classic 350',2024,'Black'),
(15,'TN15AB1015','Car','Hyundai','Creta',2023,'Silver'),
(16,'TN16AB1016','Bike','TVS','Jupiter',2021,'Blue'),
(17,'TN17AB1017','Car','Maruti','Baleno',2022,'Red'),
(18,'TN18AB1018','Bike','Honda','Activa',2023,'White'),
(19,'TN19AB1019','Car','Tata','Nexon',2024,'Grey'),
(20,'TN20AB1020','Bike','Yamaha','R15',2022,'Blue'),
(21,'TN21AB1021','Car','MG','Astor',2023,'Black'),
(22,'TN22AB1022','Bike','Hero','Xtreme',2021,'Red'),
(23,'TN23AB1023','Car','Skoda','Slavia',2022,'White'),
(24,'TN24AB1024','Bike','KTM','Duke 200',2024,'Orange'),
(25,'TN25AB1025','Car','Volkswagen','Virtus',2023,'Silver');

INSERT INTO insurance_company (company_name, phone, email) 
VALUES
('ICICI Lombard','18001001001','support@icicilombard.com'),
('HDFC ERGO','18001001002','support@hdfcergo.com'),
('Bajaj Allianz','18001001003','support@bajajallianz.com'),
('TATA AIG','18001001004','support@tataaig.com'),
('New India Assurance','18001001005','support@newindia.com'),
('Oriental Insurance','18001001006','support@oriental.com'),
('United India Insurance','18001001007','support@uiic.com'),
('National Insurance','18001001008','support@nic.co.in'),
('Reliance General','18001001009','support@reliancegeneral.com'),
('SBI General','18001001010','support@sbigeneral.com'),
('Future Generali','18001001011','support@futuregenerali.com'),
('IFFCO Tokio','18001001012','support@iffcotokio.com'),
('Liberty General','18001001013','support@libertyinsurance.com'),
('Magma HDI','18001001014','support@magmahdi.com'),
('Kotak General','18001001015','support@kotakgeneral.com'),
('Acko','18001001016','support@acko.com'),
('Digit Insurance','18001001017','support@godigit.com'),
('Chola MS','18001001018','support@cholams.com'),
('Royal Sundaram','18001001019','support@royalsundaram.com'),
('Shriram General','18001001020','support@shriramgi.com'),
('Raheja QBE','18001001021','support@rahejaqbe.com'),
('Universal Sompo','18001001022','support@universalsompo.com'),
('Zurich Kotak','18001001023','support@zurichkotak.com'),
('Go Digit','18001001024','support@godigit.com'),
('ACKO Drive','18001001025','support@ackodrive.com');

INSERT INTO policy (policy_number, customer_id, vehicle_id, company_id, policy_type, premium_amount, issue_date, start_date, expiry_date, policy_status)
VALUES
('POL1001',1,1,1,'Comprehensive',12500.00,'2025-01-01','2025-01-02','2026-01-01','Active'),
('POL1002',2,2,2,'Third Party',4800.00,'2025-01-03','2025-01-04','2026-01-03','Active'),
('POL1003',3,3,3,'Own Damage',7600.00,'2025-01-05','2025-01-06','2026-01-05','Active'),
('POL1004',4,4,4,'Comprehensive',13200.00,'2025-01-07','2025-01-08','2026-01-07','Active'),
('POL1005',5,5,5,'Third Party',5100.00,'2025-01-09','2025-01-10','2026-01-09','Active'),
('POL1006',6,6,6,'Own Damage',6900.00,'2025-01-11','2025-01-12','2026-01-11','Active'),
('POL1007',7,7,7,'Comprehensive',14800.00,'2025-01-13','2025-01-14','2026-01-13','Active'),
('POL1008',8,8,8,'Third Party',4700.00,'2025-01-15','2025-01-16','2026-01-15','Active'),
('POL1009',9,9,9,'Own Damage',8100.00,'2025-01-17','2025-01-18','2026-01-17','Active'),
('POL1010',10,10,10,'Comprehensive',13900.00,'2025-01-19','2025-01-20','2026-01-19','Active'),
('POL1011',11,11,11,'Third Party',4950.00,'2025-01-21','2025-01-22','2026-01-21','Expired'),
('POL1012',12,12,12,'Own Damage',7300.00,'2025-01-23','2025-01-24','2026-01-23','Active'),
('POL1013',13,13,13,'Comprehensive',15100.00,'2025-01-25','2025-01-26','2026-01-25','Active'),
('POL1014',14,14,14,'Third Party',5200.00,'2025-01-27','2025-01-28','2026-01-27','Cancelled'),
('POL1015',15,15,15,'Own Damage',7850.00,'2025-01-29','2025-01-30','2026-01-29','Active'),
('POL1016',16,16,16,'Comprehensive',14450.00,'2025-02-01','2025-02-02','2026-02-01','Active'),
('POL1017',17,17,17,'Third Party',5300.00,'2025-02-03','2025-02-04','2026-02-03','Active'),
('POL1018',18,18,18,'Own Damage',8050.00,'2025-02-05','2025-02-06','2026-02-05','Expired'),
('POL1019',19,19,19,'Comprehensive',15600.00,'2025-02-07','2025-02-08','2026-02-07','Active'),
('POL1020',20,20,20,'Third Party',5000.00,'2025-02-09','2025-02-10','2026-02-09','Active'),
('POL1021',21,21,21,'Own Damage',7700.00,'2025-02-11','2025-02-12','2026-02-11','Active'),
('POL1022',22,22,22,'Comprehensive',14900.00,'2025-02-13','2025-02-14','2026-02-13','Cancelled'),
('POL1023',23,23,23,'Third Party',5150.00,'2025-02-15','2025-02-16','2026-02-15','Active'),
('POL1024',24,24,24,'Own Damage',7900.00,'2025-02-17','2025-02-18','2026-02-17','Active'),
('POL1025',25,25,25,'Comprehensive',16000.00,'2025-02-19','2025-02-20','2026-02-19','Active');

INSERT INTO payment (policy_id, payment_date, payment_mode, amount, payment_status)
VALUES
(1,'2025-01-02','UPI',12500.00,'Paid'),
(2,'2025-01-04','Cash',4800.00,'Paid'),
(3,'2025-01-06','Credit Card',7600.00,'Paid'),
(4,'2025-01-08','Net Banking',13200.00,'Paid'),
(5,'2025-01-10','Debit Card',5100.00,'Paid'),
(6,'2025-01-12','UPI',6900.00,'Paid'),
(7,'2025-01-14','Credit Card',14800.00,'Paid'),
(8,'2025-01-16','Cash',4700.00,'Paid'),
(9,'2025-01-18','Debit Card',8100.00,'Paid'),
(10,'2025-01-20','Net Banking',13900.00,'Paid'),
(11,'2025-01-22','UPI',4950.00,'Paid'),
(12,'2025-01-24','Credit Card',7300.00,'Paid'),
(13,'2025-01-26','Cash',15100.00,'Paid'),
(14,'2025-01-28','Debit Card',5200.00,'Pending'),
(15,'2025-01-30','Net Banking',7850.00,'Paid'),
(16,'2025-02-02','UPI',14450.00,'Paid'),
(17,'2025-02-04','Credit Card',5300.00,'Paid'),
(18,'2025-02-06','Cash',8050.00,'Failed'),
(19,'2025-02-08','Debit Card',15600.00,'Paid'),
(20,'2025-02-10','Net Banking',5000.00,'Paid'),
(21,'2025-02-12','UPI',7700.00,'Paid'),
(22,'2025-02-14','Credit Card',14900.00,'Pending'),
(23,'2025-02-16','Cash',5150.00,'Paid'),
(24,'2025-02-18','Debit Card',7900.00,'Paid'),
(25,'2025-02-20','Net Banking',16000.00,'Paid');

INSERT INTO claim_details (policy_id, claim_number, claim_date, claim_amount, claim_reason, claim_status)
VALUES
(1,'CLM1001','2025-03-01',25000.00,'Accident Damage','Approved'),
(2,'CLM1002','2025-03-03',8000.00,'Third Party Damage','Pending'),
(3,'CLM1003','2025-03-05',12000.00,'Windshield Damage','Approved'),
(4,'CLM1004','2025-03-07',35000.00,'Major Accident','Rejected'),
(5,'CLM1005','2025-03-09',9500.00,'Vehicle Theft','Pending'),
(6,'CLM1006','2025-03-11',7000.00,'Engine Damage','Approved'),
(7,'CLM1007','2025-03-13',28000.00,'Flood Damage','Approved'),
(8,'CLM1008','2025-03-15',6500.00,'Fire Damage','Rejected'),
(9,'CLM1009','2025-03-17',15000.00,'Road Accident','Approved'),
(10,'CLM1010','2025-03-19',42000.00,'Total Loss','Pending'),
(11,'CLM1011','2025-03-21',5500.00,'Glass Damage','Approved'),
(12,'CLM1012','2025-03-23',11000.00,'Tyre Damage','Rejected'),
(13,'CLM1013','2025-03-25',30000.00,'Collision','Approved'),
(14,'CLM1014','2025-03-27',9000.00,'Minor Accident','Pending'),
(15,'CLM1015','2025-03-29',14000.00,'Natural Disaster','Approved'),
(16,'CLM1016','2025-03-31',21000.00,'Engine Failure','Rejected'),
(17,'CLM1017','2025-04-02',12500.00,'Third Party Claim','Approved'),
(18,'CLM1018','2025-04-04',17500.00,'Vehicle Theft','Pending'),
(19,'CLM1019','2025-04-06',26000.00,'Flood Damage','Approved'),
(20,'CLM1020','2025-04-08',8000.00,'Scratches and Dent','Rejected'),
(21,'CLM1021','2025-04-10',15500.00,'Road Accident','Approved'),
(22,'CLM1022','2025-04-12',22500.00,'Fire Damage','Pending'),
(23,'CLM1023','2025-04-14',10500.00,'Windshield Damage','Approved'),
(24,'CLM1024','2025-04-16',18000.00,'Collision','Rejected'),
(25,'CLM1025','2025-04-18',40000.00,'Total Loss','Approved');

INSERT INTO agent (agent_name, gender, phone, email, experience_years, commission_percent, city)
VALUES
('Ramesh Kumar','Male','9876501001','ramesh@agent.com',8,5.50,'Chennai'),
('Priya Nair','Female','9876501002','priya@agent.com',6,4.75,'Coimbatore'),
('Suresh Babu','Male','9876501003','suresh@agent.com',10,6.00,'Madurai'),
('Divya Sharma','Female','9876501004','divya@agent.com',5,4.50,'Salem'),
('Arun Raj','Male','9876501005','arun@agent.com',9,5.75,'Trichy'),
('Kavitha R','Female','9876501006','kavitha@agent.com',7,5.25,'Erode'),
('Vignesh P','Male','9876501007','vignesh@agent.com',4,4.00,'Vellore'),
('Meena Devi','Female','9876501008','meena@agent.com',11,6.25,'Tirunelveli'),
('Hari Prasad','Male','9876501009','hari@agent.com',3,3.75,'Chennai'),
('Nisha Gupta','Female','9876501010','nisha@agent.com',8,5.50,'Karur'),
('Ganesh Kumar','Male','9876501011','ganesh@agent.com',12,6.50,'Namakkal'),
('Anjali Singh','Female','9876501012','anjali@agent.com',5,4.25,'Dindigul'),
('Rahul Das','Male','9876501013','rahul@agent.com',9,5.80,'Thoothukudi'),
('Pooja Patel','Female','9876501014','pooja@agent.com',6,4.90,'Kanchipuram'),
('Deepak Jain','Male','9876501015','deepak@agent.com',7,5.10,'Chennai'),
('Asha Kumari','Female','9876501016','asha@agent.com',10,6.00,'Hosur'),
('Manoj Kumar','Male','9876501017','manoj@agent.com',4,4.10,'Thanjavur'),
('Keerthana S','Female','9876501018','keerthana@agent.com',8,5.60,'Cuddalore'),
('Prakash Raj','Male','9876501019','prakash@agent.com',13,6.75,'Tiruppur'),
('Swathi R','Female','9876501020','swathi@agent.com',5,4.40,'Chennai'),
('Naveen Kumar','Male','9876501021','naveen@agent.com',9,5.70,'Coimbatore'),
('Lakshmi Devi','Female','9876501022','lakshmi@agent.com',6,4.85,'Madurai'),
('Ajith Kumar','Male','9876501023','ajith@agent.com',11,6.30,'Salem'),
('Sneha Reddy','Female','9876501024','sneha@agent.com',7,5.15,'Erode'),
('Rohit Sharma','Male','9876501025','rohit@agent.com',10,6.20,'Chennai');

INSERT INTO branch (branch_name, company_id, city, state, phone, email)
VALUES
('ICICI Chennai Branch',1,'Chennai','Tamil Nadu','0444001001','chennai@iciciinsurance.com'),
('HDFC Coimbatore Branch',2,'Coimbatore','Tamil Nadu','04224001002','coimbatore@hdfcergo.com'),
('Bajaj Madurai Branch',3,'Madurai','Tamil Nadu','04524001003','madurai@bajajallianz.com'),
('TATA Salem Branch',4,'Salem','Tamil Nadu','04274001004','salem@tataaig.com'),
('New India Trichy Branch',5,'Trichy','Tamil Nadu','04314001005','trichy@newindia.com'),
('Oriental Erode Branch',6,'Erode','Tamil Nadu','04244001006','erode@orientalinsurance.com'),
('United India Vellore Branch',7,'Vellore','Tamil Nadu','04164001007','vellore@uiic.com'),
('National Tirunelveli Branch',8,'Tirunelveli','Tamil Nadu','04624001008','tirunelveli@nic.co.in'),
('Reliance Karur Branch',9,'Karur','Tamil Nadu','04324001009','karur@reliancegeneral.com'),
('SBI Namakkal Branch',10,'Namakkal','Tamil Nadu','04286001010','namakkal@sbigeneral.com'),
('Future Dindigul Branch',11,'Dindigul','Tamil Nadu','04514001011','dindigul@futuregenerali.com'),
('IFFCO Thoothukudi Branch',12,'Thoothukudi','Tamil Nadu','04614001012','thoothukudi@iffcotokio.com'),
('Liberty Kanchipuram Branch',13,'Kanchipuram','Tamil Nadu','0444001013','kanchipuram@liberty.com'),
('Magma Hosur Branch',14,'Hosur','Tamil Nadu','04344001014','hosur@magmahdi.com'),
('Kotak Thanjavur Branch',15,'Thanjavur','Tamil Nadu','04362001015','thanjavur@kotakgeneral.com'),
('Acko Cuddalore Branch',16,'Cuddalore','Tamil Nadu','04142001016','cuddalore@acko.com'),
('Digit Tiruppur Branch',17,'Tiruppur','Tamil Nadu','04212001017','tiruppur@godigit.com'),
('Chola MS Pudukkottai Branch',18,'Pudukkottai','Tamil Nadu','04322001018','pudukkottai@cholams.com'),
('Royal Sundaram Kumbakonam Branch',19,'Kumbakonam','Tamil Nadu','04352001019','kumbakonam@royalsundaram.com'),
('Shriram Nagercoil Branch',20,'Nagercoil','Tamil Nadu','04652001020','nagercoil@shriramgi.com'),
('Raheja QBE Tiruvannamalai Branch',21,'Tiruvannamalai','Tamil Nadu','04175001021','tiruvannamalai@rahejaqbe.com'),
('Universal Sompo Villupuram Branch',22,'Villupuram','Tamil Nadu','04146001022','villupuram@universalsompo.com'),
('Zurich Kotak Sivakasi Branch',23,'Sivakasi','Tamil Nadu','04562001023','sivakasi@zurichkotak.com'),
('Go Digit Pollachi Branch',24,'Pollachi','Tamil Nadu','04259001024','pollachi@godigit.com'),
('ACKO Drive Chennai South Branch',25,'Chennai','Tamil Nadu','0444001025','chennaisouth@ackodrive.com');

INSERT INTO policy_assignment (policy_id, agent_id, branch_id, assignment_date, remarks)
VALUES
(1,1,1,'2025-01-02','New Policy Issued'),
(2,2,2,'2025-01-04','Third Party Policy'),
(3,3,3,'2025-01-06','Own Damage Policy'),
(4,4,4,'2025-01-08','Policy Renewed'),
(5,5,5,'2025-01-10','New Customer'),
(6,6,6,'2025-01-12','Vehicle Inspection Completed'),
(7,7,7,'2025-01-14','Premium Paid'),
(8,8,8,'2025-01-16','Documents Verified'),
(9,9,9,'2025-01-18','Policy Activated'),
(10,10,10,'2025-01-20','Online Purchase'),
(11,11,11,'2025-01-22','Renewal Completed'),
(12,12,12,'2025-01-24','Discount Applied'),
(13,13,13,'2025-01-26','High Value Vehicle'),
(14,14,14,'2025-01-28','Claim History Checked'),
(15,15,15,'2025-01-30','Premium Updated'),
(16,16,16,'2025-02-02','Cashless Garage Enabled'),
(17,17,17,'2025-02-04','No Claim Bonus Applied'),
(18,18,18,'2025-02-06','Inspection Pending'),
(19,19,19,'2025-02-08','Policy Confirmed'),
(20,20,20,'2025-02-10','Customer Verified'),
(21,21,21,'2025-02-12','Policy Issued Successfully'),
(22,22,22,'2025-02-14','Waiting for Payment'),
(23,23,23,'2025-02-16','Renewal Reminder Sent'),
(24,24,24,'2025-02-18','Documents Uploaded'),
(25,25,25,'2025-02-20','Policy Completed');

INSERT INTO nominee (customer_id, nominee_name, relationship, age, phone)
VALUES
(1,'Ravi Kumar','Father',58,'9876510001'),
(2,'Lakshmi Devi','Mother',55,'9876510002'),
(3,'Priya Singh','Wife',29,'9876510003'),
(4,'Karthik Kumar','Brother',27,'9876510004'),
(5,'Anitha Devi','Sister',24,'9876510005'),
(6,'Suresh Kumar','Father',60,'9876510006'),
(7,'Meena Kumari','Mother',54,'9876510007'),
(8,'Divya Sharma','Wife',30,'9876510008'),
(9,'Rahul Raj','Brother',26,'9876510009'),
(10,'Pooja Patel','Sister',23,'9876510010'),
(11,'Ganesh Kumar','Father',57,'9876510011'),
(12,'Asha Devi','Mother',53,'9876510012'),
(13,'Nisha Gupta','Wife',31,'9876510013'),
(14,'Deepak Kumar','Brother',29,'9876510014'),
(15,'Keerthana','Sister',22,'9876510015'),
(16,'Hari Prasad','Father',59,'9876510016'),
(17,'Lakshmi','Mother',56,'9876510017'),
(18,'Sneha Reddy','Wife',28,'9876510018'),
(19,'Ajith Kumar','Brother',25,'9876510019'),
(20,'Swathi','Sister',24,'9876510020'),
(21,'Prakash Raj','Father',61,'9876510021'),
(22,'Kavya Nair','Mother',52,'9876510022'),
(23,'Rohit Sharma','Wife',30,'9876510023'),
(24,'Manoj Kumar','Brother',27,'9876510024'),
(25,'Anjali Devi','Sister',23,'9876510025');

INSERT INTO garage (garage_name, company_id, city, state, phone, garage_type)
VALUES
('ABC Motors',1,'Chennai','Tamil Nadu','9876601001','Authorized'),
('Speed Wheels',2,'Coimbatore','Tamil Nadu','9876601002','Network'),
('Royal Auto Garage',3,'Madurai','Tamil Nadu','9876601003','Authorized'),
('Elite Car Care',4,'Salem','Tamil Nadu','9876601004','Network'),
('City Garage',5,'Trichy','Tamil Nadu','9876601005','Local'),
('Auto Tech',6,'Erode','Tamil Nadu','9876601006','Authorized'),
('Fast Track Motors',7,'Vellore','Tamil Nadu','9876601007','Network'),
('Perfect Garage',8,'Karur','Tamil Nadu','9876601008','Local'),
('Prime Auto Works',9,'Namakkal','Tamil Nadu','9876601009','Authorized'),
('National Car Care',10,'Dindigul','Tamil Nadu','9876601010','Network'),
('Smart Garage',11,'Thoothukudi','Tamil Nadu','9876601011','Local'),
('Express Motors',12,'Kanchipuram','Tamil Nadu','9876601012','Authorized'),
('Shree Auto',13,'Hosur','Tamil Nadu','9876601013','Network'),
('Modern Garage',14,'Thanjavur','Tamil Nadu','9876601014','Authorized'),
('Classic Motors',15,'Cuddalore','Tamil Nadu','9876601015','Local'),
('Universal Garage',16,'Tiruppur','Tamil Nadu','9876601016','Authorized'),
('Golden Wheels',17,'Pollachi','Tamil Nadu','9876601017','Network'),
('Victory Auto Care',18,'Sivakasi','Tamil Nadu','9876601018','Authorized'),
('Star Garage',19,'Villupuram','Tamil Nadu','9876601019','Local'),
('City Auto Works',20,'Nagercoil','Tamil Nadu','9876601020','Authorized'),
('Green Motors',21,'Pudukkottai','Tamil Nadu','9876601021','Network'),
('Trust Garage',22,'Kumbakonam','Tamil Nadu','9876601022','Authorized'),
('Future Auto Care',23,'Tiruvannamalai','Tamil Nadu','9876601023','Local'),
('Power Garage',24,'Chennai','Tamil Nadu','9876601024','Authorized'),
('Supreme Motors',25,'Coimbatore','Tamil Nadu','9876601025','Network');

INSERT INTO service_record(vehicle_id, garage_id, service_date, service_type, service_cost, service_status)
 VALUES
(1,1,'2025-03-05','General Service',2500,'Completed'),
(2,2,'2025-03-08','Oil Change',1200,'Completed'),
(3,3,'2025-03-10','Engine Repair',8500,'Completed'),
(4,4,'2025-03-12','Brake Service',3000,'Pending'),
(5,5,'2025-03-15','Tyre Replacement',6000,'Completed'),
(6,6,'2025-03-18','Battery Replacement',4500,'Completed'),
(7,7,'2025-03-20','Wheel Alignment',1800,'Completed'),
(8,8,'2025-03-22','Accident Repair',15000,'In Progress'),
(9,9,'2025-03-25','AC Service',3500,'Completed'),
(10,10,'2025-03-27','General Service',2700,'Completed'),
(11,11,'2025-04-01','Engine Repair',9500,'Pending'),
(12,12,'2025-04-03','Oil Change',1300,'Completed'),
(13,13,'2025-04-05','Brake Service',3200,'Completed'),
(14,14,'2025-04-07','Tyre Replacement',6500,'Completed'),
(15,15,'2025-04-10','Battery Replacement',4200,'Completed'),
(16,16,'2025-04-12','General Service',2600,'Completed'),
(17,17,'2025-04-15','Accident Repair',18000,'Pending'),
(18,18,'2025-04-18','Wheel Alignment',1700,'Completed'),
(19,19,'2025-04-20','AC Service',3600,'Completed'),
(20,20,'2025-04-22','Oil Change',1400,'Completed'),
(21,21,'2025-04-25','Brake Service',3400,'Completed'),
(22,22,'2025-04-27','General Service',2800,'Completed'),
(23,23,'2025-04-29','Engine Repair',10200,'In Progress'),
(24,24,'2025-05-02','Battery Replacement',4700,'Completed'),
(25,25,'2025-05-05','Tyre Replacement',6800,'Completed');

INSERT INTO renewal (policy_id, renewal_date, expiry_date, renewal_premium, renewal_status, payment_status)
VALUES
(1,'2026-01-01','2027-01-01',12500,'Completed','Paid'),
(2,'2026-01-03','2027-01-03',5800,'Completed','Paid'),
(3,'2026-01-05','2027-01-05',9100,'Pending','Pending'),
(4,'2026-01-07','2027-01-07',7800,'Completed','Paid'),
(5,'2026-01-09','2027-01-09',10500,'Completed','Paid'),
(6,'2026-01-11','2027-01-11',8500,'Pending','Pending'),
(7,'2026-01-13','2027-01-13',6900,'Completed','Paid'),
(8,'2026-01-15','2027-01-15',9800,'Completed','Paid'),
(9,'2026-01-17','2027-01-17',7400,'Cancelled','Pending'),
(10,'2026-01-19','2027-01-19',11200,'Completed','Paid'),
(11,'2026-01-21','2027-01-21',8900,'Pending','Pending'),
(12,'2026-01-23','2027-01-23',6600,'Completed','Paid'),
(13,'2026-01-25','2027-01-25',10100,'Completed','Paid'),
(14,'2026-01-27','2027-01-27',9500,'Pending','Pending'),
(15,'2026-01-29','2027-01-29',8600,'Completed','Paid'),
(16,'2026-02-01','2027-02-01',9200,'Completed','Paid'),
(17,'2026-02-03','2027-02-03',9900,'Cancelled','Pending'),
(18,'2026-02-05','2027-02-05',7800,'Completed','Paid'),
(19,'2026-02-07','2027-02-07',8300,'Completed','Paid'),
(20,'2026-02-09','2027-02-09',9700,'Pending','Pending'),
(21,'2026-02-11','2027-02-11',11000,'Completed','Paid'),
(22,'2026-02-13','2027-02-13',7200,'Completed','Paid'),
(23,'2026-02-15','2027-02-15',9400,'Pending','Pending'),
(24,'2026-02-17','2027-02-17',8700,'Completed','Paid'),
(25,'2026-02-19','2027-02-19',10300,'Completed','Paid');

INSERT INTO accident (vehicle_id, policy_id, accident_date, accident_location, damage_level, estimated_loss, accident_status)
VALUES
(1,1,'2025-01-10','Chennai','Minor',12000,'Closed'),
(2,2,'2025-01-15','Coimbatore','Moderate',25000,'Reported'),
(3,3,'2025-01-20','Madurai','Major',80000,'Under Investigation'),
(4,4,'2025-01-25','Salem','Minor',10000,'Closed'),
(5,5,'2025-02-01','Trichy','Moderate',35000,'Reported'),
(6,6,'2025-02-05','Erode','Major',95000,'Under Investigation'),
(7,7,'2025-02-08','Vellore','Minor',9000,'Closed'),
(8,8,'2025-02-12','Karur','Moderate',30000,'Reported'),
(9,9,'2025-02-18','Namakkal','Major',110000,'Under Investigation'),
(10,10,'2025-02-20','Dindigul','Minor',15000,'Closed'),
(11,11,'2025-02-25','Thoothukudi','Moderate',28000,'Reported'),
(12,12,'2025-03-01','Kanchipuram','Major',98000,'Under Investigation'),
(13,13,'2025-03-05','Hosur','Minor',14000,'Closed'),
(14,14,'2025-03-10','Thanjavur','Moderate',40000,'Reported'),
(15,15,'2025-03-15','Cuddalore','Major',105000,'Under Investigation'),
(16,16,'2025-03-20','Tiruppur','Minor',17000,'Closed'),
(17,17,'2025-03-25','Pollachi','Moderate',33000,'Reported'),
(18,18,'2025-03-28','Sivakasi','Major',90000,'Under Investigation'),
(19,19,'2025-04-02','Villupuram','Minor',11000,'Closed'),
(20,20,'2025-04-05','Nagercoil','Moderate',36000,'Reported'),
(21,21,'2025-04-10','Pudukkottai','Major',115000,'Under Investigation'),
(22,22,'2025-04-15','Kumbakonam','Minor',13000,'Closed'),
(23,23,'2025-04-20','Tiruvannamalai','Moderate',29000,'Reported'),
(24,24,'2025-04-25','Chennai','Major',102000,'Under Investigation'),
(25,25,'2025-04-30','Coimbatore','Minor',16000,'Closed');

INSERT INTO document
(customer_id, policy_id, document_name, document_type, upload_date, verification_status)
VALUES
(1,1,'RC_Book_001.pdf','RC Book','2025-01-05','Verified'),
(2,2,'DL_002.pdf','Driving License','2025-01-06','Verified'),
(3,3,'AADHAAR_003.pdf','Aadhaar Card','2025-01-08','Pending'),
(4,4,'PAN_004.pdf','PAN Card','2025-01-10','Verified'),
(5,5,'INSURANCE_005.pdf','Insurance Copy','2025-01-12','Verified'),
(6,6,'RC_Book_006.pdf','RC Book','2025-01-14','Rejected'),
(7,7,'DL_007.pdf','Driving License','2025-01-16','Verified'),
(8,8,'AADHAAR_008.pdf','Aadhaar Card','2025-01-18','Pending'),
(9,9,'PAN_009.pdf','PAN Card','2025-01-20','Verified'),
(10,10,'INSURANCE_010.pdf','Insurance Copy','2025-01-22','Verified'),
(11,11,'RC_Book_011.pdf','RC Book','2025-01-24','Pending'),
(12,12,'DL_012.pdf','Driving License','2025-01-26','Verified'),
(13,13,'AADHAAR_013.pdf','Aadhaar Card','2025-01-28','Verified'),
(14,14,'PAN_014.pdf','PAN Card','2025-01-30','Rejected'),
(15,15,'INSURANCE_015.pdf','Insurance Copy','2025-02-01','Verified'),
(16,16,'RC_Book_016.pdf','RC Book','2025-02-03','Verified'),
(17,17,'DL_017.pdf','Driving License','2025-02-05','Pending'),
(18,18,'AADHAAR_018.pdf','Aadhaar Card','2025-02-07','Verified'),
(19,19,'PAN_019.pdf','PAN Card','2025-02-09','Verified'),
(20,20,'INSURANCE_020.pdf','Insurance Copy','2025-02-11','Pending'),
(21,21,'RC_Book_021.pdf','RC Book','2025-02-13','Verified'),
(22,22,'DL_022.pdf','Driving License','2025-02-15','Verified'),
(23,23,'AADHAAR_023.pdf','Aadhaar Card','2025-02-17','Rejected'),
(24,24,'PAN_024.pdf','PAN Card','2025-02-19','Verified'),
(25,25,'INSURANCE_025.pdf','Insurance Copy','2025-02-21','Verified');

SELECT 
    *
FROM
    customer;
SELECT 
    *
FROM
    vehicle;
SELECT 
    *
FROM
    insurance_company;
SELECT 
    *
FROM
    policy;
SELECT 
    *
FROM
    payment;
SELECT 
    *
FROM
    claim_details;
SELECT 
    *
FROM
    agent;
SELECT 
    *
FROM
    branch;
SELECT 
    *
FROM
    policy_assignment;
SELECT 
    *
FROM
    nominee;
SELECT 
    *
FROM
    garage;
SELECT 
    *
FROM
    service_record;
SELECT 
    *
FROM
    renewal;
SELECT 
    *
FROM
    accident;
SELECT 
    *
FROM
    document;

-- inner join
SELECT 
    c.customer_name, v.registration_no, p.policy_number
FROM
    customer c
        INNER JOIN
    vehicle v ON c.customer_id = v.customer_id
        INNER JOIN
    policy p ON v.vehicle_id = p.vehicle_id;

-- left join
SELECT 
    c.customer_name, v.registration_no, v.make_name
FROM
    customer c
        LEFT JOIN
    vehicle v ON c.customer_id = v.customer_id;

-- right join
SELECT 
    ic.company_name, p.policy_number
FROM
    policy p
        RIGHT JOIN
    insurance_company ic ON p.company_id = ic.company_id;

SELECT 
    c.customer_name, n.nominee_name, p.policy_number
FROM
    customer c
        JOIN
    nominee n ON c.customer_id = n.customer_id
        JOIN
    policy p ON c.customer_id = p.customer_id;

SELECT 
    g.garage_name,
    v.registration_no,
    sr.service_type,
    sr.service_cost
FROM
    garage g
        JOIN
    service_record sr ON g.garage_id = sr.garage_id
        JOIN
    vehicle v ON sr.vehicle_id = v.vehicle_id;

SELECT 
    c.customer_name,
    p.policy_number,
    a.accident_location,
    r.renewal_status,
    d.verification_status
FROM
    customer c
        JOIN
    policy p ON c.customer_id = p.customer_id
        JOIN
    accident a ON p.policy_id = a.policy_id
        JOIN
    renewal r ON p.policy_id = r.policy_id
        JOIN
    document d ON p.policy_id = d.policy_id;

-- Subquery
SELECT 
    customer_name
FROM
    customer
WHERE
    customer_id IN (SELECT 
            customer_id
        FROM
            policy
        WHERE
            premium_amount > (SELECT 
                    AVG(premium_amount)
                FROM
                    policy));

-- Add Column
ALTER TABLE customer
ADD occupation VARCHAR(50);

-- Modify Column
ALTER TABLE customer
MODIFY occupation VARCHAR(100);

-- Rename Column
ALTER TABLE customer
RENAME COLUMN occupation TO profession;

-- Drop Column
ALTER TABLE customer
DROP COLUMN profession;

-- Insert
INSERT INTO customer
(customer_name,gender,dob,phone,email,address)
VALUES
('Karthik','Male','1999-02-10','9876509999','karthik@gmail.com','Chennai');
SELECT 
    *
FROM
    customer;

-- Update
UPDATE customer 
SET 
    address = 'Coimbatore'
WHERE
    customer_id = 1;

-- Delete
DELETE FROM customer 
WHERE
    customer_id = 26;

-- Display all active insurance policies.
SELECT 
    *
FROM
    policy
WHERE
    policy_status = 'Active';

-- Display customer name, vehicle registration number, and policy number.
SELECT 
    c.customer_name, v.registration_no, p.policy_number
FROM
    customer c
        JOIN
    vehicle v ON c.customer_id = v.customer_id
        JOIN
    policy p ON v.vehicle_id = p.vehicle_id;

-- Find customers whose premium amount is greater than ₹10,000.
SELECT 
    c.customer_name, p.premium_amount
FROM
    customer c
        JOIN
    policy p ON c.customer_id = p.customer_id
WHERE
    p.premium_amount > 10000;

-- Display all claims that have been approved.
SELECT 
    *
FROM
    claim_details
WHERE
    claim_status = 'Approved';

-- Find the total premium collected by the company.
SELECT 
    SUM(premium_amount) AS total_premium
FROM
    policy;

-- Count the number of policies issued by each insurance company.
SELECT 
    ic.company_name, COUNT(p.policy_id) AS total_policies
FROM
    insurance_company ic
        JOIN
    policy p ON ic.company_id = p.company_id
GROUP BY ic.company_name;

-- Display the payment details for all paid policies.
SELECT 
    *
FROM
    payment
WHERE
    payment_status = 'Paid';

-- Find the customer who has the highest premium amount.
SELECT 
    c.customer_name, p.premium_amount
FROM
    customer c
        JOIN
    policy p ON c.customer_id = p.customer_id
WHERE
    p.premium_amount = (SELECT 
            MAX(premium_amount)
        FROM
            policy);

-- Display all policies that expire before 2026-02-01.
SELECT 
    policy_number, expiry_date
FROM
    policy
WHERE
    expiry_date < '2026-02-01';

-- Find the number of claims based on their status.
SELECT 
    claim_status, COUNT(*) AS total_claims
FROM
    claim_details
GROUP BY claim_status;

-- Display agent name along with the policy assigned.
SELECT 
    a.agent_name, p.policy_number
FROM
    agent a
        JOIN
    policy_assignment pa ON a.agent_id = pa.agent_id
        JOIN
    policy p ON pa.policy_id = p.policy_id;

-- Display branch name and the number of policies assigned to each branch.
SELECT 
    b.branch_name, COUNT(pa.policy_id) AS total_policies
FROM
    branch b
        JOIN
    policy_assignment pa ON b.branch_id = pa.branch_id
GROUP BY b.branch_name;

-- Find customers who have made a claim.
SELECT DISTINCT
    c.customer_name
FROM
    customer c
        JOIN
    policy p ON c.customer_id = p.customer_id
        JOIN
    claim_details cd ON p.policy_id = cd.policy_id;

-- Display policies where the premium is above the average premium.
SELECT 
    policy_number, premium_amount
FROM
    policy
WHERE
    premium_amount > (SELECT 
            AVG(premium_amount)
        FROM
            policy);
            
-- Display complete policy information, including customer, vehicle, insurance company, and agent.
SELECT 
    c.customer_name,
    v.registration_no,
    ic.company_name,
    a.agent_name,
    p.policy_number,
    p.policy_type,
    p.premium_amount
FROM
    customer c
        JOIN
    vehicle v ON c.customer_id = v.customer_id
        JOIN
    policy p ON c.customer_id = p.customer_id
        JOIN
    insurance_company ic ON p.company_id = ic.company_id
        JOIN
    policy_assignment pa ON p.policy_id = pa.policy_id
        JOIN
    agent a ON pa.agent_id = a.agent_id;
    
    -- Display customers involved in major accidents.
SELECT 
    c.customer_name, a.accident_location, a.damage_level
FROM
    customer c
        JOIN
    vehicle v ON c.customer_id = v.customer_id
        JOIN
    accident a ON v.vehicle_id = a.vehicle_id
WHERE
    a.damage_level = 'Major';

-- Display garages where the service cost is greater than ₹5,000.
SELECT 
    g.garage_name, sr.service_type, sr.service_cost
FROM
    garage g
        JOIN
    service_record sr ON g.garage_id = sr.garage_id
WHERE
    sr.service_cost > 5000;

-- Display customer names whose documents are pending verification.
SELECT 
    c.customer_name, d.document_name, d.verification_status
FROM
    customer c
        JOIN
    document d ON c.customer_id = d.customer_id
WHERE
    d.verification_status = 'Pending';

-- Display all active policies
DELIMITER //
CREATE PROCEDURE GetActivePolicies()
BEGIN
    SELECT *
    FROM policy
    WHERE policy_status='Active';
END //
DELIMITER ;

CALL GetActivePolicies();

-- Display policy details by customer ID
DELIMITER //
CREATE PROCEDURE GetPolicyByCustomer(
IN p_customer_id INT
)
BEGIN
    SELECT
        c.customer_name,
        p.policy_number,
        p.policy_type,
        p.premium_amount
    FROM customer c
    JOIN policy p
    ON c.customer_id=p.customer_id
    WHERE c.customer_id=p_customer_id;
END //
DELIMITER ;

CALL GetPolicyByCustomer(5);

-- Display claim details by policy ID
DELIMITER //
CREATE PROCEDURE GetClaimDetails(
IN p_policy_id INT
)
BEGIN
    SELECT *
    FROM claim_details
    WHERE policy_id=p_policy_id;
END //
DELIMITER ;

CALL GetClaimDetails(8);

-- Display all verified documents.
DELIMITER //
CREATE PROCEDURE GetVerifiedDocuments()
BEGIN
    SELECT *
    FROM document
    WHERE verification_status='Verified';
END //
DELIMITER ;

CALL GetVerifiedDocuments();

-- Display all completed vehicle services.
DELIMITER //
CREATE PROCEDURE GetCompletedServices()
BEGIN
    SELECT *
    FROM service_record
    WHERE service_status='Completed';
END //
DELIMITER ;

CALL GetCompletedServices();

-- Display all completed policy renewals.
DELIMITER //
CREATE PROCEDURE GetCompletedRenewals()
BEGIN
    SELECT *
    FROM renewal
    WHERE renewal_status='Completed';
END //
DELIMITER ;

CALL GetCompletedRenewals();

-- Calculate GST (18%) on Premium
DELIMITER //
CREATE FUNCTION CalculateGST
(
premium DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
RETURN premium*0.18;
END //
DELIMITER ;

SELECT
policy_number,
premium_amount,
CalculateGST(premium_amount) AS GST
FROM policy;

-- Calculate Total Premium Including GST
DELIMITER //
CREATE FUNCTION TotalPremium
(
premium DECIMAL(10,2)
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
RETURN premium+(premium*0.18);
END //
DELIMITER ;

SELECT
policy_number,
premium_amount,
TotalPremium(premium_amount) AS Total_Amount
FROM policy;

-- Prevent negative premium amount
DELIMITER //
CREATE TRIGGER trg_check_premium
BEFORE INSERT
ON policy
FOR EACH ROW
BEGIN
IF NEW.premium_amount<0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Premium amount cannot be negative';
END IF;
END //
DELIMITER ;

INSERT INTO policy
(policy_number,customer_id,vehicle_id,company_id,policy_type,premium_amount,issue_date,start_date,expiry_date,policy_status)
VALUES
('POL2001',1,1,1,'Comprehensive',-5000,'2026-01-01','2026-01-01','2027-01-01','Active');

-- Automatically set payment status to Pending if amount is 0
DELIMITER //
CREATE TRIGGER trg_payment_status
BEFORE INSERT
ON payment
FOR EACH ROW
BEGIN
IF NEW.amount=0 THEN
SET NEW.payment_status='Pending';
END IF;
END //
DELIMITER ;

INSERT INTO payment
(policy_id,payment_date,payment_mode,amount,payment_status)
VALUES
(5,'2026-02-10','UPI',0,'Paid');

commit;

rollback;
