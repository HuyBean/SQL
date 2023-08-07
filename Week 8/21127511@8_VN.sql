-- MSSV: 21127511
-- MaLop: 21CLC02

-- A: In ra câu chào "Hello World !!!"
GO 
CREATE PROCEDURE Print_Hello 
AS
	PRINT 'Hello World !!!'

GO 
Exec Print_Hello

-- B: IN RA TỔNG 2 SỐ 
GO
CREATE PROCEDURE Print_Tong @soa float, @sob float
AS 
	Declare @tong float
	SET @tong = @soa + @sob
	Print @tong

Go
Exec Print_Tong 4.5, 5.6

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

-- F: KIỂM TRA SỐ NGUYÊN CÓ PHẢI SỐ NGUYÊN TỐ HAY KHÔNG
GO
CREATE PROCEDURE CHECK_PRIME @snt INT
AS 
BEGIN
    DECLARE @isPrime int = 1;
    DECLARE @i INT = 2;

    IF @snt <= 1
    BEGIN
        SET @isPrime = 0;
    END
    ELSE
    BEGIN
        WHILE @i <= SQRT(@snt)
        BEGIN
            IF @snt % @i = 0
            BEGIN
                SET @isPrime = 0;
                BREAK;
            END
            SET @i = @i + 1;
        END
    END

    return @isPrime
END

GO 
Declare @isP int
EXEC @isP = CHECK_PRIME 17
Print @isP

-- G: In ra tổng các số nguyên tố trong đoạn m, n

GO
CREATE PROCEDURE Print_Sum_Prime @SoM int, @SoN int
AS
	DECLARE @i int
	DECLARE @Sum int
	SET @i = @SoM
	SET @Sum = 0
	WHILE @i <= @SoN
	BEGIN 
		Declare @check int
		Exec @check = CHECK_PRIME @i
		IF (@check = 1) 
			BEGIN
			SET @Sum = @Sum + @i
			END
		SET @i = @i + 1
	END

	print @Sum

Go
Exec Print_Sum_Prime 2, 10

-- H: Tính ước chung lớn nhất của 2 số nguyên
Go 
create procedure GCD @soA int, @soB int
AS 
	if (@SoA = 0 OR @SoB = 0)
	BEGIN
        return @SoA + @SoB
    END
    WHILE (@SoA != @SoB)
	BEGIN
        if (@SoA > @SoB)
		BEGIN
            SET @SoA -= @SoB
        END
		ELSE
		BEGIN
            SET @SoB -= @SoA;
        END
    END
    return @SoA; 

GO
DECLARE @Num int
EXEC  @Num = GCD 4, 20
PRINT @Num

-- I: Tính BCNN CỦA 2 SỐ NGUYÊN
GO
CREATE PROCEDURE LCM @SoA int, @SoB int
AS 
	DECLARE @UCLN int
	EXEC @UCLN = GCD @SoA, @SoB
	DECLARE @Multy int
	SET @Multy = @SoA * @SoB
	DECLARE @Result int 
	SET @Result = @Multy / @UCLN
	RETURN @Result

GO
DECLARE @Num int
EXEC  @Num = LCM 4, 20
PRINT @Num 

-- J: XUẤT RA TOÀN BỘ DANH SÁCH GIÁO VIÊN
GO
CREATE PROCEDURE Print_All_GV
AS 
BEGIN 
	SELECT * FROM GIAOVIEN
END

GO
EXEC Print_All_GV

-- K: TÍNH SỐ LƯỢNG ĐỀ TÀI MÀ MỘT GIÁO VIÊN ĐANG THỰC HIỆN.
GO 
CREATE PROCEDURE NUM_DT @MaGV char(5)
AS
BEGIN
	SELECT COUNT(TGDT.MADT)
	FROM THAMGIADT TGDT
	WHERE TGDT.MAGV = @MaGV
END

GO
EXEC NUM_DT '004'
	
-- L: IN THÔNG TIN CHI TIẾT CỦA MỘT GIÁO VIÊN: 
-- THÔNG TIN CÁ NHÂN, 
-- SỐ LƯỢNG ĐỀ TÀI THAM GIA
-- SỐ LƯỢNG THÂN NHÂN CỦA GIÁO VIÊN ĐÓ
GO 
CREATE PROCEDURE Print_GV_Details @MaGV INT, @SoLuong INT OUT, @SoNgThan INT OUT
AS 
BEGIN
    PRINT N'THÔNG TIN CÁ NHÂN:'
    SELECT *
    FROM GIAOVIEN GV
    WHERE GV.MAGV = @MaGV;

    -- Retrieve the number of research topics the teacher participated in
    SELECT @SoLuong = COUNT(*) FROM THAMGIADT TGDT WHERE TGDT.MADT = @MaGV;

    -- Retrieve the number of relatives of the teacher
    SELECT @SoNgThan = COUNT(*) FROM NGUOITHAN NT WHERE NT.MAGV = @MaGV;
