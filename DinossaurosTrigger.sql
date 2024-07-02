create table eras (
    nome varchar(50) primary key,
    ano_inicio integer not null,
    ano_fim integer not null
);

create table grupos (
    nome varchar(50) primary key,
    tipo_alimentacao varchar(50) not null
);

create table dinossauros (
    nome varchar(50) primary key,
    grupo varchar(50) references grupos(nome),
    toneladas integer not null,
    ano_descoberta integer not null,
    descobridor varchar(100) not null,
    era varchar(50) references eras(nome),
    pais varchar(50) not null
);

-- inserir registros na tabela eras
insert into eras (nome, ano_inicio, ano_fim) values
('triássico', 251, 200),
('jurássico', 200, 145),
('cretáceo', 145, 65);

-- inserir registros na tabela grupos
insert into grupos (nome, tipo_alimentacao) values
('anquilossauros', 'herbívora'),
('ceratopsídeos', 'herbívora'),
('estegossauros', 'herbívora'),
('terápodes', 'carnívora');

-- inserir registros na tabela dinossauros
insert into dinossauros (nome, grupo, toneladas, ano_descoberta, descobridor, era, pais) values
('saichania', 'anquilossauros', 4, 1977, 'maryanska', 'cretáceo', 'mongólia'),
('tricerátops', 'ceratopsídeos', 6, 1887, 'john bell hatcher', 'cretáceo', 'canadá'),
('kentrossauro', 'estegossauros', 2, 1909, 'cientistas alemães', 'jurássico', 'tanzânia'),
('pinacossauro', 'anquilossauros', 6, 1999, 'museu americano de história natural', 'triássico', 'china'),
('alossauro', 'terápodes', 3, 1877, 'othniel charles marsh', 'jurássico', 'américa do norte');

create or replace function valida_anos_era()
returns trigger as $$
begin
    if new.ano_descoberta < (select ano_inicio from eras where nome = new.era) or 
       new.ano_descoberta > (select ano_fim from eras where nome = new.era) then
        raise exception 'ano de descoberta do dinossauro não está correto!';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_valida_anos_era
before insert or update on dinossauros
for each row execute function valida_anos_era();

create or replace function valida_anos_existencia()
returns trigger as $$
begin
    if new.ano_descoberta < (select ano_inicio from eras where nome = new.era) or 
       new.ano_descoberta > (select ano_fim from eras where nome = new.era) then
        raise exception 'ano de descoberta não condiz com a era informada!';
    end if;
    return new;
end;
$$ language plpgsql;

create trigger trg_valida_anos_existencia
before insert or update on dinossauros
for each row execute function valida_anos_existencia();

select * from eras
select * from grupos
select * from dinossauros

