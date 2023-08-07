-- MSSV: 21127511
-- MaLop: 21CLC02

-- C: TÍNH TỔNG 2 SỐ (SỬ DỤNG OUTPUT ĐỂ LƯU KẾT QUẢ TRẢ VỀ)
GO
CREATE PROCEDURE Tong_2_so @soa float, @sob float, @tong float out 
AS 
	SET @tong = @soa + @sob

GO 
Declare @Sum float
EXEC Tong_2_so 1.5, 2.3, @Sum out
Print @Sum

-- D: IN RA TỔNG 3 SỐ (SỬ DỤNG LẠI STORED PROCEDURE TÍNH TỔNG 2 SỐ)
GO
CREATE PROCEDURE Sum_3 @soa float, @sob float, @soc float, @Sum float out
AS 
	DECLARE @temp float
	exec Tong_2_so @soa, @sob, @temp out
	exec Tong_2_so @temp, @soc, @Sum out

GO
Declare @Sum float
EXEC Sum_3 1.5, 2.3, -0.8, @Sum out
PRINT @Sum

-- E: IN RA TỔNG CÁC SỐ NGUYÊN TỪ M ĐẾN N
GO
CREATE PROCEDURE SUM_INT @m int, @n int
AS 
	Declare @tong int
	Declare @i int
	Set @tong = 0
	Set @i = @m
	While(@i<=@n)
	BEGIN 
		SET @tong = @tong + @i
		SET @i = @i  + 1
	END
	PRINT @tong

Go 
Exec SUM_INT 5, 8

-- N: Kiểm tra quy định của một Gv: chỉ được thực hiện các đề tài mà bộ môn của GV đó làm chủ nhiệm
GO
CREATE PROCEDURE Check_Rule @MaGV char(5)
AS 
	If exists 
	(
		Select * from 
		(
			Select GV1.MAGV
			From THAMGIADT TGDT, GIAOVIEN GV1, GIAOVIEN GV2, DETAI DT
			WHERE TGDT.MAGV = GV1.MAGV AND GV2.MAGV = DT.GVCNDT AND GV1.MABM = GV2.MABM AND TGDT.MADT = DT.MADT
		) AS Find_Table 
		WHERE @MaGV = Find_Table.MAGV
	) 
		return 1
	ELSE 
		return 0

Go 
Declare @ok int
exec @ok = Check_Rule '004'
Print @ok
