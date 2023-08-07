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
create table GV_DT (
    MAGV char(5), 
    DIENTHOAI char(12),

	Constraint PK_GV_DT
	Primary key (MAGV, DIENTHOAI)
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

create table DETAI (
    MADT char(3), 
    TENDT nvarchar(100), 
    CAPQL nvarchar(40), 
    KINHPHI float, 
    NGAYBD datetime, 
    NGAYKT datetime,
    MACD nchar(4),
    GVCNDT char(5),

	Constraint PK_DETAI
	Primary key (MADT)
)

create table CHUDE( 
    MACD nchar(4), 
    TENCD nvarchar(50),

	Constraint PK_CHUDE
	Primary key (MACD)
)
create table CONGVIEC( 
    MADT char(3), 
    SOTT int, 
    TENCV nvarchar(40), 
    NGAYBD datetime, 
    NGAYKT datetime,

	Constraint PK_CONGVIEC
	Primary key (MADT, SOTT)
)

create table THAMGIADT (
    MAGV char(5), 
    MADT char(3), 
    STT int, 
    PHUCAP float , 
    KETQUA nvarchar(40),

	Constraint PK_THAMGIADT
	Primary key (MAGV, MADT, STT)
)

create table NGUOITHAN (
    MAGV char(5), 
    TEN nvarchar(20), 
    NGSINH datetime, 
    PHAI nchar(3),

	Constraint PK_NGUOITHAN
	Primary key (MAGV, TEN)
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

ALter table THAMGIADT
ADD
	Constraint FK_THAMGIADT_GV
	Foreign key (MAGV)
	References GIAOVIEN,

	Constraint FK_THAMGIADT_CONGVIEC
	Foreign key (MADT, STT)
	References CONGVIEC

Alter table CONGVIEC
ADD
	Constraint FK_CONGVIEC_DETAI
	Foreign key (MADT)
	References DETAI

Alter table DETAI
ADD
	Constraint FK_DETAI_GIAOVIEN
	Foreign key (GVCNDT)
	References GIAOVIEN,

	Constraint FK_DETAI_CHUDE
	Foreign key (MACD)
	References CHUDE

Alter table NGUOITHAN
ADD
	Constraint FK_NGUOITHAN_GIAOVIEN
	Foreign key (MAGV)
	References GIAOVIEN,

	Constraint C_NGUOITHAN_PHAI
	Check (PHAI in (N'Nam', N'Nữ'))

ALter table GV_DT
ADD
	Constraint FK_GVDT_GIAOVIEN
	Foreign key (MAGV)
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


--- Select * from BOMON
--- Select * from KHOA
--- Select * from GIAOVIEN

INSERT GV_DT
VALUES ('001', '0838912112'),
('001', '0903123123'),
('002', '0913454545'),
('003', '0838121212'),
('003', '0903656565'),
('003', '0937125125'),
('006', '0937666666'),
('008', '0653717171'),
('008', '0913232323')

--- Select * from GV_DT

INSERT CHUDE
VALUES ('NCPT', N'Ngiên cứu phát triển'),
('QLGD', N'Quản lý giáo dục'),
('ƯDCN', N'Ứng dụng công nghệ')

--- Select * from CHUDE

INSERT NGUOITHAN
VALUES ('001', N'Hùng', '01-14-1990', N'Nam'),
('001', N'Thủy', '12-08-1994', N'Nữ'),
('003', N'Hà', '09-03-1998', N'Nữ'),
('003', N'Thu', '09-03-1998', N'Nữ'),
('007', N'Mai', '03-26-2003', N'Nữ'),
('007', N'Vy', '02-14-2000', N'Nữ'),
('008', N'Nam', '05-06-1991', N'Nam'),
('009', N'An', '08-19-1996', N'Nam'),
('010', N'Nguyệt', '01-14-2006', N'Nữ')

--- Select * from NGUOITHAN

INSERT DETAI
VALUES ('001', N'HTTT quản lý các trường ĐH', N'ĐHQG', 20, '10-20-2007','10-20-2008', 'QLGD', '002'),
('002', N'HTTT quản lý giáo vụ cho một Khoa', N'Trường', 20, '10-12-2000','10-12-2001', 'QLGD', '002'),
('003', N'Nghiên cứu chế tạo sợi Nanô Platin', N'ĐHQG', 300, '05-15-2008','05-15-2010', 'NCPT', '005'),
('004', N'Tạo vật liệu sinh học bằng màng ối người', N'Nhà nước', 100, '01-01-2007', '12-31-2009', 'NCPT', '004'),
('005', N'Ứng dụng hóa học xanh', N'Trường', 200, '10-10-2003', '12-10-2004', 'ƯDCN', '007'),
('006', N'Nghiên cứu tế bào gốc', N'Nhà nước', 4000, '10-20-2006','10-20-2009', 'NCPT', '004'),
('007', N'HTTT quản lý thư viện ở các trường ĐH', N'Trường', 20, '05-10-2009', '05-10-2010', 'QLGD','001')

--- Select * from DETAI

INSERT CONGVIEC
VALUES ('001', 1, N'Khởi tạo và Lập kế hoạch', '10-20-2007','12-20-2008'),
('001', 2, N'Xác định yêu cầu', '12-21-2008', '03-21-2008'),
('001', 3, N'Phân tích hệ thống', '03-22-2008', '05-22-2008'),
('001', 4, N'Thiết kế hệ thống', '05-23-2008', '06-23-2008'),   
('001', 5, N'Cài đặt thử nghiệm', '06-24-2008', '10-20-2008'),
('002', 1, N'Khởi tạo và Lập kế hoạch', '05-10-2009', '07-10-2009'),
('002', 2, N'Xác định yêu cầu', '07-11-2009', '10-11-2009'),
('002', 3, N'Phân tích hệ thống', '10-12-2009', '12-20-2009'),
('002', 4, N'Thiết kế hệ thống', '12-21-2009', '03-22-2010'),
('002', 5, N'Cài đặt thử nghiệm', '03-23-2010', '05-10-2010'),
('006', 1, N'Lấy mẫu', '10-20-2006', '02-20-2007'),
('006', 2, N'Nuôi cấy', '02-21-2007', '08-21-2008')

--- Select * from CONGVIEC

INSERT THAMGIADT
VALUES 
('001', '002', 1, 0, NULL),	
('001', '002', 2, 2, NULL),
('002', '001', 4, 2, N'Đạt'),
('003', '001', 1, 1, N'Đạt'),
('003', '001', 2, 0, N'Đạt'),
('003', '001', 4, 1, N'Đạt'),
('003', '002', 2, 0, NULL),
('004', '006', 1, 0, N'Đạt'),
('004', '006', 2, 1, N'Đạt'),
('006', '006', 2, 1.5, N'Đạt'),
('009', '002', 3, 0.5, NULL),
('009', '002', 4, 1.5, NULL)

--- Select * from THAMGIADT