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
(4,'https:ftrjhkgkgh'),(18,'https:bgsdgfhfgjf'),(19,'https:ujgjgfh');


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



