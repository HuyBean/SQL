USE [QLLopHoc]
GO
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV001', N'Nguyễn Văn A', N'Nam', CAST(N'1990-12-20' AS Date), N'Hồ Chí Minh')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV002', N'Trần Thị B', N'Nu', CAST(N'1980-05-06' AS Date), N'Long An')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV003', N'Lê Văn C', N'Nam', CAST(N'1985-03-07' AS Date), N'Hà Nội')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV004', N'Nguyễn Trần D', N'Nam', CAST(N'1992-11-15' AS Date), N'Lào Cai')
INSERT [dbo].[GIAOVIEN] ([magv], [hoten], [gioitinh], [ngaysinh], [diachi]) VALUES (N'GV005', N'Nguyễn Thị Thu E', N'Nu', CAST(N'1987-10-28' AS Date), N'Đồng Nai')
GO
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS001', N'Nguyễn Thị Lan', N'Nu', CAST(N'2003-11-11' AS Date), N'Hồ Chí Minh', N'LH001')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS002', N'Nguyễn Quốc An', N'Nam', CAST(N'2003-01-03' AS Date), N'Hồ Chí Minh', N'LH003')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS003', N'Trần Văn Huy', N'Nam', CAST(N'2003-08-09' AS Date), N'Hồ Chí Minh', N'LH005')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS004', N'Lê Thị Yến', N'Nu', CAST(N'2003-06-05' AS Date), N'Hà Nội', N'LH002')
INSERT [dbo].[HOCSINH] ([mahs], [hoten], [gioitinh], [ngaysinh], [diachi], [malop]) VALUES (N'HS005', N'Nguyễn Thị Hồng', N'Nu', CAST(N'2003-04-09' AS Date), N'Hà Nội', N'LH004')
GO
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [lop_tr]) VALUES (N'LH001', N'12 Toán 1', 21, N'GV003', N'HS001')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [lop_tr]) VALUES (N'LH002', N'12 Văn 3', 21, N'GV002', N'HS003')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [lop_tr]) VALUES (N'LH003', N'11 Toán 1', 22, N'GV005', N'HS002')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [lop_tr]) VALUES (N'LH004', N'10 Sinh 1', 23, N'GV001', N'HS004')
INSERT [dbo].[LOPHOC] ([malop], [tenlop], [nam], [gvcn], [lop_tr]) VALUES (N'LH005', N'12 Sử 2', 21, N'GV004', N'HS005')
GO