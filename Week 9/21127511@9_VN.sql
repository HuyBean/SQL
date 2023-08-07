-- MSSV: 21127511
-- MALOP: 21CLC02

select* from THAMGIADT

--1
GO
CREATE PROCEDURE PHANCONG @MAGV VARCHAR(5), @MADT VARCHAR(3), @STT INT
AS
    IF (SELECT COUNT(DISTINCT STT)
        FROM GIAOVIEN GV JOIN THAMGIADT TG ON GV.MAGV = TG.MAGV
        WHERE GV.MAGV = @MAGV AND TG.MADT = @MADT
        GROUP BY GV.MAGV, TG.MADT) >= 3
        BEGIN
            PRINT N'Không thể thêm phân công: Vượt quá số lượng cho phép!!'
            RETURN;
        END
    
    INSERT INTO THAMGIADT (MAGV, MADT, STT) VALUES
    (@MAGV, @MADT, @STT);

-- 2
GO
CREATE PROC CAPNHAT_NGAYKT @MADT char(3), @NGAYKT DATE
AS
    BEGIN
        DECLARE @QL nvarchar(40), @DIFF INT;
        SET @QL = (SELECT CAPQL FROM DETAI WHERE MADT = @MADT);
        SELECT @DIFF = DATEDIFF(MONTH, NGAYBD, @NGAYKT) FROM DETAI; 
        IF @QL = N'Trường' AND @DIFF >= 3 AND @DIFF <= 6
        BEGIN
            UPDATE DETAI
            SET NGAYKT = @NGAYKT
            WHERE @MADT = MADT
        END
        IF @QL = N'ĐHQG' AND @DIFF >=6 AND @DIFF <= 9
        BEGIN
            UPDATE DETAI
            SET NGAYKT = @NGAYKT
            WHERE @MADT = MADT
        END
        IF @QL = N'Nhà nước' AND @DIFF >= 12 AND @DIFF <= 24
        BEGIN
            UPDATE DETAI
            SET NGAYKT = @NGAYKT
            WHERE @MADT = MADT
        END
    END
-- 3
GO
CREATE PROCEDURE UPDATE_GVCN @MaGV char(5), @MaGVCN char(5)
AS
BEGIN
	declare @BM char(5)
	set @BM = (SELECT GV.MABM from GIAOVIEN gv where gv.MAGV = @MaGV)
	IF (@BM like (SELECT GV.MABM from GIAOVIEN gv where gv.MAGV = @MaGVCN))
	BEGIN 
		UPDATE GIAOVIEN 
		SET GVQLCM = @MaGVCN
	END
END
-- 4
GO
CREATE PROCEDURE UPDATE_TRUONGKHOA @TRUONGKHOA CHAR(5), @MAKHOA CHAR(5)
AS
	DECLARE @MKTK CHAR(5)
	SET @MKTK = (SELECT MAKHOA FROM KHOA WHERE TRUONGKHOA = @TRUONGKHOA)
	IF (@MAKHOA != @MKTK)
	BEGIN
		RAISERROR('Lỗi', 15, 1)
		return 
	END
	ELSE
		if @TRUONGKHOA NOT IN (SELECT BM.TRUONGBM FROM BOMON BM WHERE BM.TRUONGBM = @TRUONGKHOA)
		and @TRUONGKHOA NOT IN (SELECT GV.GVQLCM FROM GIAOVIEN GV WHERE GV.GVQLCM = @TRUONGKHOA)
		BEGIN
			RAISERROR('LỖI', 15, 1)
			RETURN
		END
		ELSE 
		BEGIN
			UPDATE KHOA
			SET TRUONGKHOA = @TRUONGKHOA WHERE MAKHOA = @MAKHOA
		END
-- 5
go
CREATE PROCEDURE sp_PhanCongNhanSu @MaGV nvarchar(4), @MaDT nvarchar(4)
AS
BEGIN
    DECLARE @SoNS int = 0;
    SELECT @SoNS = COUNT(*)
    FROM THAMGIADT TG
    WHERE TG.MADT = @MaDT

    IF('Trường' = (SELECT DT.CAPQL 
            FROM DETAI DT WHERE DT.MADT = @MaDT) 
            AND @SoNS <= 2)
    BEGIN
        SET @SoNS = @SoNS + 1;
        INSERT THAMGIADT
        VALUES (@MaGV, @MaDT, @SoNS, 0.0, NULL);
    END
    IF('ĐHQG' = (SELECT DT.CAPQL 
            FROM DETAI DT WHERE DT.MADT = @MaDT) 
            AND @SoNS <= 4)
    BEGIN
        PRINT 'HOP LE'
        SET @SoNS = @SoNS + 1;
        INSERT THAMGIADT
        VALUES (@MaGV, @MaDT, @SoNS, 0.0, NULL);
    END
    IF('Nhà nước' = (SELECT DT.CAPQL 
            FROM DETAI DT WHERE DT.MADT = @MaDT) 
            AND @SoNS <= 4)
    BEGIN
        PRINT 'HOP LE'
        SET @SoNS = @SoNS + 1;
        INSERT THAMGIADT
        VALUES (@MaGV, @MaDT, @SoNS, 0.0, NULL);
    END
    ELSE 
    BEGIN
        RAISERROR(N'Không thể cập nhập công việc', 16, 1)
    END 
END
-- 6.	Viết function cho biết số lượng giảng viên của 1 mã đề tài
GO
CREATE PROCEDURE DEM_GV_CUA_DETAI @MaDT char(5)
AS 
BEGIN
	declare @counter int
	set @counter = ( select count(distinct tgdt.MAGV)
	from THAMGIADT tgdt
	group by tgdt.MADT
	having tgdt.MADT = @MaDT
	)

	return @counter
