create database tvbdb;

create table UTENTE (
	id integer auto_increment primary key,
    username varchar(255) not null,
    data_nascita date not null,
    email varchar(255) not null,
    password varchar(255) not null,
    propic mediumblob
)Engine = 'InnoDB';

create table TITOLO (
	id integer auto_increment primary key,
    nome varchar(255),
    tipo varchar(255),
    db varchar(255),
    uploadedby varchar(255)
)Engine = 'InnoDB';


create table VISIONE(
    id integer auto_increment primary key,
    utente integer not null,
    TITOLO integer not null,
    data_inizio_visione date not null,
    guardando boolean,
    n_visto integer,
    
    index ind_user (utente),
    index ind_content (titolo),
    
    unique(utente,titolo),
    foreign key(utente) references utente(id),
    foreign key(TITOLO) references TITOLO(id)
)engine = 'InnoDB';


create table VALUTA(
    id integer auto_increment primary key,
    utente integer not null,
    titolo integer not null,
    commento varchar(255),
    voto integer default 0,
    
    index inx_user (utente),
    index inx_content (titolo),
    
    foreign key(utente) references utente(id),
    foreign key(titolo) references titolo(id),
    unique(utente,titolo)
)Engine = 'InnoDB';



create table generi(
	id integer primary key,
    commedia boolean,
    drammatico boolean,
    horror boolean,
    romantico boolean,
    azione boolean,
    avventura boolean,
    retro boolean,
    fantasy boolean,
    bambini boolean,
    
    index idx_utente(id),
    
    foreign key(id) references utente(id)
)Engine = 'InnoDB';

create view viewsData as
select v.id  as id, v.utente as utente, v.titolo as titolo, v.data_inizio_visione as data, v.guardando as guardando, n_visto as visto, val.commento as commento, val.voto as voto
 from (visione v left join valuta val on val.titolo = v.titolo and(v.utente = val.utente));

create view titData as
select t.nome as nome , t.db as db, t.uploadedby as uploader, avg(val.voto) as punteggio, sum(v.n_visto) as vievs, sum(v.guardando) as watching, t.id as id
from (visione v right join titolo t on t.id = v.TITOLO) left join valuta val on v.utente = val.utente and(val.titolo = t.id)  group by t.id;
