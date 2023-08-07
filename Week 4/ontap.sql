use master 
go

if db_id('QLLichDay') is not null
	drop database QLLichDay
go

create database QLLichDay
go

use QLLichDay
go

create table lophoc
(
	idlophoc varchar(5),
	nambd int,
	chunhiem varchar(5),
	idkhoa varchar(5),
	soluong int

	constraint PK_lophoc
	primary key (idlophoc)
)

create table giaovien
(
	idkhoa varchar(5),
	idmagv varchar(5),
	hoten nvarchar(50),
	socmnd varchar(9),
	ngaysinh datetime,
	idquanly varchar(5)

	constraint PK_giaovien
	primary key (idkhoa, idmagv)
)

create table lichday
(
	idlop varchar(5),
	idthutiet varchar(10),
	idphonghoc varchar(5),
	giaovien varchar(5),
	idkhoa varchar(5),
	thoiluong int,
	thietbi varchar(50)

	constraint PK_lichday
	primary key(idlop, idthutiet, idphonghoc)
)

alter table lophoc
add
	constraint FK_lophoc_giaovien
	foreign key (idkhoa, chunhiem)
	references giaovien

alter table giaovien
add 
	constraint FK_giaovien_giaovien
	foreign key (idkhoa, idquanly)
	references giaovien

alter table lichday
add
	constraint FK_lichday_giaovien
	foreign key (idkhoa, giaovien)
	references giaovien,

	constraint FK_lichday_lophoc
	foreign key (idlop)
	references lophoc

insert	giaovien
values	('1', '1716', N'Nguyễn Quan Tùng', '240674018', '02/01/1988', null),
		('2', '0357', N'Lưu Phi Nam', '240674027', '7/20/1980', null),
		('2', '1716', N'Lê Quang Bảo', '240674063', null, null),
		('1', '0753', N'Hà Ngọc Thúy', '240674504', '5/2/1990', null),
		('1', '0357', N'Trương Thị Minh', '240674405', null, null),
		('1', '1718', N'Ngô Thị Thủy', '240674306', null, null)

update giaovien
set idquanly = '0753' 
where idkhoa = '1' and idmagv = '1716'

update giaovien
set idquanly = '1716' 
where idkhoa = '2' and idmagv = '0357'

update giaovien
set idquanly = '0753' 
where idkhoa = '1' and idmagv = '0357'

update giaovien
set idquanly = '0357' 
where idkhoa = '1' and idmagv = '1718'

insert	lophoc
values	('L01', 2015, '0357', '2', null),
		('L02', 2013, '1716', '1', null)

insert lichday
values	('L01', 'T2(1-6)', '2', '1718', '1', 10, null),
		('L02', 'T2(7-12)', '1', '0753', '1', 30, null),
		('L01', 'T4(4-6)', '5', '0357', '2', 25, null)

select * from lophoc
select * from lichday
select * from giaovien


