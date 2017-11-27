drop table if exists users;
create table users (
	id integer primary key,
	name string,
	password_digest string
);