END

-- M: KIỂM TRA XEM MỘT GIÁO VIÊN CÓ TỒN TẠI HAY KHÔNG DỰA VÀO MAGV
GO
CREATE PROCEDURE Kiem_Tra_Giao_Vien_Ton_Tai
    @MAGV NVARCHAR(20), 
    @GiaoVienTonTai INT OUT 
AS 
BEGIN
    -- Khởi tạo tham số đầu ra về 0 (false)
    SET @GiaoVienTonTai = 0;

    -- Kiểm tra xem giáo viên có tồn tại hay không
    IF EXISTS (SELECT 1 FROM GIAOVIEN GV WHERE GV.MAGV = @MAGV)
    BEGIN
        -- Đặt tham số đầu ra về 1 (true) nếu giáo viên tồn tại
        SET @GiaoVienTonTai = 1;
    END
END

GO
DECLARE @GiaoVienTonTai INT;

EXEC Kiem_Tra_Giao_Vien_Ton_Tai 
    @MAGV = '004', 
    @GiaoVienTonTai = @GiaoVienTonTai OUT;

IF @GiaoVienTonTai = 1
    PRINT N'Giáo viên tồn tại.';
ELSE
    PRINT N'Giáo viên không tồn tại.';

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

-- O: 
go
create proc ADD_PhanCongGV @magv char(5), @detai char(3), @congviec int
as
begin
	if not exists (select * from GIAOVIEN where MAGV = @magv)
	begin
		raiserror (N'Giáo viên không tồn tại', 15, 1)
		return
	end
	if not exists (select * from CONGVIEC where MADT=@detai and SOTT=@congviec)
	begin
		raiserror (N'Đề tài và công việc không tồn tại', 15, 1)
		return 
	end
	declare @check int
	exec @check=Check_Rule @magv
	if (@check != 1)
	begin
		raiserror (N'Điều kiện để 1 giáo viên tham gia đề tài không thỏa', 15, 1)
		return
	end
	insert into THAMGIADT (MAGV, MADT, STT)
	values (@magv, @detai, @congviec)
	return 1
end
--
GO
declare @kq int
exec @kq = ADD_PhanCongGV '003', '002', 3
if @kq = 1
	print (N'Phân công thành công!!')

-- P
go
create procedure Delete_GiaoVien @magv char(5)
as
begin
	if not exists (select * from GIAOVIEN where MAGV=@magv)
	begin 
		raiserror (N'Giáo viên không tồn tại.', 15, 1)
		return
	end
	if exists (select * from THAMGIADT where MAGV=@magv)
	begin
		raiserror (N'Giáo viên đã tham gia đề tài rồi.', 15, 1)
		return
	end
	if exists (select * from NGUOITHAN where MAGV=@magv)
	begin
		raiserror (N'Không thể xóa.', 15, 1)
		return
	end
	delete from GIAOVIEN
	where MAGV=@magv
	return 1
end
--
Go
declare @kq int
exec @kq = Delete_GiaoVien '001'
if @kq=1
	print(N'Xóa thành công.')

-- R
go
create procedure Check_QuyDinh @magv1 char(5), @magv2 char(5)
as
begin
	declare @luong1 float, @luong2 float
	set @luong1 = (select LUONG from GIAOVIEN where MAGV=@magv1) 
	set @luong2 = (select LUONG from GIAOVIEN where MAGV=@magv2)
	if exists (select * from GIAOVIEN GV join BOMON BM on GV.MABM=BM.MABM where GV.MAGV=@magv2 and BM.TRUONGBM=@magv1)
	begin 
		if @luong1 > @luong2
		begin 
			return 1
		end
		else
		begin
			return -1
		end
	end
	return -1
end
-- 
GO
declare @kq int
exec @kq = Check_QuyDinh'002', '003'
if @kq=1
	print('Ok')
else 
	print('Not Ok')


-- S
go
create procedure ADD_GiaoVien @magv char(5), @hoten nvarchar(50), @phai nvarchar(10), @luong float, @ngsinh datetime
as
begin
	if exists (select * from GIAOVIEN where HOTEN=@hoten)
	begin
		raiserror (N'Trùng tên!!', 15, 1)
		return 
	end
	if @luong <= 0
	begin
		raiserror (N'Lương quá thấp!!', 15, 1)
		return 
	end
	if DATEDIFF(year,@ngsinh, getdate()) <= 18
	begin 
		raiserror (N'Dưới 18 tuổi!!', 15, 1)
		return 
	end
	insert into GIAOVIEN(MAGV, HOTEN, PHAI, LUONG, NGSINH)
	values (@magv, @hoten, @phai, @luong, @ngsinh)
	return 1
