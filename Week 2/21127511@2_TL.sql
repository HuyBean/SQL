--mssv: 21127511
--malop: 21CLC02


-- switch db to 'master'
use master
go

--check if DB is exist
PRINT DB_ID('QLDTAI')
--b1: tạo csdl
-- KIỂM TRA DB QLDTAI ĐÃ TỒN TẠI CHƯA
IF DB_ID('QLDTAI') IS NOT NULL 
	DROP database QLDTAI
go 
-- create database
create database QLDTAI
go 
-- switch DB
USE QLDTAI
go 
create table GIAOVIEN
(
    MAGV char(5),
    HOTEN nvarchar(40), 
    LUONG float, 
    PHAI nvarchar(10), 
    NGSINH datetime, 
    DIACHI nvarchar(100), 
    GVQLCM char(5), 
    MABM nchar(5)

	Constraint PK_GV
	Primary key (MAGV),
	Constraint C_Giaovien_Phai
	Check (PHAI in (N'Nam', N'Nữ'))
)

create table BOMON (
    MABM nchar(5),
    TENBM nvarchar(40),
    PHONG char(5),
    DIENTHOAI char(12), 
    TRUONGBM char(5), 
    MAKHOA char(4),
    NGAYNHANCHUC datetime,

	Constraint PK_BOMON
	Primary key (MABM)
)
create table KHOA (
    MAKHOA char(4), 
    TENKHOA nvarchar(40), 
    NAMTL int, 
    PHONG char(5), 
    DIENTHOAI char(12),
    TRUONGKHOA char(5), 
    NGAYNHANCHUC datetime,

	Constraint PK_KHOA
	Primary key (MAKHOA)
)


--B2: TẠO KHÓA NGOẠI
ALter table GIAOVIEN
ADD
	Constraint FK_GV_GV
	Foreign key (GVQLCM)
	References GIAOVIEN,

	Constraint FK_GV_BM
	Foreign key (MABM)
	References BOMON

Alter table BOMON
ADD
	Constraint FK_BM_GV
	Foreign key (TRUONGBM)
	References GIAOVIEN,

	Constraint FK_BM_KHOA
	Foreign key (MAKHOA)
	References KHOA

Alter table KHOA
ADD
	Constraint FK_KHOA_GV
	Foreign key (TRUONGKHOA)
	References GIAOVIEN



-- B4: NHẬP LIỆU
-- THỨ TỰ NHẬP LIỆU: KHOA (TRƯỞNG KHOA = NULL) -> BOMON (TRUONGBM = NULL) -> GV
INSERT KHOA (MAKHOA, TENKHOA, NAMTL, PHONG, DIENTHOAI, NGAYNHANCHUC)
VALUES ('CNTT', N'Công nghệ thông tin', 1995, 'B11', '0838123456', '02-20-2002'), 
('HH', N'Hóa học', 1980, 'B41', '0838456456', '10-15-2001'),
('SH', N'Sinh học', 1980, 'B31', '0838454545','10-11-2000'),
('VL', N'Vật lý', 1976, 'B21','0838223223', '09-18-2003')

--Select* from KHOA

INSERT BOMON
VALUES ('CNTT', N'Công nghệ tri thức', 'B15', '0838126126', NULL, 'CNTT', NULL),
('HHC', N'Hóa hữu cơ', 'B44', '838222222', NULL, 'HH', NULL),
('HL', N'Hóa lý', 'B42', '0838878787', NULL, 'HH', NULL),
('HPT', N'Hóa phân tích', 'B43', '0838777777', NULL, 'HH', '10-25-2007'),
('HTTT', N'Hệ thống thông tin', 'B13', '0838125125', NULL, 'CNTT', '09-20-2004'),
('MMT', N'Mạng máy tính', 'B16', '0838676767', NULL, 'CNTT', '05-15-2005'),
('SH', N'Sinh hóa', 'B33', '0838898989', NULL, 'SH', NULL),
('VLĐT', N'Vật lý điện tử', 'B23', '0838234234', NULL, 'VL', NULL),
('VLƯD', N'Vật lý ứng dụng', 'B24', '0838454545', NULL, 'VL', '02-18-2006'),
('VS', N'Vi sinh', 'B32', '0838909090', NULL, 'SH', '01-01-2007')

--Select* from BOMON

INSERT GIAOVIEN
VALUES
('003',N'Nguyễn Ngọc Ánh', 2200, N'Nữ', '05-11-1975', N'12/2 Võ Văn Ngân Thủ Đức, TP HCM', '002','HTTT'),
('006',N'Trần Bạch Tuyết', 1500, N'Nữ', '05-20-1980', N'127 Hùng Vương, TP Mỹ Tho','004',N'VS'),
('008',N'Trần Trung Hiếu', 1800, N'Nam', '08-06-1977', N'22/11 Lý Thường Kiệt, TP Mỹ Tho','007','HPT'),
('009',N'Trần Hoàng Nam', 2000, N'Nam', '11-22-1975', N'234	Trấn Não, An Phú, TP HCM','001','MMT'),
('010',N'Phạm Nam Thanh', 1500, N'Nam', '12-12-1980', N'221	Hùng Vương, Q.5, TP HCM','007','HPT'),
('001', N'Nguyễn Hoài An', 2000, N'Nam', '02-15-1973', N'25/3 Lạc Long Quân, Q.10, TP HCM', NULL, 'MMT'),
('002',N'Trần Hà Hương', 2500, N'Nữ', '06-20-1960', N'125	Trần Hưng Đạo, Q.1, TP HCM', NULL, 'HTTT'),
('004',N'Trương Nam Sơn', 2300, N'Nam', '06-20-1959', N'215	Lý Thường Kiệt, TP BIÊN HÒA',NULL, 'VS'),
('005',N'Lý Hoàng Hà', 2500, N'Nam', '10-23-1954', N'22/5 Nguyễn Xí, Q.Bình Thạnh, TP HCM',NULL, 'VLĐT'),
('007',N'Nguyễn An Trung', 2100, N'Nam', '06-05-1976', N'234 3/2, TP Biên Hòa',NULL, 'HPT')

--Select* from GIAOVIEN

UPDATE KHOA
SET TRUONGKHOA = '002'
WHERE MAKHOA = 'CNTT'

UPDATE KHOA
SET TRUONGKHOA = '007'
WHERE MAKHOA = 'HH'

UPDATE KHOA
SET TRUONGKHOA = '004'
WHERE MAKHOA = 'SH'

UPDATE KHOA
SET TRUONGKHOA = '005'
WHERE MAKHOA = 'VL'

UPDATE BOMON
SET TRUONGBM = '007'
WHERE MABM = 'HPT'

UPDATE BOMON
SET TRUONGBM = '002'
WHERE MABM = 'HTTT'

UPDATE BOMON
SET TRUONGBM = '001'
WHERE MABM = 'MMT'

UPDATE BOMON
SET TRUONGBM = '005'
WHERE MABM = 'VLƯD'

UPDATE BOMON
SET TRUONGBM = '004'
WHERE MABM = 'VS'


Select * from BOMON
Select * from KHOA
Select * from GIAOVIEN