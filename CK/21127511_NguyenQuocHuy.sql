-- MSSV: 21127511
-- HOTEN: Nguyễn Quốc Huy
-- CATHI: 01
-- MALOP: 21CLC02
-- MADE: 02
-- DONG: 1
-- COT: 9

USE QLThuVienCKY
GO

-- 1. Cho danh sách các cuốn sách (isbn, mã sách, tên sách) được tất cả đọc giả mượn

SELECT CS.isbn, CS.masach, DS.tensach
FROM CuonSach CS
JOIN DauSach DS ON CS.isbn = DS.isbn
WHERE NOT EXISTS (
    SELECT DG.madg
    FROM DocGia DG
    WHERE NOT EXISTS (
        SELECT 1
        FROM CT_PhieuMuon CTM
        JOIN PhieuMuon PM ON CTM.mapm = PM.mapm
        WHERE DG.madg = PM.madg AND CS.isbn = CTM.isbn AND CS.masach = CTM.masach
    )
)

--SELECT * FROM PhieuMuon
--SELECT * from CT_PhieuMuon
--SELECT * FROM DocGia
--SELECT * FROM NhanVien_TV
--SELECT * FROM QuaTrinhLuongNV

-- 2. Cho biết (mã nhân viên, họ tên, số lần lập phiếu mượn) có số lần lập phiếu mượn nhiều
-- nhất trong 03/2023

SELECT TOP 1 NV.MaNV, NV.HoTenNV, COUNT(PM.mapm) as SoLanLapPhieuMuon
FROM NhanVien_TV NV
JOIN PhieuMuon PM ON NV.MaNV = PM.NVienLapPM
WHERE PM.ngaymuon BETWEEN '2023-03-01' AND '2023-03-31'
GROUP BY NV.MaNV, NV.HoTenNV
ORDER BY SoLanLapPhieuMuon DESC;


-- 3. Viết stored procedure, function tương ứng thực hiện cập nhật lương cho nhân viên sao cho
-- thoả các quy định sau:
-- - Input: mã nhân viên
-- - Output: cập nhật lương thành công
-- - Các bước:
-- o Kiểm tra dữ liệu mã nhân viên tồn tại hợp lệ
-- o Kiểm tra ngày hưởng lương sau cùng nhất của nhân viên đến hiện tại đã đủ 3 năm
-- o Nếu vi phạm các quy định trên thì báo lỗi và thoát.
-- o Ngược lại:
-- ▪ Tính Lương hiện tại của 1 giảng viên đó theo công thức: LuongHienTai =
-- (Hệ số lương cũ + 0.3) * Mức lương cơ bản + (phụ cấp cũ + 300.000)
-- ▪ Kiểm tra lương mới > LuongHienTai
-- ▪ Nếu thoả: cập nhật LuongHienTai cho giảng viên
-- ▪ Thêm một dòng lưu lại Hệ số lương, mức lương cơ bản, phụ cấp, ngày hưởng
-- lương (là ngày hiện tại) vào quá trình lương của nhân viên này.
-- Sinh viên tự cho dữ liệu mẫu để gọi thực thi stored/function tương ứng
GO
CREATE PROCEDURE UpdateSalary @MaNV varchar(5)
AS
BEGIN
    DECLARE @NgayHienTai datetime = GETDATE();
    DECLARE @LuongHienTai money;
    DECLARE @HeSoLuong decimal(3, 2);
    DECLARE @MucLuongCoBan money;
    DECLARE @PhuCap money;

    -- Kiểm tra mã nhân viên tồn tại hợp lệ
    IF NOT EXISTS (SELECT 1 FROM NhanVien_TV WHERE MaNV = @MaNV)
    BEGIN
        RAISERROR('Mã nhân viên không tồn tại.', 15, 1);
        RETURN;
    END;

    -- Lấy thông tin lương hiện tại của nhân viên để tính
    SELECT TOP 1 @HeSoLuong = HeSoLuong, @MucLuongCoBan = MucLuongCoBan, @PhuCap = PhuCap
    FROM QuaTrinhLuongNV
    WHERE MaNV = @MaNV
    ORDER BY NgayHuongLuong DESC;

    -- Kiểm tra đủ 3 năm từ ngày hưởng lương sau cùng
    IF DATEDIFF(YEAR, @NgayHienTai, (SELECT TOP 1 NgayHuongLuong FROM QuaTrinhLuongNV WHERE MaNV = @MaNV ORDER BY NgayHuongLuong DESC)) > -3
    BEGIN
        RAISERROR(N'Chưa đủ 3 năm kể từ ngày hưởng lương sau cùng.', 15, 1);
        RETURN;
    END;

    -- Tính lương mới
    SET @LuongHienTai = (@HeSoLuong + 0.3) * @MucLuongCoBan + (@PhuCap + 300000);

    -- Kiểm tra lương mới > lương hiện tại
    IF @LuongHienTai <= (SELECT TOP 1 LuongHienTai FROM NhanVien_TV WHERE MaNV = @MaNV)
    BEGIN
        RAISERROR(N'Lương mới không lớn hơn lương hiện tại.', 15, 1);
        RETURN;
    END;

    -- Cập nhật lương cho nhân viên
    UPDATE NhanVien_TV
    SET LuongHienTai = @LuongHienTai
    WHERE MaNV = @MaNV;

    -- Thêm dòng mới vào QuaTrinhLuongNV
    INSERT INTO QuaTrinhLuongNV (MaNV, NgayHuongLuong, HeSoLuong, MucLuongCoBan, PhuCap)
    VALUES (@MaNV, @NgayHienTai, @HeSoLuong, @MucLuongCoBan, @PhuCap);

    PRINT (N'Cập nhật lương thành công.');
END;

go
DECLARE @MANV varchar(5)
set @MANV = '003'
exec UpdateSalary @MANV
select * FROM QuaTrinhLuongNV