end
--
GO
declare @kq int
exec @kq = ADD_GiaoVien '011', N'Nguyễn Quốc Huy', N'Nam', 2520, '07/11/2003'
if @kq = 1
	print(N'Thêm thành công!!')

-- T
go
create procedure ADD_GV_RULE
    @hoten nvarchar(50),
    @phai nvarchar(10),
    @luong float,
    @ngsinh datetime
as
begin
    -- Tìm mã giáo viên mới dựa trên quy tắc đã mô tả
    declare @magv char(5)
    declare @counter int

    set @counter = 1
    set @magv = RIGHT('000' + CAST(@counter as varchar(3)), 3)

    while EXISTS (select * from GIAOVIEN where MAGV = @magv)
    begin
        set @counter = @counter + 1
        set @magv = RIGHT('000' + CAST(@counter as varchar(3)), 3)
    end

    -- Nếu không tìm thấy mã giáo viên mới theo quy tắc, sẽ sử dụng mã '001'
    if @magv IS NULL
    begin
        set @magv = '001'
    end

    -- Kiểm tra trùng tên, tuổi, lương
	declare @check int
	exec @check=ADD_GiaoVien @magv, @hoten, @phai, @luong, @ngsinh
	if @check = 1
	begin
		return 1
	end
	return -1
end
--
declare @kq int
exec @kq = ADD_GV_RULE N'NGUYỄN VĂN H', N'NAM', 1000, '12/1/2001'
if @kq = 1
	print(N'Thêm thành công')
else
	print(N'Thêm không thành công')
----------------------------------------------------------------------------------------------------------------
-- Bài tập đặt phòng
-- câu 1
go
create procedure spDatPhong @makh char(3), @maphong char(3), @ngaydat datetime
as
begin
	declare @madatphong char(3)
	declare @counter int

    set @counter = 1
    set @madatphong = RIGHT('000' + CAST(@counter as varchar(3)), 3)

    while EXISTS (select * from DATPHONG where MA = @madatphong)
    begin
        set @counter = @counter + 1
        set @madatphong = RIGHT('000' + CAST(@counter as varchar(3)), 3)
    end

    -- Nếu không tìm thấy mã giáo viên mới theo quy tắc, sẽ sử dụng mã '001'
    if @madatphong IS NULL
    begin
        set @madatphong = '001'
    end
	-- Kiểm tra mã khách hàng
	if not exists (select * from KHACH where maKH = @makh)
	begin
		raiserror (N'Không tìm thấy khách hàng!!', 15, 1)
		return
	end
	-- Kiểm tra mã phòng
	if not exists (select * from PHONG where maphong = @maphong)
	begin
		raiserror (N'Không tìm thấy phòng tương ứng', 15, 1)
		return
	end
	-- Kiểm tra phòng trống
	if (select tinhtrang from PHONG where maphong = @maphong) != N'RẢNH'
	begin
		raiserror (N'Phòng không trống!!', 15, 1)
		return 
	end
	-- Đặt phòng
	insert into DATPHONG
	values (@madatphong, @makh, @maphong, @ngaydat, NULL, NULL)
	update PHONG
	set tinhtrang = N'BẬN'
	where maphong = @maphong
	return 1
end


-- câu 2
go
create procedure spTraPhong @madatphong char(3), @makh char(3)
as
begin
	-- Kiểm tra có đặt phòng hay chưa
	if not exists (select * from DATPHONG where MA=@madatphong and maKH = @makh)
	begin
		raiserror (N'Không thể trả phòng!!', 15, 1)
		return 
	end
	-- Thực hiện trả phòng
    -- ngày trả
	update DATPHONG
	set ngaytra = getdate()
	where MA=@madatphong
	-- Tiền thanh toán
	declare @giaphong float, @songaythue int, @thanhtien float, @maphong char(3), @ngaythue datetime
	set @maphong = (select maphong from DATPHONG where MA=@madatphong)
	set @giaphong = (select dongia from PHONG where maphong = @maphong)
	set @ngaythue = (select ngaydat from DATPHONG where MA=@madatphong)
	set @songaythue = DATEDIFF(day, @ngaythue, getdate())
	set @thanhtien = @songaythue*@giaphong
	update DATPHONG
	set thanhtien = @thanhtien
	where MA=@madatphong
	-- cập nhật lại tình trạng phòng
	update PHONG
	set tinhtrang = N'Rảnh'
	where maphong = @maphong
	return 1
end
