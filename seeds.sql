drop table if exists busstops;
create table busstops(
	id integer primary key,
	name string,
	pre string,
	muni string
);

insert into busstops values (1, '高専前', '福島県', 'いわき市');
insert into busstops values (2, '技科大前', '愛知県', '豊橋市');
insert into busstops values (3, 'JR鯖江駅', '福井県', '鯖江市');