END

GO
declare @a int
exec @a = DEM_GV_CUA_DETAI '001'
PRINT @a

-- 7.	Viết function đếm số đề tài tham gia của 1 magv
GO 
CREATE function DEM_DETAI_CUA_GV (@MaGV char(5))
returns int 
BEGIN
	declare @counter int
	set @counter = (
		select count(distinct tgdt.MADT)
		from THAMGIADT tgdt
		group by  tgdt.MAGV
		having tgdt.MAGV = @MaGV
	)
	return @counter
END

GO
declare @res int
exec @res = DEM_DETAI_CUA_GV '001'
print (@res)

-- 8.	Viết function đếm số công việc của 1 madt
GO
CREATE PROCEDURE DEM_CV_CUA_MADT @MaDT char(5)
AS
BEGIN
	DECLARE @COUNTER INT
	SET @COUNTER = (
		SELECT COUNT(CV.TENCV)
		FROM CONGVIEC CV
		GROUP BY CV.MADT
		HAVING CV.MADT = @MaDT
	)
	RETURN @COUNTER
END
GO
DECLARE @RES INT
EXEC @RES = DEM_CV_CUA_MADT '001'
PRINT (@RES)

-- 9.	Viết function đếm số đề tài của 1 makhoa
GO
CREATE FUNCTION DEM_DETAI_CUA_MAKHOA (@MaKhoa CHAR(5))
RETURNS INT
AS
BEGIN
	DECLARE @COUNTER INT
	SET @COUNTER = (SELECT COUNT (DISTINCT DT.MADT)
	FROM KHOA KH, DETAI DT, BOMON BM, GIAOVIEN GV
	WHERE KH.MAKHOA = @MaKhoa AND KH.MAKHOA = BM.MAKHOA 
	AND DT.GVCNDT = GV.MAGV AND GV.MABM = BM.MABM
	)
	RETURN @COUNTER
END


-- 10 Viết function đếm số đề tài chủ nhiệm của 1 magv
GO
CREATE PROCEDURE DEM_SODETAI_CHUNHIEM_CUA_MAGV @MaGV char(5)
AS
BEGIN
	DECLARE @COUNTER INT
	SET @COUNTER = (SELECT COUNT (DISTINCT DT.MADT)
	FROM DETAI DT
	GROUP BY DT.GVCNDT
	HAVING DT.GVCNDT = @MaGV 
	)
	RETURN @COUNTER
END

DECLARE @RES INT
EXEC @RES = DEM_SODETAI_CHUNHIEM_CUA_MAGV '001'
PRINT @RES

-- 11.	Viết stored xuất danh sách (magv, ho ten, ten bo mon) của các giảng viên tham gia trên 3 đề tài 
-- (sử dụng function câu 7)

GO
CREATE PROCEDURE XUAT_DS_GV_TREN3DT
AS
BEGIN
	SELECT GV.MAGV, GV.HOTEN, BM.TENBM
	FROM GIAOVIEN GV, BOMON BM
	WHERE DBO.DEM_DETAI_CUA_GV(GV.MAGV)>3 AND GV.MABM = BM.MABM
END
	
GO
EXEC XUAT_DS_GV_TREN3DT

-- 12.	Viết stored xuất danh sách (magv, họ tên, số đề tài tham gia) của mỗi 
-- giảng viên (sử dụng câu 7)
GO
CREATE PROCEDURE XUAT_DS_CUA_MOI_GV 
AS
BEGIN
	SELECT GV.MAGV, GV.HOTEN, DBO.DEM_DETAI_CUA_GV(GV.MAGV) AS N'SỐ ĐỀ TÀI THAM GIA'
	FROM GIAOVIEN GV
END

GO 
EXEC XUAT_DS_CUA_MOI_GV

-- 13.	 Viết stored procedure cho biết mã khoa, tên khoa, số lượng đề tài đã nghiệm thu 
-- của các khoa trong năm 2022 (gọi lại function câu 9)

GO
CREATE FUNCTION fn_dem_detai_makhoa_2022 (@MaKhoa CHAR(5))
RETURNS INT
AS
BEGIN
    DECLARE @COUNTER INT
    SET @COUNTER = (SELECT COUNT (DISTINCT DT.MADT)
    FROM KHOA KH, DETAI DT, BOMON BM, GIAOVIEN GV
    WHERE KH.MAKHOA = @MaKhoa AND KH.MAKHOA = BM.MAKHOA 
    AND DT.GVCNDT = GV.MAGV AND GV.MABM = BM.MABM AND YEAR(DT.NGAYKT) >= 2022
    )
    RETURN @COUNTER
END

GO
CREATE PROC sp_nghiemthukhoa2022
AS
    BEGIN
        DECLARE @TEMP INT
        SELECT MAKHOA, TENKHOA, dbo.fn_dem_detai_makhoa_2022(MAKHOA) AS N'Số đề tài' FROM KHOA 
    END
EXEC sp_nghiemthukhoa2022


-- 14.	 Viết stored procedure cho biết khoa nào có số đề tài đã nghiệm thu nhiều nhất.



--14
GO
CREATE PROC sp_khoa_nghiemthu_nhieunhat 
AS
    SELECT TOP 1 MAKHOA, TENKHOA, dbo.DEM_DETAI_CUA_MAKHOA(MAKHOA) AS N'Số đề tài' FROM KHOA 
