-- create_smanager.sql

USE master;
GO

-- 1. Tạo Login (Tài khoản truy cập Server)
-- Password ở đây đặt là 'Password123!', bạn có thể đổi nhưng nhớ cập nhật
IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name = 'sManager')
BEGIN
    CREATE LOGIN sManager WITH PASSWORD = 'Password123!', CHECK_POLICY = OFF;
END
GO

-- 2. Tạo User (Người dùng trong Database cụ thể)
USE MyDatabase;
GO

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'sManager')
BEGIN
    CREATE USER sManager FOR LOGIN sManager;
END
GO

-- 3. Cấp quyền (Grant Rights)
-- Thầy yêu cầu "Grant all access rights", quyền db_owner là quyền cao nhất trong DB
ALTER ROLE db_owner ADD MEMBER sManager;
GO

---------------------------------------------------------------------
-- 4. BỔ SUNG QUAN TRỌNG CHO ỨNG DỤNG WEB
-- Để đăng nhập được trên Web App bằng tài khoản này, ta cần insert nó vào bảng User
-- để hệ thống Backend nhận diện được email.
---------------------------------------------------------------------
IF NOT EXISTS (SELECT 1 FROM [User] WHERE email = 'smanager@example.com')
BEGIN
    -- Insert user sManager vào bảng User để App có thể login
    INSERT INTO [User] (email, fname, mname, lname, phone, registration_date)
    VALUES ('smanager@example.com', 'System', NULL, 'Manager', '0900000000', GETDATE());
END
GO