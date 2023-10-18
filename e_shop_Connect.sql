drop table deliver_to;
drop table address;
drop table seller;
drop table users;
drop table creditcard;
drop table debitcard;
drop table bankcard;
drop table Payment;
drop table Orders;
drop table save_to_shopping_cart;
drop table buyer;
drop table Contain;
drop table OrderItem;
drop table store;
drop table Product;
drop table Brand;
drop table Manage;
drop table Comments;
drop table ServicePoint;
drop table after_sales_services_at;

drop database e_shop_connect;
create database e_shop_home;
use e_shop_connect;

create table users(
	userid              int not null auto_increment,
    name                varchar(40) not null,
    phoneNumber         varchar(13),
    
    primary key(userid)
);

create table buyer(
	pk_userID          int not null auto_increment,
    
	primary key(pk_userID),
	foreign key(pk_userID) references users(userid)
);

create table seller(
	pk_userID          int not null auto_increment,
    
    primary key(pk_userId),
	foreign key(pk_userID) references users(userid)
);

-- Desabilita as verificações de Fks
set foreign_key_checks = 0;
-- Altera o tipo de dado da Fk da Tabela BankCard
alter table bankcard
modify pk_cardNumber char(19);
set foreign_key_checks = 1;

create table bankcard(
	pk_cardNumber               char(16) not null,
	expiryDate             		date not null,
    bank                  		varchar(20) not null,

	primary key(pk_cardNumber)
);

ALTER TABLE creditcard MODIFY pk_cardNumber char(19); 

create table creditCard(
	pk_cardNumber            char(16) not null,
	fk_userid                int not null,
	organization             varchar(50),
    
	primary key(pk_cardNumber),
	foreign key(fk_userid) references users(userid),
	foreign key(pk_cardNumber) references bankcard(pk_cardNumber)
);

ALTER TABLE debitcard MODIFY pk_cardNumber char(19); 
create table debitcard(
	pk_cardNumber        char(16) not null,
	fk_userid            int not null,
    
	primary key(pk_cardNumber),
	foreign key(fk_userid) references users(userid),
	foreign key(pk_cardNumber) references bankcard(pk_cardNumber)
);

alter table store modify startTime date;
create table store(
	pk_sid                 int not null,
    name                   varchar(50) not null,
    province               varchar(35) not null,
    city                   varchar(40) not null,
    streetaddr             varchar(80),
    customerGrade          int,
    startTime              time,
    
    primary key(pk_sid)
);

create table Brand(
	pk_brandName          varchar(50) NOT NULL,
    
    primary key(pk_brandName)
);

alter table product modify modelNumber varchar(20);
create table Product(
	pk_pid           	 int not null,
    fk_sid            	 int not null,
	fk_brandName         varchar(50) not null,
    name              	 varchar(120) not null,
    type                 varchar(50) not null,
	modelNumber          varchar(11) not null unique,
	color                varchar(20) not null,
    amount               int default NULL,
    price                decimal(6,2) not null,
    
    primary key(pk_pid),
    foreign key(fk_sid) references store(pk_sid),
    foreign key(fk_brandName) references brand(pk_brandName)
);

alter table orderitem modify creationTime date;
create table OrderItem(
	pk_ItemID           int not null auto_increment,
    fk_pid              int not null,
    price               decimal(6,2),
    creationTime        time not null,
    
    primary key(pk_itemID),
    foreign key(fk_pid) references product(pk_pid)
);

alter table orders modify creationTime date;
create table Orders(
	pk_orderNumber      int not null,
    paymentstatus       enum('Paid', 'Unpaid'),
    creationTime        time not null,
    totalAmount         decimal(10,2) not null,
    
    primary key(pk_orderNumber)
);

create table address(
	pk_addrID                int not null,
    fk_userID                int not null,
    name                     varchar(50) not null,
    contactPhoneNumber       varchar(13) not null,
    province                 varchar(100) not null,
    city                     varchar(100) not null,
    streetaddr               varchar(100) not null,
    postCode                 varchar(7) not null,
    
    primary key(pk_addrID),
    foreign key(fk_userID) references users(userid)
);

create table Comments(    -- Entidade Fraca
	 creationTime              date not null,
     fk_userID                 int not null,
     fk_pid                    int not null,
     grade                     float,
     content                   varchar(500),
     
     primary key(creationTime,fk_userID,fk_pid),
     foreign key(fk_userID) references users(userid),
     foreign key(fk_pid) references product(pk_pid)
);

create table ServicePoint(
	pk_spid                int not null,
    streetaddr             varchar(100) not null,
    city                   varchar(50),
    province               varchar(50),
    startime               varchar(20),
    endtime                varchar(20),
    
    primary key(pk_spid)
);

create table Save_to_Shopping_Cart(
	fk_userID             int not null,
    fk_pid                int not null,
    addTime               date,
    quantity              int,
    
    primary key(fk_userID,fk_pid),
    foreign key(fk_userID) references users(userid),
    foreign key(fk_pid) references product(pk_pid)
);

create table Contain(
	fk_orderNumber           int not null,
    fk_itemID                int not null,
    quantity                 int,
    
    primary key(fk_orderNumber,fk_itemID),
    foreign key(fk_orderNumber) references orders(pk_orderNumber),
    foreign key(fk_itemID) references orderItem(pk_ItemID)
);

create table Payment(
	fk_orderNumber            int not null,
	fk_creditcardNumber       varchar(25) not null,
	payTime                   date not null,
        
    primary key(fk_orderNumber,fk_creditcardNumber),    
    foreign key(fk_orderNumber) references orders(pk_orderNumber),
    foreign key(fk_creditcardNumber) references bankCard(pk_cardNumber)
);

create table deliver_to(
	fk_addrID             int not null,
    fk_orderNumber        int not null,
    TimeDelivered         date,
    
    primary key(fk_addrID,fk_orderNumber),
    foreign key(fk_addrID) references address(pk_addrID),
	foreign key(fk_orderNumber) references orders(pk_orderNumber)
);

create table Manage(
    fk_userid              int not null,
    fk_sid                 int not null,
    setUpTime              date,
    
    primary key(fk_userid,fk_sid),
    foreign key(fk_userid) references seller(pk_userid),
    foreign key(fk_sid) references store (pk_sid)
);

create table After_Sales_Service_At(
    fk_brandName         varchar(20) not null,
    fk_spid              int not null,
    
    primary key(fk_brandName, fk_spid),
    foreign key(fk_brandName) references Brand(pk_brandName),
    foreign key(fk_spid) references servicePoint(pk_spid)
);