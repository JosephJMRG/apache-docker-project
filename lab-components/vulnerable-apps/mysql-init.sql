-- Script de inicialización para MySQL vulnerable
-- Proyecto: apache-docker-project
-- Archivo: lab-components/vulnerable-apps/mysql-init.sql

-- =================================================================
-- CONFIGURACIÓN INICIAL
-- =================================================================

-- Configurar MySQL para ser intencionalmente inseguro
SET sql_mode = '';
SET global sql_mode = '';

-- Crear base de datos principal
CREATE DATABASE IF NOT EXISTS vulnerable_db;
USE vulnerable_db;

-- =================================================================
-- CREAR USUARIOS VULNERABLES
-- =================================================================

-- Usuario administrador con contraseña débil
CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'admin123';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION;

-- Usuario con contraseña común
CREATE USER IF NOT EXISTS 'user'@'%' IDENTIFIED BY 'password';
GRANT SELECT, INSERT, UPDATE, DELETE ON vulnerable_db.* TO 'user'@'%';

-- Usuario con contraseña vacía
CREATE USER IF NOT EXISTS 'guest'@'%' IDENTIFIED BY '';
GRANT SELECT ON vulnerable_db.* TO 'guest'@'%';

-- Usuario de test con privilegios excesivos
CREATE USER IF NOT EXISTS 'testuser'@'%' IDENTIFIED BY 'testpass';
GRANT ALL PRIVILEGES ON vulnerable_db.* TO 'testuser'@'%';

-- Usuario de aplicación con privilegios innecesarios
CREATE USER IF NOT EXISTS 'webapp'@'%' IDENTIFIED BY 'webapp123';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER ON vulnerable_db.* TO 'webapp'@'%';

-- =================================================================
-- CREAR TABLAS CON DATOS SENSIBLES
-- =================================================================

-- Tabla de usuarios con contraseñas en texto plano
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100),
    full_name VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    ssn VARCHAR(11),
    credit_card VARCHAR(19),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de empleados con información sensible
CREATE TABLE employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    employee_id VARCHAR(10) UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    ssn VARCHAR(11),
    bank_account VARCHAR(20),
    emergency_contact VARCHAR(100),
    emergency_phone VARCHAR(20)
);

-- Tabla de clientes con datos financieros
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_code VARCHAR(20),
    company_name VARCHAR(100),
    contact_person VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20),
    address TEXT,
    tax_id VARCHAR(20),
    credit_limit DECIMAL(12,2),
    current_balance DECIMAL(12,2),
    payment_terms VARCHAR(50),
    bank_details TEXT
);

