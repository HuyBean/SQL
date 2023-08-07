-- MSSV: 21127511
-- MALOP: 21CLC02

USE master
GO 

PRINT DB_ID('QLLICH')

IF DB_ID('QLLICH') IS NOT NULL 
    DROP database QLLICH
GO

CREATE database QLLICH
GO 

USE QLLICH
GO 
CREATE TABLE LOPHOC
(
    IDLopHoc varchar(5),
    NamBD int,
    ChuNhiem varchar(5),
    IDKhoa varchar(5),
    SoLuong int

    Constraint PK_LOPHOC
    Primary key (IDLopHoc)

)

CREATE TABLE GIAOVIEN
(
    IDKhoa varchar(5),
    IDMaGV varchar(5),
    HoTen nvarchar(30),
    SoCMND nvarchar(30),
    NgaySinh datetime,
    IDQuanli varchar(5)

    Constraint PK_GIAOVIEN
    Primary key (IDKhoa, IDMaGV)

)

CREATE TABLE LICHDAY
(
    IDLop varchar(5),
    IDThuTiet varchar(10),
    IDPhongHoc varchar(5),
    GiaoVien varchar(5),
    IDKhoa varchar(5),
    ThoiLuong int,
    ThietBi nvarchar(30)

    Constraint PK_LICHDAY
    Primary key (IDLop, IDThuTiet, IDPhongHoc)
)

ALTER TABLE LOPHOC
ADD 
    Constraint FK_LOPHOC_GIAOVIEN
    Foreign key (IDKhoa, ChuNhiem)
    References GIAOVIEN

ALTER TABLE LICHDAY
ADD 
    Constraint FK_LICHDAY_LOPHOC
    Foreign key (IDLop)
    References LOPHOC,

    Constraint FK_LICHDAY_GIAOVIEN
    Foreign key (IDKhoa, GiaoVien)
    References GIAOVIEN

ALTER TABLE GIAOVIEN
ADD 
    Constraint FK_GIAOVIEN_GIAOVIEN
    Foreign key (IDKhoa, IDQuanli)
    References GIAOVIEN

INSERT GIAOVIEN(IDKhoa, IDMaGV, HoTen, SoCMND, NgaySinh)
VALUES ('1', '1716', N'Nguyễn Quan Tùng', '240674018', '1988-2-1'), 
('2', '0357', N'Lưu Phi Nam', '240674027', '1980-7-20'), 
('2', '1716', N'Lê Quang Bảo', '240674063', NULL), 
('1', '0753', N'Hà Ngọc Thủy', '240674504', '1990-5-2'), 
('1', '0357', N'Trương Thị Minh', '240674405', NULL), 
('1', '1718', N'Ngô Thị Thủy', '240674306', NULL)

UPDATE GIAOVIEN
SET IDQuanli = '0753'
WHERE IDMaGV = '1716' AND IDKhoa = '1'

UPDATE GIAOVIEN
SET IDQuanli = '1716'
WHERE IDMaGV = '0357' AND IDKhoa = '2'

UPDATE GIAOVIEN
SET IDQuanli = '0753'
WHERE IDMaGV = '0357' AND IDKhoa = '1'

UPDATE GIAOVIEN
SET IDQuanli = '0357'
WHERE IDMaGV = '1718' AND IDKhoa = '1'

INSERT LOPHOC
VALUES ('L01', 2015, '0357', '2', NULL),
('L02', 2013, '1716', '1', NULL)

INSERT LICHDAY
VALUES ('L01', 'T2(1-6)', '2', '1718', '1', 10, NULL),
('L02', 'T2(7-12)', '1', '0753', '1', 30, NULL),
('L01', 'T4(4-6)', '5', '0357', '2', 25, NULL)

SELECT * FROM GIAOVIEN
SELECT * FROM LICHDAY
SELECT * FROM LOPHOC

-- Q4: CHO BIẾT GIÁO VIÊN CHỦ NHIỆM, TUỔI CỦA LỚP CÓ LỊCH DẠY TIẾT 6

SELECT DISTINCT GV.IDKhoa AS N'KHOA', HoTen AS N'TÊN GVCN', YEAR(GETDATE()) - YEAR(GV.NgaySinh) AS N'TUỔI', LH.IDLopHoc AS N'LỚP HỌC CÓ LỊCH DẠY TIẾT 6', LD.IDThuTiet AS N'THỨ TIẾT'
FROM GIAOVIEN GV, LOPHOC LH, LICHDAY LD
WHERE GV.IDMaGV = LH.ChuNhiem AND LD.IDLop = LH.IDLopHoc AND LD.IDThuTiet LIKE '%6%' AND LD.IDKhoa = GV.IDKhoa

-- Q5: CHO BIẾT TÊN GIÁO VIÊN VÀ TÊN NGƯỜI QUẢN LÝ CHƯA CUNG CẤP NGÀY SINH

SELECT 
