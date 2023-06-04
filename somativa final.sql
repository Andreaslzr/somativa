use formativaHogwarts;

alter table usuarios
add link_foto varchar(200),
add numero varchar(11);

create table tarefas(
id bigint not null auto_increment,
nome varchar(100) not null,
descricao varchar(100) not null,
prazo date not null,
data_abertura datetime default now() not null,
ambiente_ensinoFK bigint not null,
solicitanteFK bigint not null,
primary key(id),
foreign key(ambiente_ensinoFK) references locais(id),
foreign key(solicitanteFK) references usuarios(id)
);

create table tarefas_responsavel(
id bigint not null auto_increment,
tarefaFK bigint not null,
responsavelFK bigint not null,
primary key(id),
foreign key(tarefaFK) references tarefas(id),
foreign key(responsavelFK) references usuarios(id)
);

create table status(
id bigint not null auto_increment,
nome varchar(50) not null,
primary key(id)
);

create table tarefas_status(
id bigint not null auto_increment,
tarefaFK bigint not null,
statusFK bigint not null,
data datetime default now() not null,
comentario varchar(100),
primary key(id),
foreign key(tarefaFK) references tarefas(id),
foreign key(statusFK) references status(id)
);

create table fotos(
id bigint not null auto_increment,
tarefastatusFK bigint not null,
link_foto varchar(200) not null,
primary key(id),
foreign key(tarefastatusFK) references tarefas_status(id)
);

insert into tarefas(nome,descricao,prazo,ambiente_ensinoFK,solicitanteFK) values
('arrumar computador','tela azul','2023-06-12',1,1),
('arrumar computador','cabo de internet quebrado','2023-06-08',3,1),
('consertar cadeira','cadeira quebrada','2023-06-05',2,3),
('consertar cadeira','cadeira quebrada','2023-06-07',1,5);

insert into tarefas_responsavel(tarefaFK,responsavelFK) values
(1,3),(1,4),(2,3),(2,4),(3,3),(3,4),(4,3),(4,4);

insert into status(nome) values
('Aberta'),('Em andamento'),('Concluída'),('Encerrada');

insert into tarefas_status(tarefaFK,statusFK) values
(1,1),(2,1),(3,1),(4,1);
insert into tarefas_status(tarefaFK,statusFK,data) values
(1,2,'2023-06-02 10:44:40'),(1,3,'2023-06-05 11:26:03'),(1,4,'2023-06-06 13:00:37'),
(2,2,'2023-06-02 10:20:05'),(2,3,'2023-06-03 09:00:08'),(3,2,'2023-06-03 14:20:15');

insert into fotos(tarefastatusFK,link_foto) values
(1,'https:agdgsggds'),(2,'https: adgshgjftre'),(3,'https:trffbddr'),
(4,'https:ftrjhkgkgh'),(6,'https:bgsdgfhfgjf'),(7,'https:ujgjgfh');
select*from tarefas_status;


#1)
select t.id as id_tarefa ,t.nome as tarefa, u.nome as responsavel, u.email from tarefas t
inner join tarefas_status ts on t.id=ts.tarefaFK
inner join tarefas_responsavel tr on t.id=tr.tarefaFK
inner join usuarios u on u.id=tr.responsavelFK
where t.id not in(
select t.id from tarefas t
inner join tarefas_status ts on t.id=ts.tarefaFK
inner join tarefas_responsavel tr on t.id=tr.tarefaFK
inner join usuarios u on u.id=t.solicitanteFK
where ts.statusFK in (2,3,4));

#2)
select *from locais l
where l.id not in (
select l.id from locais l
inner join tarefas t on l.id=t.ambiente_ensinoFK);

#3)
select*from usuarios u 
where u.id not in(
select u.id from usuarios u
inner join tarefas t on u.id=t.solicitanteFK)and u.id not in (
select u.id from usuarios u
inner join tarefas_responsavel tr on u.id=tr.responsavelFK);

#4)
select e.nome as evento,e.inicio,l.id as local_id,l.nome as local,t.id as tarefa_id,t.nome as tarefa from eventos e
inner join locais l on l.id=e.localFK
inner join tarefas t on l.id=t.ambiente_ensinoFK
where e.inicio>now() and t.id not in(
select tarefaFK from tarefas_status
where statusFK=4);

#5)
select l.id,l.nome as local,count(*) from locais l
inner join tarefas t on l.id=t.ambiente_ensinoFK
group by l.id;

#6)
select l.id,l.nome as local,count(*) as 'tarefas não concluidas' from locais l
inner join tarefas t on l.id=t.ambiente_ensinoFK
where t.id not in(
select tarefaFK from tarefas_status
where statusFK in (3,4)) group by l.id;

#7)
select u.id,u.nome,count(*) from usuarios u
inner join tarefas_responsavel tr on u.id=tr.responsavelFK 
group by u.id;

#8)
select u.id,u.nome,count(*) from usuarios u
inner join tarefas_responsavel tr on u.id=tr.responsavelFK 
where tarefaFK not in(
select tarefaFK from tarefas_status
where statusFK in (3,4)) group by u.id;

#9)
select id,nome,month(data_abertura),avg(qtd_tarefas) as media from(
select l.id,l.nome,t.data_abertura,count(*) as qtd_tarefas from locais l
inner join tarefas t on l.id=t.ambiente_ensinoFK
group by l.id,t.data_abertura) sub group by month(data_abertura),id;