-- Tabla de transacciones financieras
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_id VARCHAR(50) UNIQUE,
    customer_id INT,
    amount DECIMAL(12,2),
    transaction_type ENUM('debit', 'credit', 'transfer'),
    description TEXT,
    account_from VARCHAR(20),
    account_to VARCHAR(20),
    transaction_date DATETIME,
    status ENUM('pending', 'completed', 'failed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Tabla de configuración con credenciales
CREATE TABLE system_config (
    id INT AUTO_INCREMENT PRIMARY KEY,
    config_key VARCHAR(100) UNIQUE,
    config_value TEXT,
    description TEXT,
    is_sensitive BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabla de logs de sistema
CREATE TABLE system_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_level ENUM('DEBUG', 'INFO', 'WARN', 'ERROR', 'CRITICAL'),
    message TEXT,
    user_id INT,
    ip_address VARCHAR(45),
    user_agent TEXT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_timestamp (timestamp),
    INDEX idx_user_id (user_id)
);

-- =================================================================
-- INSERTAR DATOS DE PRUEBA
-- =================================================================

-- Insertar usuarios vulnerables
INSERT INTO users (username, password, email, full_name, phone, address, ssn, credit_card) VALUES
('admin', 'admin123', 'admin@vulnerable.com', 'System Administrator', '555-0001', '123 Admin St, City, State 12345', '123-45-6789', '4111-1111-1111-1111'),
('johndoe', 'password123', 'john.doe@email.com', 'John Doe', '555-0002', '456 Main St, City, State 12345', '987-65-4321', '4222-2222-2222-2222'),
('janedoe', 'password', 'jane.doe@email.com', 'Jane Doe', '555-0003', '789 Oak Ave, City, State 12345', '456-78-9123', '4333-3333-3333-3333'),
('testuser', 'test', 'test@test.com', 'Test User', '555-0004', '321 Test Blvd, City, State 12345', '789-12-3456', '4444-4444-4444-4444'),
('guest', '', 'guest@vulnerable.com', 'Guest User', '555-0005', 'No Address', '000-00-0000', '0000-0000-0000-0000'),
('alice', '123456', 'alice@company.com', 'Alice Smith', '555-0006', '654 Pine St, City, State 12345', '234-56-7890', '4555-5555-5555-5555'),
('bob', 'qwerty', 'bob@company.com', 'Bob Johnson', '555-0007', '987 Elm St, City, State 12345', '345-67-8901', '4666-6666-6666-6666'),
('charlie', 'letmein', 'charlie@company.com', 'Charlie Brown', '555-0008', '147 Maple Ave, City, State 12345', '456-78-9012', '4777-7777-7777-7777');

-- Insertar empleados
INSERT INTO employees (employee_id, first_name, last_name, email, phone, department, position, salary, hire_date, ssn, bank_account, emergency_contact, emergency_phone) VALUES
('EMP001', 'John', 'Manager', 'j.manager@company.com', '555-1001', 'IT', 'IT Manager', 85000.00, '2020-01-15', '111-22-3333', '1234567890123456', 'Mary Manager', '555-1002'),
('EMP002', 'Sarah', 'Developer', 's.developer@company.com', '555-1003', 'IT', 'Senior Developer', 75000.00, '2020-03-20', '222-33-4444', '2345678901234567', 'Mike Developer', '555-1004'),
('EMP003', 'Mike', 'Admin', 'm.admin@company.com', '555-1005', 'HR', 'HR Administrator', 55000.00, '2019-11-10', '333-44-5555', '3456789012345678', 'Lisa Admin', '555-1006'),
('EMP004', 'Lisa', 'Accountant', 'l.accountant@company.com', '555-1007', 'Finance', 'Senior Accountant', 65000.00, '2021-02-28', '444-55-6666', '4567890123456789', 'John Accountant', '555-1008'),
('EMP005', 'David', 'Security', 'd.security@company.com', '555-1009', 'Security', 'Security Officer', 45000.00, '2021-06-15', '555-66-7777', '5678901234567890', 'Emma Security', '555-1010');

-- Insertar clientes
INSERT INTO customers (customer_code, company_name, contact_person, email, phone, address, tax_id, credit_limit, current_balance, payment_terms, bank_details) VALUES
('CUST001', 'Acme Corporation', 'John Acme', 'john@acme.com', '555-2001', '100 Business Blvd, City, State 12345', 'TAX123456789', 100000.00, 25000.00, 'Net 30', 'Bank: First National, Account: 1111-2222-3333-4444, Routing: 123456789'),
('CUST002', 'Global Industries', 'Sarah Global', 'sarah@global.com', '555-2002', '200 Industry Ave, City, State 12345', 'TAX987654321', 250000.00, 75000.00, 'Net 15', 'Bank: Second National, Account: 2222-3333-4444-5555, Routing: 987654321'),
('CUST003', 'Tech Solutions', 'Mike Tech', 'mike@techsolutions.com', '555-2003', '300 Tech Park, City, State 12345', 'TAX456789123', 150000.00, 50000.00, 'Net 30', 'Bank: Tech Bank, Account: 3333-4444-5555-6666, Routing: 456789123'),
('CUST004', 'Small Business', 'Lisa Small', 'lisa@smallbiz.com', '555-2004', '400 Small St, City, State 12345', 'TAX789123456', 50000.00, 10000.00, 'Net 45', 'Bank: Community Bank, Account: 4444-5555-6666-7777, Routing: 789123456');

-- Insertar transacciones
INSERT INTO transactions (transaction_id, customer_id, amount, transaction_type, description, account_from, account_to, transaction_date, status) VALUES
('TXN001', 1, 5000.00, 'debit', 'Payment for services rendered', '1111-2222-3333-4444', '9999-8888-7777-6666', '2023-01-15 10:30:00', 'completed'),
('TXN002', 2, 15000.00, 'credit', 'Refund for overpayment', '9999-8888-7777-6666', '2222-3333-4444-5555', '2023-01-20 14:45:00', 'completed'),
('TXN003', 3, 8000.00, 'transfer', 'Internal transfer', '3333-4444-5555-6666', '9999-8888-7777-6666', '2023-01-25 09:15:00', 'pending'),
('TXN004', 4, 2500.00, 'debit', 'Monthly service fee', '4444-5555-6666-7777', '9999-8888-7777-6666', '2023-02-01 16:20:00', 'completed'),
('TXN005', 1, 12000.00, 'credit', 'Large project payment', '9999-8888-7777-6666', '1111-2222-3333-4444', '2023-02-10 11:30:00', 'failed');

-- Insertar configuración del sistema (incluyendo credenciales)
INSERT INTO system_config (config_key, config_value, description, is_sensitive) VALUES
('db_host', 'localhost', 'Database host', FALSE),
('db_port', '3306', 'Database port', FALSE),
('db_user', 'root', 'Database username', TRUE),
('db_password', 'root123', 'Database password', TRUE),
('api_key', 'sk-1234567890abcdef', 'API key for external services', TRUE),
('secret_key', 'supersecretkey123', 'Application secret key', TRUE),
('email_host', 'smtp.gmail.com', 'Email SMTP host', FALSE),
('email_user', 'app@company.com', 'Email username', TRUE),
('email_password', 'emailpass123', 'Email password', TRUE),
('encryption_key', 'encryptionkey456', 'Data encryption key', TRUE),
('admin_email', 'admin@vulnerable.com', 'Administrator email', FALSE),
('backup_path', '/var/backups/mysql', 'Backup directory path', FALSE),
('log_level', 'DEBUG', 'Application log level', FALSE),
('session_timeout', '3600', 'Session timeout in seconds', FALSE),
('max_login_attempts', '0', 'Maximum login attempts (0 = unlimited)', FALSE);

-- Insertar logs del sistema
INSERT INTO system_logs (log_level, message, user_id, ip_address, user_agent, timestamp) VALUES
('INFO', 'User login successful', 1, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '2023-01-15 08:30:00'),
('WARN', 'Failed login attempt', NULL, '10.0.0.50', 'curl/7.68.0', '2023-01-15 08:35:00'),
('ERROR', 'Database connection failed', NULL, '192.168.1.100', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36', '2023-01-15 08:40:00'),
('INFO', 'Password changed successfully', 2, '192.168.1.101', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36', '2023-01-16 10:15:00'),
('CRITICAL', 'Potential SQL injection attempt detected', NULL, '10.0.0.75', 'sqlmap/1.6.12', '2023-01-16 14:22:00'),
('WARN', 'Multiple failed login attempts from same IP', NULL, '10.0.0.50', 'python-requests/2.28.1', '2023-01-16 15:30:00'),
('INFO', 'File uploaded successfully', 3, '192.168.1.102', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36', '2023-01-17 09:45:00'),
('ERROR', 'Unauthorized access attempt to admin panel', NULL, '10.0.0.100', 'Nikto/2.1.6', '2023-01-17 16:20:00');

-- =================================================================
-- CREAR PROCEDIMIENTOS ALMACENADOS VULNERABLES
-- =================================================================

DELIMITER //

-- Procedimiento vulnerable a SQL injection
CREATE PROCEDURE GetUserByName(IN user_name VARCHAR(50))
BEGIN
    SET @sql = CONCAT('SELECT * FROM users WHERE username = "', user_name, '"');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- Procedimiento para autenticación insegura
CREATE PROCEDURE AuthenticateUser(IN user_name VARCHAR(50), IN user_pass VARCHAR(255))
BEGIN
    SET @sql = CONCAT('SELECT id, username, email FROM users WHERE username = "', user_name, '" AND password = "', user_pass, '"');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

-- Procedimiento para búsqueda vulnerable
CREATE PROCEDURE SearchUsers(IN search_term VARCHAR(100))
BEGIN
    SET @sql = CONCAT('SELECT username, email, full_name FROM users WHERE username LIKE "%', search_term, '%" OR email LIKE "%', search_term, '%"');
    PREPARE stmt FROM @sql;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

DELIMITER ;

-- =================================================================
-- CREAR VISTAS CON INFORMACIÓN SENSIBLE
-- =================================================================

-- Vista que expone contraseñas
CREATE VIEW user_credentials AS
SELECT username, password, email FROM users;

-- Vista con información financiera
CREATE VIEW financial_data AS
SELECT c.company_name, c.credit_limit, c.current_balance, c.bank_details, 
       t.amount, t.transaction_type, t.account_from, t.account_to
FROM customers c
LEFT JOIN transactions t ON c.id = t.customer_id;

-- Vista con información de empleados
CREATE VIEW employee_sensitive_data AS
SELECT employee_id, CONCAT(first_name, ' ', last_name) AS full_name, 
       email, phone, department, salary, ssn, bank_account
FROM employees;

-- =================================================================
-- CONFIGURAR PERMISOS INSEGUROS
-- =================================================================

-- Otorgar permisos excesivos
GRANT ALL PRIVILEGES ON *.* TO 'webapp'@'%' WITH GRANT OPTION;
GRANT FILE ON *.* TO 'webapp'@'%';
GRANT PROCESS ON *.* TO 'webapp'@'%';
GRANT RELOAD ON *.* TO 'webapp'@'%';
GRANT SHUTDOWN ON *.* TO 'webapp'@'%';
GRANT SUPER ON *.* TO 'webapp'@'%';

-- Permitir acceso desde cualquier host
GRANT SELECT ON vulnerable_db.* TO 'guest'@'%';
GRANT SELECT ON vulnerable_db.user_credentials TO 'guest'@'%';

-- =================================================================
-- CONFIGURAR LOGGING INSEGURO
-- =================================================================

-- Habilitar logging general (incluye consultas con credenciales)
SET GLOBAL general_log = 'ON';
SET GLOBAL general_log_file = '/var/log/mysql/general.log';

-- Deshabilitar logging de consultas lentas para ocultar actividad
SET GLOBAL slow_query_log = 'OFF';

-- =================================================================
-- CREAR FUNCIONES VULNERABLES
-- =================================================================

DELIMITER //

-- Función que ejecuta comandos del sistema (si está habilitado)
CREATE FUNCTION ExecuteCommand(cmd VARCHAR(255))
RETURNS VARCHAR(1000)
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE result VARCHAR(1000);
    -- Esta función sería peligrosa si las UDF del sistema estuvieran habilitadas
    SET result = CONCAT('Command executed: ', cmd);
    RETURN result;
END //

DELIMITER ;

-- =================================================================
-- INSERTAR DATOS ADICIONALES PARA PRUEBAS
-- =================================================================

-- Insertar más usuarios con patrones de contraseñas comunes
INSERT INTO users (username, password, email, full_name) VALUES
('root', 'root', 'root@vulnerable.com', 'Root User'),
('administrator', 'administrator', 'administrator@vulnerable.com', 'Administrator'),
('demo', 'demo', 'demo@vulnerable.com', 'Demo User'),
('test1', '123456', 'test1@vulnerable.com', 'Test User 1'),
('test2', 'password123', 'test2@vulnerable.com', 'Test User 2'),
('user1', 'user1', 'user1@vulnerable.com', 'User 1'),
('user2', 'user2', 'user2@vulnerable.com', 'User 2'),
('sa', 'sa', 'sa@vulnerable.com', 'System Administrator'),
('oracle', 'oracle', 'oracle@vulnerable.com', 'Oracle User'),
('postgres', 'postgres', 'postgres@vulnerable.com', 'PostgreSQL User');

-- =================================================================
-- CONFIGURACIÓN FINAL
-- =================================================================

-- Aplicar todos los privilegios
FLUSH PRIVILEGES;

-- Mostrar advertencia en los logs
INSERT INTO system_logs (log_level, message, ip_address, timestamp) VALUES
('WARN', 'VULNERABLE DATABASE INITIALIZED - FOR TESTING ONLY!', '127.0.0.1', NOW());

-- Crear índices para mejorar el rendimiento de las consultas de prueba
CREATE INDEX idx_username ON users(username);
CREATE INDEX idx_email ON users(email);
CREATE INDEX idx_transaction_date ON transactions(transaction_date);
CREATE INDEX idx_customer_code ON customers(customer_code);

-- =================================================================
-- NOTAS IMPORTANTES
-- =================================================================

/*
ADVERTENCIA: Esta configuración de base de datos es EXTREMADAMENTE INSEGURA
Solo debe usarse en laboratorios de penetración testing aislados.

Vulnerabilidades incluidas:
1. Usuarios con contraseñas débiles o vacías
2. Procedimientos almacenados vulnerables a SQL injection
3. Permisos excesivos otorgados a usuarios
4. Información sensible almacenada en texto plano
5. Configuración de logging insegura
6. Vistas que exponen datos sensibles
7. Acceso permitido desde cualquier host
8. Funciones que podrían ejecutar comandos del sistema

Para conectarse a la base de datos:
- Host: localhost (o IP del contenedor)
- Puerto: 3306
- Usuarios de prueba: admin/admin123, user/password, guest/(sin contraseña)
- Base de datos: vulnerable_db

Comandos útiles para pruebas:
- SHOW DATABASES;
- USE vulnerable_db;
- SHOW TABLES;
- SELECT * FROM users;
- CALL GetUserByName('admin');
- SELECT * FROM user_credentials;
*/
