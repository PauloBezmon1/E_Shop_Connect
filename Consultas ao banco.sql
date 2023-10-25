-- 2a Consultar todos os produtos existentes na loja.
select
 * 
from product;
 
 -- b. Consultar os nomes de todos os usuários
select
name as Usuarios
from users; 

-- c. Consultar as lojas que vendem produtos.
select 
	distinct s.name as Loja,
	p.amount as Qts 
from store as s
join product as p on p.fk_sid = s.pk_sid;

 -- d. Consultar os endereços relacionado com os clientes.
select 
    a.province as Estado,
    a.city as Cidade,
    a.streetaddr as Rua,
	u.name as Cliente
from address as a
join buyer as b on b.pk_userID = a.pk_addrID
join users as u on u.userid = b.pk_userID;

-- e. Consultar todos os produtos do tipo Laptop.
select
	name as Produto,
    type as Tipo,
    price as Preço
from Product
where type = "laptop";

-- f. Consultar o endereço, hora de início(start time) e hora final(end tim) dos pontos de serviço da mesma cidade que o usuário cujo o ID é 5
select
	distinct sp.pk_spid as ID,
	sp.province as Estado,
	sp.city as Cidade,
	sp.streetaddr as Rua,
	sp.startTime as hora_de_início,
	sp.endtime as hora_final
from users as u
join save_to_shopping_cart as sc on sc.fk_userID = u.userid
join product as p on p.pk_pid = sc.fk_pid
join brand as b on pk_brandName = fk_brandName
join after_sales_service_at as af on af.fk_brandName = b.pk_brandName
join servicepoint as sp on sp.pk_spid = fk_spid
where sp.city = "Montreal"
group by ID
Order by ID asc;

-- g.Consultar a quantidade total de produtos que foram colocados no carrinho (shopping cart), considerando a loja com ID (sid) igual a 8.
select
    s.pk_sid as ID,
    s.name as Loja,
    sum(sc.quantity) as total_produtos
    from store as s
join product as p on p.fk_sid = s.pk_sid
join save_to_shopping_cart as sc on sc.fk_pid = p.pk_pid
WHERE s.pk_sid = "8"
group by ID;

-- h.Consultar os comentários do produto 123456789.
select
	p.modelNumber as Numero_Modelo,
	p.name as Produto,
    c.grade as Avaliação,
    c.content as Comentário
from product p
join comments c on c.fk_pid = p.pk_pid
where p.modelNumber = "C201PA-DS02";