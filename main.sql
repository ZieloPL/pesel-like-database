
create database PESEL;

use PESEL;

create table spis_ludnosci(
id int primary key identity,
PESEL varchar(11),
imie varchar(64),
nazwisko varchar(64),
data_ur date,
plec varchar(1)
);

alter table spis_ludnosci
add constraint ch_plec check(plec in ('k', 'm'));

alter table spis_ludnosci
add constraint pesel_unique unique(PESEL);

alter table urodzeni_dzisiaj
add constraint ch_plec1 check(plec in ('k', 'm'));

insert into spis_ludnosci(imie, nazwisko, plec, data_ur)
values('Marzena', 'Kowalska', 'k', getdate());

select * from spis_ludnosci;

alter trigger auto_pesel on spis_ludnosci /* trigger generuj¹cy pesel po dodaniu rekordu */
after insert
as
begin
	update spis_ludnosci set PESEL = 
		(cast(right(year((select top 1 data_ur from spis_ludnosci order by id desc)), 2) as varchar(64)) + /* pobieramy dwie ostatnie cyfry roku */
		
		cast((select top 1 case 
			when Month(data_ur) = 1 then '21'
			when Month(data_ur) = 2 then '22'
			when Month(data_ur) = 3 then '23'
			when Month(data_ur) = 4 then '24'
			when Month(data_ur) = 5 then '25'
			when Month(data_ur) = 6 then '26'
			when Month(data_ur) = 7 then '27'
			when Month(data_ur) = 8 then '28'
			when Month(data_ur) = 9 then '29'
			when Month(data_ur) = 10 then '30'
			when Month(data_ur) = 11 then '31'
			when Month(data_ur) = 12 then '32' /* ka¿demu miesi¹cowi z obecnego millenium przypada inna liczba */
		end
		from spis_ludnosci order by id desc) as varchar(64)) +
		
		cast((select top 1 day(data_ur) from spis_ludnosci order by id desc) as varchar(64)) + /* pobieramy dzien z daty urodzenia */

		cast((format((select top 1 case
			when id <= 9 then FORMAT((select top 1 id from spis_ludnosci order by id desc), '000')
			when id >= 10 and id <= 99 then '0' + id
			when id >= 100 and id <= 999 then id
		end
		from spis_ludnosci order by id desc), '000') /* cyfry porz¹dkowe */
		)as varchar(64)) +

		(select top 1 case
			when plec = 'k' then cast((select 2*floor(rand()*(10-1+1)/2)) as varchar(64)) /* parzysta dla kobiet */
			when plec = 'm' then cast((select 2*floor(rand()*(10-1+1)/2)+1) as varchar(64))  /* nieparzysta dla mê¿czyzn */
		end
		from spis_ludnosci order by id desc
		) +

		cast(floor(rand()*(10-1+1)) as varchar(64)) /* ostatnia cyfra jest losowa */
		)
		where id = (select top 1 id from spis_ludnosci order by id desc)
end;








