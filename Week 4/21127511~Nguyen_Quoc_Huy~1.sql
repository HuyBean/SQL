-- MSSV: 21127511
-- MALOP: 21CLC02

USE master
GO 

PRINT DB_ID('QLDOI')

IF DB_ID('QLDOI') IS NOT NULL 
    DROP database QLDOI
GO

CREATE database QLDOI
GO 

USE QLDOI
GO 
CREATE TABLE DOI
(
    IDDoi varchar(5),
    TenDoi nvarchar(30),
    DoiTruong varchar(5),
    SoLuong int

    Constraint PK_DOI
    Primary key (IDDoi)

)

CREATE TABLE THANHVIEN
(
    IDThanhVien varchar(5),
    HoTen nvarchar(30),
    SoCMND varchar(10),
    DiaChi nvarchar(30),
    NgaySinh datetime

    Constraint PK_THANHVIEN
    Primary key (IDThanhVien)

)

CREATE TABLE BOTRI
(
    IDDoi varchar(5),
    IDThanhVien varchar(5),
    DiaChi nvarchar(30),
    NhiemVu nvarchar(50),
    QuanLi varchar(5)

    Constraint PK_BOTRI
    Primary key (IDDoi, IDThanhVien)
)

ALTER TABLE DOI
ADD 
    Constraint FK_DOI_BOTRI
    Foreign key (IDDoi, DoiTruong)
    References BOTRI (IDDoi, IDThanhVien)

ALTER TABLE BOTRI 
ADD 
    Constraint FK_BOTRI_DOI
    Foreign key (IDDoi)
    References DOI,

    Constraint FK_BOTRI_BOTRI
    Foreign key (IDDoi, QuanLi)
    References BOTRI (IDDoi, IDThanhVien), 

    Constraint FK_BOTRI_THANHVIEN
    Foreign key (IDThanhVien)
    References THANHVIEN


INSERT THANHVIEN(IDThanhVien, HoTen, SoCMND, DiaChi, NgaySinh)
VALUES ('1', N'Nguyễn Quan Tùng', '240674018', N'TPHCM', '2000-1-30'),
('2', N'Lưu Phi Nam', '240674027', N'Quãng Nam', '2001-3-12'),
('3', N'Lê Quang Bảo', '240674063', N'Quãng Ngãi', '1999-5-14'),
('4', N'Hà Ngọc Thúy', '240674504', N'TPHCM', '1998-7-26'),
('5', N'Trương Thị Minh', '240674405', N'Hà Nội',NULL),
('6', N'Ngô Thị Thủy', '240674306', NULL, '2000-9-18')

INSERT DOI(IDDoi, TenDoi)
VALUES ('2', N'Đội Tân Phú'),
('7', N'Đội Bình Phú')

INSERT BOTRI(IDDoi, IDThanhVien, DiaChi, NhiemVu, QuanLi)
VALUES ('2', '2', N'123 Vườn Lài Tân Phú', N'Trực khu vục vòng xoay 1', '1'),
('2', '1', N'45 Phú Thọ Hòa Tân Phú', N'Theo dõi hoạt động', '1'),
('7', '3', N'11 Chợ Lớn Bình Phú', NULL, '2'),
('7', '4', N'2 Bis Nguyễn Văn Cừ Q5', NULL, '3'),
('7', '2', N'1 Bis Trần Đình Xu Q1', NULL, NULL)

UPDATE DOI
SET DoiTruong = '1'
WHERE IDDoi = '2'

UPDATE DOI
SET DoiTruong = '2'
WHERE IDDoi = '7'

-- Q4: CHO BIẾT TÊN ĐÔI, TÊN ĐỘI TRƯỞNG TẠI ĐỊA CHỈ TÂN PHÚ

SELECT DISTINCT D.TenDoi AS 'TÊN ĐỘI', TV.HoTen AS 'ĐỘI TRƯỞNG'
FROM BOTRI BT, DOI D, THANHVIEN TV 
WHERE D.IDDoi = BT.IDDoi AND BT.DiaChi LIKE '% Tân Phú' AND D.DoiTruong = TV.IDThanhVien

-- Q5: CHO BIẾT TÊN QUẢN LÝ VÀ SỐ LƯỢNG THÀNH VIÊN CÓ CUNG CẤP NGÀY SINH DO NGƯỜI NÀY QUẢN LÝ

SELECT TV1.HOTEN, COUNT(TV2.IDThanhVien) SOLUONG_NGAYSINH
FROM THANHVIEN TV1
JOIN BOTRI BT ON TV1.IDThanhVien = BT.QuanLi -- Lấy tên quản lý
LEFT JOIN THANHVIEN TV2 ON TV2.IDThanhVien = BT.IDThanhVien AND TV2.NgaySinh IS NOT NULL	-- Lấy ngày sinh
GROUP BY BT.QuanLi, TV1.HOTEN
