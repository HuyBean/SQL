-- MSSV: 21127511
-- MALOP: 21CLC02

USE QLDTAI

-- 1. Cho biết mã số, họ tên, ngày sinh của giáo viên 
-- tham gia tất cả các công việc của đề tài 'Ứng dụng hoá học xanh'

-- BC: THAMGIADT 
-- C: PI_MACV=STT (CONGVIEC * SIGMA _TENDT = UDHHX (DETAI))
-- KQ: PI _MAGV, ... (GIAOVIEN)

SELECT  GV.MAGV, GV.HOTEN, GV.NGSINH
FROM GIAOVIEN GV
WHERE NOT EXISTS (	SELECT CV.SOTT, CV.MADT
					FROM CONGVIEC CV, DETAI DT
					WHERE CV.MADT = DT.MADT AND DT.TENDT = N'Ứng dụng hóa học xanh'
					EXCEPT (SELECT TGDT.STT, TGDT.MADT
							FROM THAMGIADT TGDT
							WHERE TGDT.MAGV = GV.MAGV
							)
)

SELECT  GV.MAGV, GV.HOTEN, GV.NGSINH
FROM GIAOVIEN GV, THAMGIADT TG1, CONGVIEC CV, DETAI DT
WHERE GV.MAGV = TG1.MAGV AND TG1.MADT = CV.MADT AND TG1.STT = CV.SOTT
AND CV.MADT = DT.MADT AND DT.TENDT = N'Nghiên cứu tế bào gốc'
GROUP BY GV.MAGV, GV.HOTEN, GV.NGSINH, CV.SOTT
HAVING COUNT(DISTINCT CV.SOTT) = (SELECT COUNT(CV.SOTT) 
FROM CONGVIEC CV, DETAI DT
WHERE CV.MADT = DT.MADT AND DT.TENDT = N'Nghiên cứu tế bào gốc'
)
-- 2. Cho biết mã số, họ tên, tên bộ môn và tên người quản lý chuyên môn của giáo viên 
-- tham gia tất cả các đề tài thuộc chủ đề 'Nghiên cứu phát triển'

-- BC: THAMGIADETAI
-- C: Sigma _CHUDE = 'NCPT' (DETAI * CHUDE)
--KQ: Pi (GIAOVIEN * BOMON * GIAOVIEN)

SELECT GV.MAGV, GV.HOTEN, BM.TENBM, GV.GVQLCM 
FROM GIAOVIEN GV JOIN BOMON BM
ON BM.MABM = GV.MABM
WHERE NOT EXISTS (  SELECT DT.MADT 
					FROM DETAI DT JOIN CHUDE CD
					ON CD.MACD = DT.MACD
					WHERE CD.TENCD = N'Nghiên cứu phát triển'
					EXCEPT(	SELECT TGDT.MADT 
							FROM THAMGIADT TGDT
							WHERE GV.MAGV = TGDT.MAGV
					)
)
-- 3. Cho biết họ tên, ngày sinh, tên khoa, tên trưởng khoa của giáo viên 
-- tham gia tất cả các đề tài có giáo viên 'Nguyễn Hoài An' tham gia

SELECT GV.HOTEN, GV.NGSINH, K.TENKHOA, TK.HOTEN 
FROM GIAOVIEN GV JOIN BOMON BM
ON BM.MABM = GV.MABM
JOIN KHOA K 
ON K.MAKHOA = BM.MAKHOA
JOIN GIAOVIEN TK 
ON TK.MAGV = K.TRUONGKHOA
WHERE NOT EXISTS (  SELECT DT.MADT 
					FROM DETAI DT, THAMGIADT TGDT1, GIAOVIEN GV2
					WHERE TGDT1.MADT = DT.MADT AND TGDT1.MAGV = GV2.MAGV AND GV2.HOTEN = N'Nguyễn Hoài An'
					EXCEPT(	SELECT TGDT.MADT 
							FROM THAMGIADT TGDT
							WHERE GV.MAGV = TGDT.MAGV AND GV.HOTEN != N'Nguyễn Hoài An' 
					)
)
-- 4. Cho biết họ tên giáo viên khoa Công nghệ thông tin 
-- tham gia tất cả các công việc của đề tài có trưởng bộ môn của bộ môn đông nhất 
-- khoa Công nghệ thông tin làm chủ nhiệm
