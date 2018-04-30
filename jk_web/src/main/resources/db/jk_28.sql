prompt PL/SQL Developer import file
prompt Created on 2018年2月17日 by LR-PC
set feedback off
set define off
prompt Creating CONTRACT_C...
create table CONTRACT_C
(
  CONTRACT_ID     VARCHAR2(40) not null,
  OFFEROR         VARCHAR2(200),
  CONTRACT_NO     VARCHAR2(50),
  SIGNING_DATE    DATE,
  INPUT_BY        VARCHAR2(30),
  CHECK_BY        VARCHAR2(30),
  INSPECTOR       VARCHAR2(30),
  TOTAL_AMOUNT    NUMBER(10,2),
  CREQUEST        VARCHAR2(2000),
  CUSTOM_NAME     VARCHAR2(200),
  SHIP_TIME       TIMESTAMP(6) default systimestamp not null,
  IMPORT_NUM      NUMBER(11),
  DELIVERY_PERIOD TIMESTAMP(6) not null,
  OLD_STATE       NUMBER(11),
  OUT_STATE       NUMBER(11),
  TRADE_TERMS     VARCHAR2(30),
  PRINT_STYLE     CHAR(1),
  REMARK          VARCHAR2(600),
  STATE           NUMBER(11),
  CREATE_BY       VARCHAR2(40),
  CREATE_DEPT     VARCHAR2(40),
  CREATE_TIME     TIMESTAMP(6) default systimestamp not null,
  UPDATE_BY       VARCHAR2(40),
  UPDATE_TIME     TIMESTAMP(6) default systimestamp not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column CONTRACT_C.IMPORT_NUM
  is '打印时标识几个星,对应说明中的内容\r\n            不能存储特殊字符星星，jstl判断失效';
comment on column CONTRACT_C.OLD_STATE
  is '归档前状态, 方便回退';
comment on column CONTRACT_C.OUT_STATE
  is '0未走货 1部分 2全部\r\n            \r\n            归档后, 其他选择合同的地方均去除.\r\n            表示合同已完成, 不论是否合同的货物是否全部真的走完, 因为有赔付等其他情况';
comment on column CONTRACT_C.PRINT_STYLE
  is '宽2:一页两个货物  窄1:一页一个货物';
comment on column CONTRACT_C.STATE
  is '0草稿 1已上报待报运\r\n            \r\n            归档后, 其他选择合同的地方均去除.\r\n            表示合同已完成, 不论是否合同的货物是否全部真的走完, 因为有赔付等其他情况';
alter table CONTRACT_C
  add primary key (CONTRACT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating FACTORY_C...
create table FACTORY_C
(
  FACTORY_ID   VARCHAR2(40) not null,
  CTYPE        VARCHAR2(10),
  FULL_NAME    VARCHAR2(200),
  FACTORY_NAME VARCHAR2(50),
  CONTACTS     VARCHAR2(30),
  PHONE        VARCHAR2(20),
  MOBILE       VARCHAR2(20),
  FAX          VARCHAR2(20),
  ADDRESS      VARCHAR2(200),
  INSPECTOR    VARCHAR2(30),
  REMARK       VARCHAR2(2000),
  ORDER_NO     NUMBER(11),
  STATE        CHAR(1),
  CREATE_BY    VARCHAR2(40),
  CREATE_DEPT  VARCHAR2(40),
  CREATE_TIME  TIMESTAMP(6) default systimestamp not null,
  UPDATE_BY    VARCHAR2(40),
  UPDATE_TIME  TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column FACTORY_C.CTYPE
  is '货物/附件';
comment on column FACTORY_C.STATE
  is '1正常0停用';
alter table FACTORY_C
  add primary key (FACTORY_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating CONTRACT_PRODUCT_C...
create table CONTRACT_PRODUCT_C
(
  CONTRACT_PRODUCT_ID VARCHAR2(40) not null,
  CONTRACT_ID         VARCHAR2(40),
  FACTORY_ID          VARCHAR2(40),
  FACTORY_NAME        VARCHAR2(200),
  PRODUCT_NO          VARCHAR2(50),
  PRODUCT_IMAGE       VARCHAR2(200),
  PRODUCT_DESC        VARCHAR2(600),
  LOADING_RATE        VARCHAR2(80),
  BOX_NUM             NUMBER(11),
  PACKING_UNIT        VARCHAR2(10),
  CNUMBER             NUMBER(11),
  OUT_NUMBER          NUMBER(11),
  FINISHED            NUMBER(11),
  PRODUCT_REQUEST     VARCHAR2(2000),
  PRICE               NUMBER(10,2),
  AMOUNT              NUMBER(10,2),
  ORDER_NO            NUMBER(11)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column CONTRACT_PRODUCT_C.FACTORY_NAME
  is '冗余';
comment on column CONTRACT_PRODUCT_C.LOADING_RATE
  is '报运：x/y';
comment on column CONTRACT_PRODUCT_C.BOX_NUM
  is '报运';
comment on column CONTRACT_PRODUCT_C.PACKING_UNIT
  is 'PCS/SETS';
comment on column CONTRACT_PRODUCT_C.OUT_NUMBER
  is '报运';
comment on column CONTRACT_PRODUCT_C.FINISHED
  is '报运';
comment on column CONTRACT_PRODUCT_C.AMOUNT
  is '自动计算: 数量x单价';
alter table CONTRACT_PRODUCT_C
  add primary key (CONTRACT_PRODUCT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table CONTRACT_PRODUCT_C
  add foreign key (CONTRACT_ID)
  references CONTRACT_C (CONTRACT_ID) on delete cascade;
alter table CONTRACT_PRODUCT_C
  add foreign key (FACTORY_ID)
  references FACTORY_C (FACTORY_ID) on delete cascade;

prompt Creating DEPT_P...
create table DEPT_P
(
  DEPT_ID   VARCHAR2(40) not null,
  DEPT_NAME VARCHAR2(40),
  PARENT_ID VARCHAR2(40),
  STATE     NUMBER(11)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column DEPT_P.STATE
  is '1代表启用，0代表停用，默认为1';
alter table DEPT_P
  add primary key (DEPT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DEPT_P
  add foreign key (PARENT_ID)
  references DEPT_P (DEPT_ID) on delete cascade;

prompt Creating DICT_P...
create table DICT_P
(
  DICT_ID     VARCHAR2(50) not null,
  DESCRIPTION VARCHAR2(50),
  DICTYPE     VARCHAR2(50),
  NAME        VARCHAR2(50),
  VAL         VARCHAR2(50)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DICT_P
  add constraint SGDFFG primary key (DICT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating MODULE_P...
create table MODULE_P
(
  MODULE_ID   VARCHAR2(40) not null,
  PARENT_ID   VARCHAR2(40),
  PARENT_NAME VARCHAR2(100),
  NAME        VARCHAR2(100),
  LAYER_NUM   NUMBER(11),
  IS_LEAF     NUMBER(11),
  ICO         VARCHAR2(20),
  CPERMISSION VARCHAR2(20),
  CURL        VARCHAR2(200),
  CTYPE       NUMBER(11),
  STATE       NUMBER(11),
  BELONG      VARCHAR2(100),
  CWHICH      VARCHAR2(20),
  QUOTE_NUM   NUMBER(11),
  REMARK      VARCHAR2(100),
  ORDER_NO    NUMBER(11),
  CREATE_BY   VARCHAR2(40),
  CREATE_DEPT VARCHAR2(40),
  CREATE_TIME TIMESTAMP(6) default systimestamp not null,
  UPDATE_BY   VARCHAR2(40),
  UPDATE_TIME TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column MODULE_P.CTYPE
  is '1主菜单/2左侧菜单/3按钮/4链接/5状态';
comment on column MODULE_P.STATE
  is '1启用0停用';
comment on column MODULE_P.BELONG
  is '按钮时，可以标识其归属，\n            查询某页面按钮时就用此属性查询';
alter table MODULE_P
  add primary key (MODULE_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating ROLE_P...
create table ROLE_P
(
  ROLE_ID     VARCHAR2(40) not null,
  NAME        VARCHAR2(30),
  REMARK      VARCHAR2(200),
  ORDER_NO    NUMBER(11),
  CREATE_BY   VARCHAR2(40),
  CREATE_DEPT VARCHAR2(40),
  CREATE_TIME TIMESTAMP(6) default systimestamp not null,
  UPDATE_BY   VARCHAR2(40),
  UPDATE_TIME TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ROLE_P
  add primary key (ROLE_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating DICT_MODULE_P...
create table DICT_MODULE_P
(
  MODULE_ID VARCHAR2(255) not null,
  DICT_ID   VARCHAR2(255) not null,
  ROLE_ID   VARCHAR2(255) not null,
  TID       VARCHAR2(255) not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DICT_MODULE_P
  add constraint SSDFERKOPPKL primary key (TID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table DICT_MODULE_P
  add constraint SSDDD foreign key (MODULE_ID)
  references MODULE_P (MODULE_ID) on delete cascade;
alter table DICT_MODULE_P
  add constraint SSDFHSDG foreign key (DICT_ID)
  references DICT_P (DICT_ID) on delete cascade;
alter table DICT_MODULE_P
  add constraint SSDGRGSE foreign key (ROLE_ID)
  references ROLE_P (ROLE_ID) on delete cascade;

prompt Creating EXPORT_C...
create table EXPORT_C
(
  EXPORT_ID         VARCHAR2(40) not null,
  INPUT_DATE        DATE,
  CONTRACT_IDS      VARCHAR2(200),
  CUSTOMER_CONTRACT VARCHAR2(200),
  LCNO              VARCHAR2(10),
  CONSIGNEE         VARCHAR2(100),
  MARKS             VARCHAR2(1000),
  SHIPMENT_PORT     VARCHAR2(100),
  DESTINATION_PORT  VARCHAR2(100),
  TRANSPORT_MODE    VARCHAR2(10),
  PRICE_CONDITION   VARCHAR2(10),
  REMARK            VARCHAR2(100),
  BOX_NUMS          NUMBER(11),
  GROSS_WEIGHTS     NUMBER(10,2),
  MEASUREMENTS      NUMBER(10,2),
  STATE             NUMBER(11),
  CREATE_BY         VARCHAR2(40),
  CREATE_DEPT       VARCHAR2(40),
  CREATE_TIME       DATE
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column EXPORT_C.CONTRACT_IDS
  is 'ID集合串\n            \n            x,y,z';
comment on column EXPORT_C.CUSTOMER_CONTRACT
  is '客户的合同号,可选择多个合同';
comment on column EXPORT_C.LCNO
  is 'L/C T/T';
comment on column EXPORT_C.TRANSPORT_MODE
  is 'SEA/AIR';
comment on column EXPORT_C.PRICE_CONDITION
  is 'FBO/CIF';
comment on column EXPORT_C.BOX_NUMS
  is '冗余，为委托服务，一个报运的总箱数';
comment on column EXPORT_C.GROSS_WEIGHTS
  is '冗余，为委托服务，一个报运的总毛重';
comment on column EXPORT_C.MEASUREMENTS
  is '冗余，为委托服务，一个报运的总体积\n            \n            =长x高x宽/100 00 00\n            \n

       cm转

换为m3 立方米\n            ';
comment on column EXPORT_C.STATE
  is '0-草稿 1-已上报 2-装箱 3-委托 4-发票 5-财务';
alter table EXPORT_C
  add primary key (EXPORT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating EXPORT_PRODUCT_C...
create table EXPORT_PRODUCT_C
(
  EXPORT_PRODUCT_ID VARCHAR2(40) not null,
  EXPORT_ID         VARCHAR2(40),
  FACTORY_ID        VARCHAR2(40),
  PRODUCT_NO        VARCHAR2(50),
  PACKING_UNIT      VARCHAR2(10),
  CNUMBER           NUMBER(11),
  BOX_NUM           NUMBER(11),
  GROSS_WEIGHT      NUMBER(10,2),
  NET_WEIGHT        NUMBER(10,2),
  SIZE_LENGTH       NUMBER(10,2),
  SIZE_WIDTH        NUMBER(10,2),
  SIZE_HEIGHT       NUMBER(10,2),
  EX_PRICE          NUMBER(10,2),
  PRICE             NUMBER(10,2),
  TAX               NUMBER(10,2),
  ORDER_NO          NUMBER(11)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column EXPORT_PRODUCT_C.PACKING_UNIT
  is 'PCS/SETS';
comment on column EXPORT_PRODUCT_C.EX_PRICE
  is 'sales confirmation 中的价格（手填）';
comment on column EXPORT_PRODUCT_C.TAX
  is '收购单价=合同单价';
alter table EXPORT_PRODUCT_C
  add primary key (EXPORT_PRODUCT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table EXPORT_PRODUCT_C
  add foreign key (EXPORT_ID)
  references EXPORT_C (EXPORT_ID) on delete cascade;
alter table EXPORT_PRODUCT_C
  add foreign key (FACTORY_ID)
  references FACTORY_C (FACTORY_ID) on delete cascade;

prompt Creating EXT_CPRODUCT_C...
create table EXT_CPRODUCT_C
(
  EXT_CPRODUCT_ID     VARCHAR2(40) not null,
  CONTRACT_PRODUCT_ID VARCHAR2(40),
  FACTORY_ID          VARCHAR2(40),
  FACTORY_NAME        VARCHAR2(200),
  PRODUCT_NO          VARCHAR2(50),
  PRODUCT_IMAGE       VARCHAR2(200),
  PRODUCT_DESC        VARCHAR2(600),
  PACKING_UNIT        VARCHAR2(10),
  CNUMBER             NUMBER(11),
  PRICE               NUMBER(10,2),
  AMOUNT              NUMBER(10,2),
  PRODUCT_REQUEST     VARCHAR2(2000),
  ORDER_NO            NUMBER(11)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column EXT_CPRODUCT_C.PACKING_UNIT
  is 'PCS/SETS';
comment on column EXT_CPRODUCT_C.AMOUNT
  is '自动计算: 数量x单价';
alter table EXT_CPRODUCT_C
  add primary key (EXT_CPRODUCT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table EXT_CPRODUCT_C
  add foreign key (CONTRACT_PRODUCT_ID)
  references CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID) on delete cascade;
alter table EXT_CPRODUCT_C
  add foreign key (FACTORY_ID)
  references FACTORY_C (FACTORY_ID) on delete cascade;

prompt Creating EXT_EPRODUCT_C...
create table EXT_EPRODUCT_C
(
  EXT_EPRODUCT_ID   VARCHAR2(40) not null,
  FACTORY_ID        VARCHAR2(40),
  EXPORT_PRODUCT_ID VARCHAR2(40),
  PRODUCT_NO        VARCHAR2(50),
  PRODUCT_IMAGE     VARCHAR2(200),
  PRODUCT_DESC      VARCHAR2(600),
  CNUMBER           NUMBER(11),
  PACKING_UNIT      VARCHAR2(10),
  PRICE             NUMBER(10,2),
  AMOUNT            NUMBER(10,2),
  PRODUCT_REQUEST   VARCHAR2(2000),
  ORDER_NO          NUMBER(11)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column EXT_EPRODUCT_C.PACKING_UNIT
  is 'PCS/SETS';
comment on column EXT_EPRODUCT_C.AMOUNT
  is '自动计算: 数量x单价';
alter table EXT_EPRODUCT_C
  add primary key (EXT_EPRODUCT_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table EXT_EPRODUCT_C
  add foreign key (FACTORY_ID)
  references FACTORY_C (FACTORY_ID) on delete cascade;
alter table EXT_EPRODUCT_C
  add foreign key (EXPORT_PRODUCT_ID)
  references EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID) on delete cascade;

prompt Creating LOGIN_LOG_P...
create table LOGIN_LOG_P
(
  LOGIN_LOG_ID VARCHAR2(40) not null,
  LOGIN_NAME   VARCHAR2(30),
  IP_ADDRESS   VARCHAR2(20),
  LOGIN_TIME   DATE
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table LOGIN_LOG_P
  add primary key (LOGIN_LOG_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating MODULE_DICT_P...
create table MODULE_DICT_P
(
  DICT_ID   VARCHAR2(50),
  MODULE_ID VARCHAR2(50)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    minextents 1
    maxextents unlimited
  );
alter table MODULE_DICT_P
  add constraint GYTHSD foreign key (DICT_ID)
  references DICT_P (DICT_ID);

prompt Creating ONLINE_INFO_T...
create table ONLINE_INFO_T
(
  A1 CHAR(2)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating PACKING_LIST_C...
create table PACKING_LIST_C
(
  PACKING_LIST_ID VARCHAR2(40) not null,
  SELLER          VARCHAR2(200),
  BUYER           VARCHAR2(200),
  INVOICE_NO      VARCHAR2(30),
  INVOICE_DATE    DATE,
  MARKS           VARCHAR2(200),
  DESCRIPTIONS    VARCHAR2(200),
  EXPORT_IDS      VARCHAR2(200),
  EXPORT_NOS      VARCHAR2(200),
  STATE           NUMBER(11),
  CREATE_BY       VARCHAR2(40),
  CREATE_DEPT     VARCHAR2(40),
  CREATE_TIME     DATE
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column PACKING_LIST_C.INVOICE_NO
  is '选择';
comment on column PACKING_LIST_C.EXPORT_IDS
  is '报运ID集合';
comment on column PACKING_LIST_C.EXPORT_NOS
  is '报运NO集合x,y|z,h';
comment on column PACKING_LIST_C.STATE
  is '0草稿 1已上报';
alter table PACKING_LIST_C
  add primary key (PACKING_LIST_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );

prompt Creating ROLE_MODULE_P...
create table ROLE_MODULE_P
(
  ROLE_ID   VARCHAR2(255) not null,
  MODULE_ID VARCHAR2(255) not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ROLE_MODULE_P
  add primary key (ROLE_ID, MODULE_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ROLE_MODULE_P
  add foreign key (MODULE_ID)
  references MODULE_P (MODULE_ID) on delete cascade;

prompt Creating USER_P...
create table USER_P
(
  USER_ID     VARCHAR2(40) not null,
  DEPT_ID     VARCHAR2(40),
  USER_NAME   VARCHAR2(50),
  PASSWORD    VARCHAR2(64),
  STATE       NUMBER(11),
  CREATE_BY   VARCHAR2(40),
  CREATE_DEPT VARCHAR2(40),
  CREATE_TIME TIMESTAMP(6) default systimestamp not null,
  UPDATE_BY   VARCHAR2(40),
  UPDATE_TIME TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column USER_P.USER_NAME
  is '不能重复,可为中文';
comment on column USER_P.PASSWORD
  is 'shiro MD5密码32位';
comment on column USER_P.STATE
  is '1启用0停用';
comment on column USER_P.CREATE_BY
  is '登录人编号';
comment on column USER_P.CREATE_DEPT
  is '登录人所属部门编号';
alter table USER_P
  add primary key (USER_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table USER_P
  add foreign key (DEPT_ID)
  references DEPT_P (DEPT_ID) on delete cascade;

prompt Creating ROLE_USER_P...
create table ROLE_USER_P
(
  USER_ID VARCHAR2(255) not null,
  ROLE_ID VARCHAR2(255) not null
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ROLE_USER_P
  add primary key (ROLE_ID, USER_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table ROLE_USER_P
  add foreign key (USER_ID)
  references USER_P (USER_ID) on delete cascade;

prompt Creating USER_INFO_P...
create table USER_INFO_P
(
  USER_INFO_ID VARCHAR2(40) not null,
  NAME         VARCHAR2(20),
  MANAGER_ID   VARCHAR2(40),
  JOIN_DATE    TIMESTAMP(6) default systimestamp not null,
  SALARY       NUMBER(8,2),
  BIRTHDAY     TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null,
  GENDER       CHAR(1),
  STATION      VARCHAR2(20),
  TELEPHONE    VARCHAR2(100),
  DEGREE       NUMBER(11),
  REMARK       VARCHAR2(600),
  ORDER_NO     NUMBER(11),
  CREATE_BY    VARCHAR2(40),
  CREATE_DEPT  VARCHAR2(40),
  CREATE_TIME  TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null,
  UPDATE_BY    VARCHAR2(40),
  UPDATE_TIME  TIMESTAMP(6) default to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss') not null,
  EMAIL        VARCHAR2(30)
)
tablespace HEIMA
  pctfree 10
  initrans 1
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
comment on column USER_INFO_P.DEGREE
  is '0-超级管理员\n            1-跨部门跨人员\n            2-管理所有下属部门和人员\n            3-管理本部门\n            4-普通员工\n            \n            \n            0作为内部控制只对sysdebug，用户不能进行添加';
comment on column USER_INFO_P.CREATE_BY
  is '登录人编号';
comment on column USER_INFO_P.CREATE_DEPT
  is '登录人所属部门编号';
alter table USER_INFO_P
  add primary key (USER_INFO_ID)
  using index 
  tablespace HEIMA
  pctfree 10
  initrans 2
  maxtrans 255
  storage
  (
    initial 64K
    next 1M
    minextents 1
    maxextents unlimited
  );
alter table USER_INFO_P
  add foreign key (MANAGER_ID)
  references USER_P (USER_ID) on delete cascade;

prompt Disabling triggers for CONTRACT_C...
alter table CONTRACT_C disable all triggers;
prompt Disabling triggers for FACTORY_C...
alter table FACTORY_C disable all triggers;
prompt Disabling triggers for CONTRACT_PRODUCT_C...
alter table CONTRACT_PRODUCT_C disable all triggers;
prompt Disabling triggers for DEPT_P...
alter table DEPT_P disable all triggers;
prompt Disabling triggers for DICT_P...
alter table DICT_P disable all triggers;
prompt Disabling triggers for MODULE_P...
alter table MODULE_P disable all triggers;
prompt Disabling triggers for ROLE_P...
alter table ROLE_P disable all triggers;
prompt Disabling triggers for DICT_MODULE_P...
alter table DICT_MODULE_P disable all triggers;
prompt Disabling triggers for EXPORT_C...
alter table EXPORT_C disable all triggers;
prompt Disabling triggers for EXPORT_PRODUCT_C...
alter table EXPORT_PRODUCT_C disable all triggers;
prompt Disabling triggers for EXT_CPRODUCT_C...
alter table EXT_CPRODUCT_C disable all triggers;
prompt Disabling triggers for EXT_EPRODUCT_C...
alter table EXT_EPRODUCT_C disable all triggers;
prompt Disabling triggers for LOGIN_LOG_P...
alter table LOGIN_LOG_P disable all triggers;
prompt Disabling triggers for MODULE_DICT_P...
alter table MODULE_DICT_P disable all triggers;
prompt Disabling triggers for ONLINE_INFO_T...
alter table ONLINE_INFO_T disable all triggers;
prompt Disabling triggers for PACKING_LIST_C...
alter table PACKING_LIST_C disable all triggers;
prompt Disabling triggers for ROLE_MODULE_P...
alter table ROLE_MODULE_P disable all triggers;
prompt Disabling triggers for USER_P...
alter table USER_P disable all triggers;
prompt Disabling triggers for ROLE_USER_P...
alter table ROLE_USER_P disable all triggers;
prompt Disabling triggers for USER_INFO_P...
alter table USER_INFO_P disable all triggers;
prompt Disabling foreign key constraints for CONTRACT_PRODUCT_C...
alter table CONTRACT_PRODUCT_C disable constraint SYS_C0011368;
alter table CONTRACT_PRODUCT_C disable constraint SYS_C0011369;
prompt Disabling foreign key constraints for DEPT_P...
alter table DEPT_P disable constraint SYS_C0011372;
prompt Disabling foreign key constraints for DICT_MODULE_P...
alter table DICT_MODULE_P disable constraint SSDDD;
alter table DICT_MODULE_P disable constraint SSDFHSDG;
alter table DICT_MODULE_P disable constraint SSDGRGSE;
prompt Disabling foreign key constraints for EXPORT_PRODUCT_C...
alter table EXPORT_PRODUCT_C disable constraint SYS_C0011377;
alter table EXPORT_PRODUCT_C disable constraint SYS_C0011378;
prompt Disabling foreign key constraints for EXT_CPRODUCT_C...
alter table EXT_CPRODUCT_C disable constraint SYS_C0011381;
alter table EXT_CPRODUCT_C disable constraint SYS_C0011382;
prompt Disabling foreign key constraints for EXT_EPRODUCT_C...
alter table EXT_EPRODUCT_C disable constraint SYS_C0011385;
alter table EXT_EPRODUCT_C disable constraint SYS_C0011386;
prompt Disabling foreign key constraints for MODULE_DICT_P...
alter table MODULE_DICT_P disable constraint GYTHSD;
prompt Disabling foreign key constraints for ROLE_MODULE_P...
alter table ROLE_MODULE_P disable constraint SYS_C0011398;
prompt Disabling foreign key constraints for USER_P...
alter table USER_P disable constraint SYS_C0011407;
prompt Disabling foreign key constraints for ROLE_USER_P...
alter table ROLE_USER_P disable constraint SYS_C0011411;
prompt Disabling foreign key constraints for USER_INFO_P...
alter table USER_INFO_P disable constraint SYS_C0011418;
prompt Deleting USER_INFO_P...
delete from USER_INFO_P;
commit;
prompt Deleting ROLE_USER_P...
delete from ROLE_USER_P;
commit;
prompt Deleting USER_P...
delete from USER_P;
commit;
prompt Deleting ROLE_MODULE_P...
delete from ROLE_MODULE_P;
commit;
prompt Deleting PACKING_LIST_C...
delete from PACKING_LIST_C;
commit;
prompt Deleting ONLINE_INFO_T...
delete from ONLINE_INFO_T;
commit;
prompt Deleting MODULE_DICT_P...
delete from MODULE_DICT_P;
commit;
prompt Deleting LOGIN_LOG_P...
delete from LOGIN_LOG_P;
commit;
prompt Deleting EXT_EPRODUCT_C...
delete from EXT_EPRODUCT_C;
commit;
prompt Deleting EXT_CPRODUCT_C...
delete from EXT_CPRODUCT_C;
commit;
prompt Deleting EXPORT_PRODUCT_C...
delete from EXPORT_PRODUCT_C;
commit;
prompt Deleting EXPORT_C...
delete from EXPORT_C;
commit;
prompt Deleting DICT_MODULE_P...
delete from DICT_MODULE_P;
commit;
prompt Deleting ROLE_P...
delete from ROLE_P;
commit;
prompt Deleting MODULE_P...
delete from MODULE_P;
commit;
prompt Deleting DICT_P...
delete from DICT_P;
commit;
prompt Deleting DEPT_P...
delete from DEPT_P;
commit;
prompt Deleting CONTRACT_PRODUCT_C...
delete from CONTRACT_PRODUCT_C;
commit;
prompt Deleting FACTORY_C...
delete from FACTORY_C;
commit;
prompt Deleting CONTRACT_C...
delete from CONTRACT_C;
commit;
prompt Loading CONTRACT_C...
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3357462e0133591b86ec0002', '陕西杰信商务发展有限公司', 'C/3817/11', to_date('31-10-2011', 'dd-mm-yyyy'), '杨丽', null, '吕晓波', 10800, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月15日/工厂,没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'BEAKIE LEE', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 1, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 2, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3357462e01336cc0877b0010', '陕西杰信商务发展有限公司', '11JK1080', to_date('04-11-2011', 'dd-mm-yyyy'), '杨丽', null, '吕晓波', 2318.4, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月10日/工厂。毛坯送至祁县瑞成玻璃镀膜厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('10-12-2011 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '1', '待样品确认后方可安排生产', 2, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3357462e01336d3a0be10014', '陕西杰信商务发展有限公司', '11JK1078', to_date('04-11-2011', 'dd-mm-yyyy'), '杨丽', null, '李春光', 54120, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年11月15日/工厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('15-11-2011 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 2, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3357462e01336d523195001a', '陕西杰信商务发展有限公司', 'C/3847/11', to_date('02-12-2011', 'dd-mm-yyyy'), '杨丽', null, '李春光', 39240, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。\r\n 交期：2011年12月15日/工厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'HOME', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 2, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33812ffd0133813f25940001', '陕西杰信商务发展有限公司', 'C/3861/11', to_date('08-11-2011', 'dd-mm-yyyy'), '杨丽', null, '吕晓波', 165378, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 包装：产品用白纸，瓦楞纸，气泡纸包裹后入内盒，大箱，大箱用胶带纸工字封口；\r\n 交期：2012年1月10日/工厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'HOME', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('10-01-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33812ffd013382048ff80024', '陕西杰信商务发展有限公司', '11JK1082', to_date('08-11-2011', 'dd-mm-yyyy'), '杨丽', null, '李春光', 40200, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 包装：产品用白纸，瓦楞纸，气泡纸包裹后入内盒，大箱，大箱用胶带纸工字封口；\r\n 交期：2011年12月30日/工厂。  \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'MSA', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('30-12-2011 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33812ffd0133821a8eb5002b', '陕西杰信商务发展有限公司', '11JK1084', to_date('08-11-2011', 'dd-mm-yyyy'), '杨丽', null, '李春光', 10936, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月20日/工厂。毛坯送至祁县瑞成玻璃镀膜厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'ONE WORLD', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('20-12-2011 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33d4f8b40133d9878e88000d', '陕西杰信商务发展有限公司', '11JK1070', to_date('20-12-2011', 'dd-mm-yyyy'), '杨丽', null, null, 55789, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年11月5日/工厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('05-11-2011 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33d4f8b40133d991a50d0019', '陕西杰信商务发展有限公司', '11JK1066', to_date('25-11-2011', 'dd-mm-yyyy'), '杨丽', null, '李春光', 146184, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月5日/工厂。\r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('05-12-2011 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', '待样品确认后方可安排生产', 0, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33d4f8b40133d9bea39b002f', '陕西杰信商务发展有限公司', '11JK1060', to_date('25-11-2011', 'dd-mm-yyyy'), '杨丽', null, null, 152072, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生成前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月15日/工厂。\r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'COACH HOUSE', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 0, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('2c90c5004ad63735014ad6d16f2e0004', null, '合同号A', null, '制单人：', null, '验货员：', 0, null, '客户名称A', to_timestamp('11-01-2015 10:27:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('11-01-2015 10:27:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, '2e7c8ad9-1033-42fb-a0ad-6e491b73d274', 'aeb1c7d3-9a54-4f73-b0ec-0325b83aef45', to_timestamp('11-01-2015 10:27:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('11-01-2015 10:27:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('2c90c5004ad63735014ad6d204060005', null, '合同号：B', null, null, null, null, 0, null, '客户名称B', to_timestamp('11-01-2015 10:28:15.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('11-01-2015 10:28:15.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, 'e041f064-b115-4e19-b76e-b515d1fc1fa9', 'aeb1c7d3-9a54-4f73-b0ec-0325b83aef45', to_timestamp('11-01-2015 10:28:15.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('11-01-2015 10:28:15.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33fc4e280133fd81e7d7001d', '陕西杰信商务发展有限公司', '11JK1068', to_date('14-10-2011', 'dd-mm-yyyy'), '杨丽', null, null, 102711.8, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月15日/工厂。\r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'ELAD', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 0, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33fc4e280133fd9f8b4e002f', '陕西杰信商务发展有限公司', '11JK1072', to_date('20-12-2011', 'dd-mm-yyyy'), '杨丽', null, null, 99918, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月15日/工厂。\r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'BRISSI', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 1, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3420e78a013421a693730001', '陕西杰信商务发展有限公司', 'C/4040/11', to_date('09-12-2011', 'dd-mm-yyyy'), '杨丽', null, '李春光', 114640, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。\r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'HOME', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 1, to_timestamp('15-02-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, 2, null, null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a353b8d8e01353d15008d0046', '陕西杰信商务发展有限公司', 'C/4104/11', to_date('10-01-2015 19:55:08', 'dd-mm-yyyy hh24:mi:ss'), '杨丽', null, null, 37749, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。 \r\n       没有经过我司同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 'HOME', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, 'T/T', '2', null, 2, null, null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('402895c2515129200151514376b80002', 'F', 'F', to_date('10-01-2015 19:55:08', 'dd-mm-yyyy hh24:mi:ss'), 'F', 'F', 'F', 121, 'F', 'F', to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, 'F', '2', 'F', 0, null, null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:55:08.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('402899d65088203101508831e1e60000', '中华烟草集团', 'xx-01-xxx-02', to_date('10-01-2015 19:55:08', 'dd-mm-yyyy hh24:mi:ss'), '郭中华', '郭中华', '郭尔获', null, null, 'xx', to_timestamp('20-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('20-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, '2', null, null, null, null, to_timestamp('21-10-2015 10:19:41.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:19:41.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('402899d650885c420150885d95cb0000', 'J2302', 'J2302', to_date('21-10-2015 10:19:41', 'dd-mm-yyyy hh24:mi:ss'), 'J2302', 'J2302', 'J2302', 1000, 'J2302', 'J2302', to_timestamp('21-10-2015 10:19:41.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 10:19:41.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, 'FOB', '2', 'J2302', 0, '71a5a695-0ba5-4f0d-a0b5-0a304efde944', '4028827c4fb6202a014fb6209c730000', to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('402899d650885c420150885e918e0001', 'J24', 'J24', to_date('21-10-2015 11:07:25', 'dd-mm-yyyy hh24:mi:ss'), 'J24', 'J24', 'J24', 0, 'J24', 'J24', to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, 'T/T', '2', 'J24', 0, '424b2d01-d812-4f30-be40-dcda14110118', '4028827c4fb6202a014fb6209c730000', to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a9bd515b2e8201515b3339860000', 'C1', 'C1', to_date('21-10-2015 11:07:25', 'dd-mm-yyyy hh24:mi:ss'), 'C1', 'C1', 'C1', 100, 'C1', 'C1', to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, 'T/T', '2', 'C1', 0, '5758571d-93c6-48f0-9e67-20a442779531', '4028827c4fb645b0014fb64668550000', to_timestamp('01-12-2015 09:41:02.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into CONTRACT_C (CONTRACT_ID, OFFEROR, CONTRACT_NO, SIGNING_DATE, INPUT_BY, CHECK_BY, INSPECTOR, TOTAL_AMOUNT, CREQUEST, CUSTOM_NAME, SHIP_TIME, IMPORT_NUM, DELIVERY_PERIOD, OLD_STATE, OUT_STATE, TRADE_TERMS, PRINT_STYLE, REMARK, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a9bd515b3be301515b3d676f0000', 'D1', 'D1', to_date('21-10-2015 11:07:25', 'dd-mm-yyyy hh24:mi:ss'), 'D1', 'D1', 'D1', 0, 'D1', 'D1', to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, 'L/C', '2', 'D1', 1, '6f9f16c8-827b-4cc8-9e20-210aa82d1fcf', '4028827c4fb645b0014fb64668550000', to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 11:07:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
commit;
prompt 22 records loaded
prompt Loading FACTORY_C...
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('1', '货物', '祁县海洋厂', '升华', '刘生', '0354-5299987', null, null, null, '吕波', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('10', '货物', '祁县晶晨厂', '晶晨', '续贵', '0354-5271999', null, null, null, '吕波', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('12', '货物', '平遥远江厂', '平遥远江', '宏远', null, '13935499967', null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('13', '货物', '平遥鸿艺厂', '平遥鸿艺', '雄飞', '0354-5940888', null, null, null, '吕波', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('15', '货物', '南皮开发玻璃制品厂', '南皮开发', '舒东', '0317-8863999', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('16', '货物', '陕西康达彩印厂', '康达', '袁喜', '029-84528015', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('17', '货物', '陕西众鑫印务包装有限公司', '众鑫', '赵毅', '029-84341858', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('18', '货物', '翰林彩印厂', '翰林', '孙财', '029-88917456', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('19', '货物', '祁县综艺玻璃花纸厂', '综艺花纸', '王棕', '0354-5278918', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('2', '货物', '祁县光华厂', '光华', '薛成', '0354-5298981', null, null, null, '吕波', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('20', '货物', '祁县喜福来玻璃加工厂', '喜福来', '王卫', '0354-5328850', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('21', '货物', '祁县美晶泡沫厂', '美晶', '范长', '0354-5071387', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('22', '货物', '祁县瑞成玻璃镀膜厂', '瑞成', '温明', null, '13834809374', null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('3', '货物', '祁县会龙厂', '会龙', '李伟', '0354-5248696', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4', '货物', '祁县精艺厂', '精艺', '闫强', '0354-5047289', null, null, null, '高琴', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33d4f8b40133d9989f5e0024', '附件', '闻喜民鑫厂', '民鑫', '李民', '0359-7472727', null, null, null, '吕波', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33de41d80133e982a18a001c', '附件', '太谷四通PVC厂', '太谷PVC', '张海', '0354-6226591', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a33ecdbf70133ee202e49000b', '附件', '祁县瑞成电镀厂', '瑞成电镀厂', '温民', '13835926900', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a34f93be50134f9df84470001', '附件', '神舟玻璃制品有限公司', '神舟厂', '申定', '0356-3961959', '13935672348', '0356-3991304', null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a353b8d8e0135415bf0a90070', '附件', '陕西宇津进出口有限公司', '宇津水龙头厂', '任宁', '029-62990818', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a35e0895e0135ec7a4dbe0087', '附件', '西安方圆工贸有限公司', '西安方圆工贸', '许涛', '029-86539568', null, '029-86590565', null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3632e86601363344d16d0001', '附件', '淄博雷波陶瓷花纸厂', '淄博花纸厂', '吴璇', '0533-5176946', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a371a8d7f01372a74451f0068', '附件', '山西大德成工贸有限公司', '铁架厂', '高辉', '0354-5288919', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a37583d45013758d152450038', '附件', '祁县顺驰厂', '顺驰', '王明', '0354-5109398', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a38024a04013803e3a8a2004b', '附件', '祁县欣欣泡沫有限公司', '祁县欣欣泡沫厂', '许杰', '0354-3939793', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a382b4fd401382b9aad2a0008', '附件', '祁县仲玉玻璃厂', '仲玉', '吕军', '0354-5018888', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a38736298013874c51a800036', '附件', '汇融玻璃有限公司', '展鹏厂', '厂长', '0354-5326986', '13834893800', '0354-5826197', null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a389cc7b701389d1efd940001', '附件', '宇虹包装彩印厂', '宇虹包装厂', '翟帅', '0358-3099923', '19033470988', '0358-3098183', null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a39b2b37f0139b46268c40025', '附件', '祁县馨艺玻璃厂', '馨艺', '袁长', '0354-5041938', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3aa9f950013ab0b6c98d0050', '附件', '祁县一先厂', '一先厂', '李刚', '0654-9018444', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3aa9f950013ab97f64110053', '附件', '温县致远玻璃制品有限公司', '温县致远厂', '红升', '18936896666', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3abe8f15013ac019a61f0031', '附件', '祁县喜福来电镀厂', '喜福来电镀厂', '王卫', '0154-5282888', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028817a3ae2ac42013ae3550357000d', '附件', '临潼华清蜡厂', '临潼华清蜡厂', '吴波', '13791903888', null, null, null, null, null, null, '0', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('5', '货物', '祁县汇越厂', '汇越', '建忠', '0354-5019656', null, null, null, '吕波', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('6', '货物', '祁县泰宇厂', '泰宇', '立东', '0354-5299160', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('7', '货物', '祁县天顺厂', '天顺', '渠海', '0354-5299499', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('8', '货物', '祁县天诚厂', '天诚', '庞正', '0354-5299539', null, null, null, null, null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('9', '货物', '祁县华艺厂', '华艺', '史国', '0354-5041927', null, null, null, '高琴', null, null, '1', null, null, to_timestamp('10-01-2015 19:34:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into FACTORY_C (FACTORY_ID, CTYPE, FULL_NAME, FACTORY_NAME, CONTACTS, PHONE, MOBILE, FAX, ADDRESS, INSPECTOR, REMARK, ORDER_NO, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('ff808081301885760130189e47ca0013', '附件', '文水志远厂', '文水志远', '志远', '0358-3934083', null, null, null, '李光', null, null, '1', null, null, to_timestamp('10-01-2015 19:35:06.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('10-01-2015 19:32:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
commit;
prompt 39 records loaded
prompt Loading CONTRACT_PRODUCT_C...
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880014', '4028817a33d4f8b40133d9878e88000d', '2', '光华', 'JK169340/13076', null, 'undefined', '全明料蛋糕罩配盘子，罩子烤白花纸\r\n尺寸：25X26CM高\r', 1, 'PCS', 464, 464, 0, null, 36, 16704, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880015', '4028817a33d4f8b40133d9878e88000d', '2', '光华', 'JK1050316/12005', null, 'undefined', '全明料糖缸配盖子，糖缸刻交叉麦穗花\r\n尺寸：15X15CM高', 1, 'PCS', 162, 162, 0, null, 12.5, 2025, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880016', '4028817a33d4f8b40133d9878e88000d', '2', '光华', 'JK1050201/12078', null, 'undefined', '全明料蛋糕罩配盘子，罩子上烤花纸\r\n罩子尺寸：15X11.5', 1, 'PCS', 204, 204, 0, null, 18, 3672, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880017', '4028817a33d4f8b40133d9878e88000d', '1', '宏艺', 'JK1050154/11308', null, 'undefined', '全明料香槟杯，口部描1CM白金边\r\n尺寸：5X29CM高\r\n', 4, 'PCS', 704, 704, 0, null, 7.5, 5280, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880018', '4028817a33d4f8b40133d9878e88000d', '13', '平遥鸿艺', 'JK103136/11988', null, 'undefined', '全明料密直棱酒杯，底厚要求5MM\r\n尺寸：9X17.5CM高', 4, 'PCS', 928, 928, 0, null, 6.3, 5846.4, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d991a50d001a', '4028817a33d4f8b40133d991a50d0019', 'ff808081301885760130189e47ca0013', '文水志远', 'JK1040446/JK446', null, 'undefined', '全明料糖缸配盖子，普通底\r\n尺寸：16.5X50CM高\r\n1', 1, 'PCS', 600, 600, 0, null, 25, 15000, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d991a50d001b', '4028817a33d4f8b40133d991a50d0019', '2', '光华', 'JK1040364/JK364', null, 'undefined', '全明料糖缸配盖子\r\n尺寸：19X39CM高\r\n1只/上下保丽', 1, 'PCS', 600, 600, 0, null, 25, 15000, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d991a50d001d', '4028817a33d4f8b40133d991a50d0019', '1', '宏艺', 'JK1050166/JK166', null, 'undefined', '全明料糖缸，刻花不描亮油。\r\n尺寸：12.5X26.5CM高', 1, 'PCS', 600, 600, 0, null, 16, 9600, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d991a50d001e', '4028817a33d4f8b40133d991a50d0019', '4', '精艺', 'JK103694/JK694', null, 'undefined', '套6全明料死模低口杯\r\n尺寸：8X12.5CM高\r\n1套/白', 1, 'PCS', 480, 480, 0, null, 24, 11520, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d991a50d001f', '4028817a33d4f8b40133d991a50d0019', 'ff808081301885760130189e47ca0013', '文水志远', 'JK103956/JK956', null, 'undefined', '全明料蛋糕罩配盘子\r\n盘子我司安排\r\n罩子尺寸：33X14X', 1, 'PCS', 480, 480, 0, null, 27, 12960, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d991a50d0020', '4028817a33d4f8b40133d991a50d0019', '4', '精艺', 'JK103693/JK693', null, 'undefined', '套6全明料死模低口杯\r\n尺寸：7.3X10.5CM高\r\n1套', 1, 'PCS', 184, 184, 0, null, 21, 3864, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9be557b0029', '4028817a33d4f8b40133d991a50d0019', '9', '华艺', 'J859101549/JK549', null, null, '全明料蛋糕盘\r\n尺寸：直径33.5CM\r\n2只/五层内盒  ', 2, 'PCS', 1200, 1200, 0, null, 10, 12000, 12);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9be557b002a', '4028817a33d4f8b40133d991a50d0019', '4028817a33d4f8b40133d9989f5e0024', '民鑫', 'JK1060338/JK338', null, null, '全明料机压直棱糖缸\r\n尺寸：15.5X15.5CM 高\r\n1', 1, 'PCS', 2400, 2400, 0, null, 7.15, 17160, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9be557b002c', '4028817a33d4f8b40133d991a50d0019', '9', '华艺', 'JK1031007-LP/JK007/1', null, null, '全明料钻石蛋糕盘，粘底座\r\n尺寸：30X11.5CM高\r\n1', 1, 'PCS', 600, 600, 0, null, 10.5, 6300, 13);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9be557b002d', '4028817a33d4f8b40133d991a50d0019', '1', '宏艺', 'JK1050128/JK0128', null, null, '全明料三层糖缸，刻麦穗花\r\n尺寸：12X22.5CM\r\n1套', 1, 'PCS', 600, 600, 0, null, 18.5, 11100, 9);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9be557b002e', '4028817a33d4f8b40133d991a50d0019', '2', '光华', 'JK103176/JK176', null, null, '全明料糖缸，刻花，不带盖子\r\n尺寸：20X14.5CM高\r\n', 1, 'PCS', 480, 480, 0, null, 18.5, 8880, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0030', '4028817a33d4f8b40133d9bea39b002f', '1', '宏艺', 'JK1050806/JK032', null, 'undefined', '套6全明料香槟杯，电镀渐变色\r\n尺寸：5.7X25CM高\r\n', 1, 'PCS', 320, 320, 0, null, 31.8, 10176, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0031', '4028817a33d4f8b40133d9bea39b002f', '4', '精艺', 'JK045/JK1060426', null, 'undefined', '套6紫色碗明挺底香槟杯\r\n尺寸：8X17CM高\r\n1套/五层', 1, 'PCS', 240, 240, 0, null, 33.6, 8064, 9);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0032', '4028817a33d4f8b40133d9bea39b002f', '1', '宏艺', 'JK1050807/JK033', null, 'undefined', '套6全明料酒杯，电镀渐变色\r\n尺寸：8X24CM高\r\n1套/', 1, 'PCS', 300, 300, 0, null, 34.8, 10440, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0033', '4028817a33d4f8b40133d9bea39b002f', '4028817a33d4f8b40133d9989f5e0024', '民鑫', 'JK040/JK1060338', null, 'undefined', '全明料机压竖棱糖缸\r\n尺寸：15.5X15.5CM\r\n1只/', 1, 'PCS', 3000, 3000, 0, null, 8.04, 24120, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0034', '4028817a33d4f8b40133d9bea39b002f', '4', '精艺', 'JK044/JK1060425', null, 'undefined', '套6紫色碗明挺底红酒杯\r\n尺寸：8X20CM高\r\n1套/五层', 1, 'PCS', 240, 240, 0, null, 34.8, 8352, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0035', '4028817a33d4f8b40133d9bea39b002f', '1', '宏艺', 'JK019/J859100824', null, 'undefined', '套4全明料酒杯，口部描2.5CM宽白金边\r\n尺寸：8.4X2', 1, 'PCS', 320, 320, 0, null, 58, 18560, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0036', '4028817a33d4f8b40133d9bea39b002f', '1', '宏艺', 'JK018/J859100826', null, 'undefined', '套4全明料香槟杯，口部描2.5CM宽白金边\r\n尺寸：4.7X', 1, 'PCS', 300, 300, 0, null, 40, 12000, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0037', '4028817a33d4f8b40133d9bea39b002f', '3', '会龙', 'JK041/JK1060339', null, 'undefined', '全明料蒙古包糖缸\r\n尺寸：9X11CM高\r\n1只/五层内盒 ', 1, 'PCS', 3000, 3000, 0, null, 4, 12000, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9bea39b0038', '4028817a33d4f8b40133d9bea39b002f', '1', '宏艺', 'JK020/J859100825', null, 'undefined', '套4全明料马丁尼，口部描2.5CM白金边\r\n尺寸：11.8X', 1, 'PCS', 300, 300, 0, null, 70, 21000, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33f7960d0133f8d912ba0005', '4028817a33812ffd0133821a8eb5002b', '9', '华艺', 'JK110102', null, null, '全明料钻石盘子\r\n盘子尺寸：29.5X11.5CM\r\n安全包', 1, 'PCS', 150, 150, 0, null, 10, 1500, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33f7960d0133f8d912ba0006', '4028817a33812ffd0133821a8eb5002b', '9', '华艺', 'JK110101', null, null, '全明料钻石盘子\r\n盘子尺寸：23X11.5CM\r\n安全包装送', 1, 'PCS', 152, 152, 0, null, 8.5, 1292, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fcdb13f4000e', '4028817a33d4f8b40133d9bea39b002f', '1', '宏艺', 'JK052/JK1070691', null, null, '套4全明料马丁尼\r\n尺寸：12.5X19.5CM高\r\n1套/', 1, 'PCS', 300, 300, 0, null, 30, 9000, 12);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fcdb13f4000f', '4028817a33d4f8b40133d9bea39b002f', '5', '汇越', 'JK050/JK1070690', null, null, '套4全明料白酒杯，钻石挺\r\n尺寸：8.6X23CM高\r\n1套', 1, 'PCS', 300, 300, 0, null, 23.2, 6960, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fcdb13f40010', '4028817a33d4f8b40133d9bea39b002f', '2', '光华', 'JK046/JK1050201', null, null, '全明料蛋糕盘+罩子\r\n罩子上烤蒙砂白花纸\r\n距口部1CM处，', 1, 'PCS', 600, 600, 0, null, 19, 11400, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d7001e', '4028817a33fc4e280133fd81e7d7001d', '2', '光华', '169280', null, null, '全明料蛋糕盘+罩子  \r\n距离罩子口部3CM烤字母花纸  \r\n', 1, 'PCS', 100, 100, 0, null, 32, 3200, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d7001f', '4028817a33fc4e280133fd81e7d7001d', '1', '宏艺', 'J859102682/113860', null, null, '全明料糖缸，烤字母白花纸\r\nSTORAGE ONLY\r\n尺寸', 1, 'PCS', 300, 300, 0, null, 16, 4800, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70020', '4028817a33fc4e280133fd81e7d7001d', '4', '精艺', 'JK1080435', null, null, '全明料球形瓶子，刻花，描亮油\r\n\r\n尺寸:9.5X10.5C', 1, 'PCS', 1008, 1008, 0, null, 9, 9072, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70021', '4028817a33fc4e280133fd81e7d7001d', '2', '光华', '123540', null, null, '全明料蛋糕盘子+罩子\r\n罩子上烤字母（HIGH TEA）花纸', 1, 'PCS', 100, 100, 0, null, 22, 2200, 9);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70022', '4028817a33fc4e280133fd81e7d7001d', '3', '会龙', 'JK1052446/158080', null, null, '全明料酒壶，杯身烤白色字母花纸\r\n \r\n尺寸：7.8X22.', 1, 'PCS', 702, 702, 0, null, 16.5, 11583, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70023', '4028817a33fc4e280133fd81e7d7001d', 'ff808081301885760130189e47ca0013', '文水志远', '62145', null, null, '全明料蛋糕罩子\r\n\r\n尺寸：30.3X11.5X15CM\r\n', 1, 'PCS', 504, 504, 0, null, 27, 13608, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70024', '4028817a33fc4e280133fd81e7d7001d', 'ff808081301885760130189e47ca0013', '文水志远', '62146/F-57', null, null, '全明料蛋糕罩子，刻麦穗花\r\n\r\n尺寸：30.3X11.5X1', 1, 'PCS', 504, 504, 0, null, 28.5, 14364, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70025', '4028817a33fc4e280133fd81e7d7001d', 'ff808081301885760130189e47ca0013', '文水志远', 'JKF081342/62180', null, null, '全明料蛋糕罩子+盘子\r\n盘子我司安排\r\n尺寸：30.3X11', 1, 'PCS', 652, 652, 0, null, 27, 17604, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70026', '4028817a33fc4e280133fd81e7d7001d', '1', '宏艺', 'JK10501218/160380', null, null, '全明料糖缸带盖子，糖缸身上烤\r\n白色字母花纸\r\n尺寸：12.', 1, 'PCS', 600, 600, 0, null, 15, 9000, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd81e7d70027', '4028817a33fc4e280133fd81e7d7001d', '1', '宏艺', 'JK1040009/141760', null, null, '全明料三层糖缸，烤字母花纸\r\n花纸我司安排\r\n尺寸：16.5', 1, 'PCS', 300, 300, 0, null, 35, 10500, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd89fcc00028', '4028817a33fc4e280133fd81e7d7001d', '7', '天顺', 'JKF081342/62180', null, null, '全明料蛋糕盘配罩子\r\n罩子由文水志远厂提供\r\n尺寸：33X1', 1, 'PCS', 652, 652, 0, null, 10.4, 6780.8, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd9f8b4e0030', '4028817a33fc4e280133fd9f8b4e002f', '15', '南皮开发', 'JK1040158/12068', null, null, '明料灯宫细转棱蜡台\r\n\r\n尺寸：6X26CM高\r\n4只/三层', 4, 'PCS', 400, 400, 0, null, 9.7, 3880, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd9f8b4e0031', '4028817a33fc4e280133fd9f8b4e002f', '2', '光华', 'JK1050317/12006', null, null, '明料糖缸配明料盖子\r\n缸身刻交叉麦穗花\r\n尺寸：10.5X1', 1, 'PCS', 504, 504, 0, null, 9.5, 4788, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd9f8b4e0032', '4028817a33fc4e280133fd9f8b4e002f', '2', '光华', 'JK1050316/12005', null, null, '明料糖缸配明料盖子\r\n缸身刻交叉麦穗花\r\n尺寸：15X15C', 1, 'PCS', 348, 348, 0, null, 12.5, 4350, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fd9f8b4e0033', '4028817a33fc4e280133fd9f8b4e002f', '2', '光华', 'JK103233/11301', null, null, '全明料糖缸刻钻石，描亮油\r\n尺寸：11X30.5CM高\r\n1', 1, 'PCS', 408, 408, 0, null, 18, 7344, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fdb370c00034', '4028817a33812ffd0133813f25940001', '7', '天顺', '9749', '17.png', null, '怪虫小碗喷绿色，喷漆，喷珠光\r\n尺寸：18X9CM高\r\n4只', 4, 'PCS', 304, 304, 0, null, 6.5, 1976, 29);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fdb370cf0035', '4028817a33812ffd0133813f25940001', '7', '天顺', '9749', '18.png', null, '怪虫小碗喷绿色，喷漆，喷珠光\r\n尺寸：18X9CM高\r\n4只', 4, 'PCS', 304, 304, 0, null, 6.5, 1976, 30);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fdb370df0036', '4028817a33812ffd0133813f25940001', '7', '天顺', '9749', '19.png', null, '怪虫小碗喷绿色，喷漆，喷珠光\r\n尺寸：18X9CM高\r\n4只', 4, 'PCS', 304, 304, 0, null, 6.5, 1976, 31);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f0037', '4028817a33fc4e280133fd9f8b4e002f', '2', '光华', 'JK1050201/12078', null, null, '全明料蛋糕罩配盘子,罩子上烤蒙砂白花纸\r\n盘子尺寸：16X1', 1, 'PCS', 402, 402, 0, null, 18, 7236, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f0038', '4028817a33fc4e280133fd9f8b4e002f', '13', '平遥鸿艺', 'JK1050198/12860', null, null, '全明料酒杯，\r\n距口部1.5CM烤蒙砂白花纸\r\n尺寸：11X', 4, 'PCS', 400, 400, 0, null, 6.5, 2600, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f0039', '4028817a33fc4e280133fd9f8b4e002f', '2', '光华', 'JK169340/13076', null, null, '全明料蛋糕罩配盘子，罩子上烤蒙砂白花纸    \r\n尺寸：25X2', 1, 'PCS', 200, 200, 0, null, 36, 7200, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e53b8c001e', '4028817a3420e78a013421a693730001', '2', '光华', '9868', null, '6bf2fdf5-6d7e-4147-b40c-6eddf95abcd8.png', '全明料喇叭底糖缸配盖子\r\n尺寸：5-1/4\"X17\"H\r\n1', 1, 'PCS', 600, 600, 1, null, 16, 9600, 29);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d15008d0047', '4028817a353b8d8e01353d15008d0046', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5089', null, '2c991b9e-a14b-4f37-a2ca-5e7d01cba021.jpg', '全明料冰花风灯，电镀花银喷紫色。\r\n尺寸:12.5*20 C', 1, 'PCS', 204, 204, 1, null, 13, 2652, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d15008d0048', '4028817a353b8d8e01353d15008d0046', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5094', null, '7ae1ccaa-426b-4476-bc6a-28258d735fbd.jpg', '全明料冰花风灯，粘电镀底座    \r\n尺寸：15.8X32CM', 1, 'PCS', 150, 150, 1, null, 14.5, 2175, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d15008d004d', '4028817a353b8d8e01353d15008d0046', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5088', null, '9488192b-fb0f-4aa5-9e29-86de71d05675.jpg', '全明料冰花风灯，电镀花银喷蓝色。\r\n尺寸:12.5*20 C', 1, 'PCS', 204, 204, 1, null, 13, 2652, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d15008d004f', '4028817a353b8d8e01353d15008d0046', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5095', null, '01349ede-bef9-4168-a346-e109e3111773.jpg', '全明料冰花风灯，粘明料底座   \r\n尺寸：15.8X32CM高', 1, 'PCS', 150, 150, 1, null, 14, 2100, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d15008d0050', '4028817a353b8d8e01353d15008d0046', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5086', null, '3c77a543-f2f2-4cf3-b173-8ef1d1a1f8be.jpg', '全明料冰花风灯，电镀花银喷绿色。\r\n尺寸:12.5*20 C', 1, 'PCS', 204, 204, 1, null, 13, 2652, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0051', '4028817a353b8d8e01353d15008d0046', '2', '光华', '5117', null, 'aec0cd7f-795e-4c5f-b8c5-532b6479c4be.jpg', '全明料蛋糕盘+罩子 \r\n罩上烤白金字母花纸（SWEETS)', 1, 'PCS', 100, 100, 1, null, 17, 1700, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0052', '4028817a353b8d8e01353d15008d0046', '9', '华艺', '5191', null, '5a77aec3-1299-4b75-8ff4-5c7232d0a8c6.jpg', '机压小鸟,表面要光滑    \r\n安全包装送祁县宏艺厂    \r\n请提', 1, 'PCS', 100, 100, 1, null, 2.4, 240, 19);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0054', '4028817a353b8d8e01353d15008d0046', '9', '华艺', '5191', null, '06191cc8-a932-4f7a-a951-eabbd4336f13.jpg', '全明料钻石蛋糕盘粘底座  \r\n尺寸：29.5X11.5CM高  ', 1, 'PCS', 100, 100, 1, null, 10, 1000, 18);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0055', '4028817a353b8d8e01353d15008d0046', '2', '光华', '5118', null, 'b76467e5-21b5-4102-8085-f0d14189e257.jpg', '全明料蛋糕盘+罩子    \r\n罩子上烤白金字母花纸（SWEETS', 1, 'PCS', 152, 152, 1, null, 16, 2432, 12);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0056', '4028817a353b8d8e01353d15008d0046', '9', '华艺', '5190', null, '9a6203d7-01b0-4ebe-bc08-d390b5ecd46a.jpg', '机压小鸟,表面要光滑    \r\n安全包装送祁县宏艺厂    \r\n请提', 1, 'PCS', 100, 100, 1, null, 2.4, 240, 16);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0057', '4028817a353b8d8e01353d15008d0046', '4', '精艺', '5337', null, 'ecc411bc-b3ce-4175-9e96-17014661c601.jpg', '全明料死模风灯，电镀花银喷蓝色  \r\n尺寸：14.5X20CM', 1, 'PCS', 156, 156, 1, null, 8, 1248, 22);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d0058', '4028817a353b8d8e01353d15008d0046', '9', '华艺', '5190', null, '9196fdca-db89-42a3-99d8-6a168479344c.jpg', '全明料钻石蛋糕盘粘底座  \r\n尺寸：23X11.5CM高  \r', 1, 'PCS', 100, 100, 1, null, 8.5, 850, 15);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d005a', '4028817a353b8d8e01353d15008d0046', '4', '精艺', '5330', null, '75849bf7-f9a2-4f74-853e-baefef078d93.jpg', '全明料死模风灯，电镀花银喷紫色  \r\n尺寸：14.5X20CM', 1, 'PCS', 156, 156, 1, null, 8, 1248, 20);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a353b8d8e01353d32350d005b', '4028817a353b8d8e01353d15008d0046', '4', '精艺', '5336', null, '5fe32315-0fb6-4a84-bb82-61b27ef3a8e3.jpg', '全明料死模风灯，电镀花银喷绿色  \r\n尺寸：14.5X20CM', 1, 'PCS', 156, 156, 1, null, 8, 1248, 21);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('402895c25152201a015152215a930000', '402895c2515129200151514376b80002', '12', '平遥远江', 'rrttrrttyyrree', '11', '柘城要柘城', '11', 11, null, 11, null, null, '11', 11, 121, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('402899d650894b860150894cef8f0000', '402899d650885c420150885d95cb0000', '10', '晶晨', 'rwtewr32432', '02.png', '货描', '1/2', 5, 'PCS', 10, null, null, '要求', 100, 1000, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028a9bd515b54c901515b5be9e40000', '4028a9bd515b2e8201515b3339860000', '1', '升华', 'fdgfdgfd', '01.png', '货物描述', '1/2', 5, 'PCS', 10, null, null, '要求', 10, 100, 20);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f003b', '4028817a33fc4e280133fd9f8b4e002f', '15', '南皮开发', 'JK5100005-F/13079', null, null, '全明料竖棱香槟杯\r\n尺寸：5.5X24.5CM高\r\n4只/三', 4, 'PCS', 1200, 1200, 0, null, 10, 12000, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f003c', '4028817a33fc4e280133fd9f8b4e002f', '13', '平遥鸿艺', 'JK1050195/12859', null, null, '全明料香槟杯\r\n距口部1.5CM烤蒙砂白花纸\r\n尺寸：8X2', 4, 'PCS', 400, 400, 0, null, 6, 2400, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f003d', '4028817a33fc4e280133fd9f8b4e002f', '15', '南皮开发', 'JK5100004/13078', null, null, '全明料直棱酒杯\r\n尺寸：9.5X18.5CM高\r\n4只/三层', 4, 'PCS', 1200, 1200, 0, null, 8.8, 10560, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f003e', '4028817a33fc4e280133fd9f8b4e002f', '15', '南皮开发', 'JK5300006/13080', null, null, '全明料竖棱糖缸，盖子上带圆头\r\n尺寸：9X8CM高\r\n1只/', 1, 'PCS', 1200, 1200, 0, null, 8.5, 10200, 12);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33fc4e280133fde6504f003f', '4028817a33fc4e280133fd9f8b4e002f', '15', '南皮开发', 'JK5300007/13081', null, null, '全明料竖棱糖缸，盖子上带圆头\r\n尺寸：9X12CM高\r\n1只', 1, 'PCS', 1200, 1200, 0, null, 9.8, 11760, 13);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a693820005', '4028817a3420e78a013421a693730001', '2', '光华', '5118', null, 'd2f2ab57-ca50-43ff-87fd-9b6b38d14adc.png', '全明料蛋糕盘+罩子  \r\n罩子上烤白金字母花纸（SWEETS)', 1, 'PCS', 300, 300, 1, null, 16, 4800, 14);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a693820007', '4028817a3420e78a013421a693730001', '2', '光华', '5117', null, '94744a94-9215-425c-8d7c-e6c27b74d47a.png', '全明料蛋糕盘+罩子  \r\n罩上烤白金字母花纸（SWEETS)  ', 1, 'PCS', 300, 300, 1, null, 17, 5100, 13);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a693820008', '4028817a3420e78a013421a693730001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5086', null, 'f9c8b767-01c1-47a1-816c-4203c229f765.png', '全明料冰花风灯，电镀花银喷绿色\r\n尺寸：12.5X20CM高', 1, 'PCS', 300, 300, 1, null, 13, 3900, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a69382000a', '4028817a3420e78a013421a693730001', '9', '华艺', '5190', null, 'de8f61ab-0ce5-4e66-862f-acc66140d77f.png', '全明料钻石蛋糕盘粘底座\r\n \r\n尺寸：23X11.5CM高\r', 1, 'PCS', 100, 100, 1, null, 8.5, 850, 17);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a69382000b', '4028817a3420e78a013421a693730001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5084', null, '4afac9ad-6f75-4186-95e2-0f3c992fd0a8.png', '全明料冰花风灯，电镀花银喷蓝色\r\n尺寸：10X17.5CM高', 1, 'PCS', 300, 300, 1, null, 11.5, 3450, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a69382000c', '4028817a3420e78a013421a693730001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5085', null, '11799ce4-7d8a-451b-8838-6b01f804b8ff.png', '全明料冰花风灯，电镀花银喷紫色\r\n尺寸：10X17.5CM高', 1, 'PCS', 300, 300, 1, null, 11.5, 3450, 9);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a69382000f', '4028817a3420e78a013421a693730001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5088', null, '9926bf89-1345-4082-aeeb-a3f94d0dcc40.png', '全明料冰花风灯，电镀花银喷蓝色\r\n尺寸：12.5X20CM高', 1, 'PCS', 300, 300, 1, null, 13, 3900, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a693820010', '4028817a3420e78a013421a693730001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5089', null, '22a26221-2c14-4ea4-b972-ebe9df1a27ab.png', '全明料冰花风灯，电镀花银喷紫色\r\n尺寸：12.5X20CM高', 1, 'PCS', 300, 300, 1, null, 13, 3900, 12);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421a693920012', '4028817a3420e78a013421a693730001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5083', null, '65fe2446-a833-483a-ad34-dc5da6a7e28a.png', '全明料冰花风灯，电镀花银喷绿色\r\n尺寸：10X17.5CM高', 1, 'PCS', 300, 300, 1, null, 11.5, 3450, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421d2e3fe0013', '4028817a3420e78a013421a693730001', '4', '精艺', '5336', null, '422bfb7c-ad4e-4098-8953-beca57d6259c.png', '全明料死模风灯，电镀花银喷绿色  \r\n   \r\n尺寸：14.5X', 1, 'PCS', 300, 300, 1, null, 8, 2400, 20);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421d2e3fe0014', '4028817a3420e78a013421a693730001', '4', '精艺', '5331', null, 'c09ea297-bb5f-47a0-b8a0-0b4419f6e138.png', '全明料死模风灯，电镀花银喷绿色\r\n尺寸：17X23CM高\r\n', 1, 'PCS', 300, 300, 1, null, 11.5, 3450, 19);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c10016', '4028817a3420e78a013421a693730001', '4', '精艺', '5400', null, 'f475d46e-733a-4220-8243-98ba76f09ddc.png', '全明料死模风灯，电镀花银喷蓝色\r\n \r\n尺寸：17X23CM', 1, 'PCS', 300, 300, 1, null, 11.5, 3450, 22);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c10017', '4028817a3420e78a013421a693730001', '7', '天顺', '9749', null, '3d52357d-71bf-4ac1-b7f0-38b640a2d349.png', '怪虫小碗，喷绿色，喷漆，喷珠光\r\n\r\n尺寸:18X9CM高\r', 4, 'PCS', 600, 600, 1, null, 6.5, 3900, 28);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c10018', '4028817a3420e78a013421a693730001', '2', '光华', '8759', null, 'c5f0d6c6-275f-4fb4-b468-a9be38f85f02.png', '全明料糖缸带盖子\r\n尺寸：16.5X40CM高\r\n1只/上下', 1, 'PCS', 600, 600, 1, null, 15, 9000, 27);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c10019', '4028817a3420e78a013421a693730001', '7', '天顺', '8709', null, '2720f819-b111-4aeb-b5e8-abc262dc5a7b.png', '怪虫小碗，喷蓝色，喷漆，喷珠光\r\n \r\n尺寸：18X9CM高', 4, 'PCS', 600, 600, 1, null, 6.5, 3900, 26);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c1001a', '4028817a3420e78a013421a693730001', '4', '精艺', '5337', null, 'c2ff4999-1ea3-479d-8859-3302bb0e9d77.png', '全明料死模风灯，电镀花银喷蓝色  \r\n  \r\n尺寸：14.5X2', 1, 'PCS', 300, 300, 1, null, 8, 2400, 21);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c1001b', '4028817a3420e78a013421a693730001', '7', '天顺', '8708', null, 'cd89d279-e040-4647-a89f-59bfee1d6db9.png', '怪虫小碗，喷紫色，喷漆，喷珠光\r\n \r\n尺寸：18X9CM高', 4, 'PCS', 600, 600, 1, null, 6.5, 3900, 25);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c1001c', '4028817a3420e78a013421a693730001', '2', '光华', '843MA', null, '6b4da997-ad8c-4101-90cb-1c554c356bb1.png', '全明料喇叭底糖缸，带盖子  \r\n盖子：10CMX10.3CM高', 1, 'PCS', 600, 600, 1, null, 16, 9600, 23);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3420e78a013421e2e3c1001d', '4028817a3420e78a013421a693730001', '2', '光华', '844MA', null, '19dd24a2-4eb2-4273-a46a-229d28aeee85.png', '全明料糖缸带盖子\r\n盖子：9.3X13.3CM高 壁厚3MM', 1, 'PCS', 600, 600, 1, null, 16, 9600, 24);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e0133591b86ec0003', '4028817a3357462e0133591b86ec0002', '2', '光华', '2965', '08.png', '2ba24918-4c3c-4632-8d8a-' || chr(10) || '' || chr(10) || '9d475d5e4d2d.png', '全明料糖缸带盖子\r\n尺寸：16X40CM高  底径：11CM', 1, 'PCS', 144, 144, 0, null, 17, 2448, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e0133591b86ec0004', '4028817a3357462e0133591b86ec0002', '2', '光华', '2964', '05.png', 'ad25929a-27f5-4065-bb9f-6d4788d395ee.png', '全明料糖缸带盖子\r\n尺寸' || chr(10) || '' || chr(10) || '：19X48CM高  底径：13.5', 1, 'PCS', 144, 144, 0, null, 24, 3456, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e0133592355750005', '4028817a3357462e0133591b86ec0002', '2', '光华', '2977', '06.png', 'b5480a29-da8c-41e1-b91c-54a9fdb15834.png', '全明料圆肚糖缸带盖子\r\n尺寸：16X36CM高    底径：', 1, 'PCS', 144, 144, 0, null, 17, 2448, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e0133592355750006', '4028817a3357462e0133591b86ec0002', '2', '光华', '2976', '07.png', 'af417c8a-e44f-406e-b226-194d8a61df75.png', '全明料糖缸带盖子\r\n尺寸' || chr(10) || '' || chr(10) || '：17.5X41CM高   底径：1', 1, 'PCS', 144, 144, 0, null, 17, 2448, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336cc0879b0011', '4028817a3357462e01336cc0877b0010', '3', '会龙', 'JK1700011', null, '05702b8f-6bda-4bca-9c4d-f15c18f279eb.png', '全明料方形黄油缸\r\n尺寸：罩子：7.3X8CM高   盘：6', 24, 'PCS', 504, 504, 0, null, 4.6, 2318.4, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d3a0be10015', '4028817a3357462e01336d3a0be10014', '7', '天顺', 'JK1014003', null, '699176d9-c242-42d2-8661-9ce712bba97a.png', '全明料盘子，烤鱼白花纸\r\n盘子直径：27CM\r\n2只/五层内', 2, 'PCS', 1200, 1200, 0, null, 7.5, 9000, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d3a0be10016', '4028817a3357462e01336d3a0be10014', '1', '宏艺', 'JK1014001', null, 'a2ffd39f-18d5-4a6b-89a2-bc91df4926f5.png', '全明料大碗，烤鱼白花纸\r\n尺寸：23X11CM高\r\n1只/五', 1, 'PCS', 1000, 1000, 0, null, 16.5, 16500, 2);
commit;
prompt 100 records committed...
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d3a0be10017', '4028817a3357462e01336d3a0be10014', '1', '宏艺', 'JK1014006', null, 'edc6f494-cc9f-41f2-a04c-edff659df1af.png', '全明料低口杯，烤6种白花纸\r\n尺寸：7.3X10.5CM高\r', 6, 'PCS', 1800, 1800, 0, null, 5.3, 9540, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a590020', '4028817a3357462e01336d523195001a', '7', '天顺', '9954/6309', null, '1e15e517-af2a-45c9-8c1e-1f1b592f5f79.png', '竹节碗，喷绿色，喷漆，喷珠光\r\n直径：31CM\r\n4只/内盒', 4, 'PCS', 408, 408, 0, null, 11.5, 4692, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a590021', '4028817a3357462e01336d523195001a', '7', '天顺', '8709/6204', null, '1a6770a7-033c-4b98-9e2a-60cd2a5081c3.png', '怪虫小碗，喷蓝色，喷漆，喷珠光\r\n直径：18CM\r\n4只/内', 4, 'PCS', 600, 600, 0, null, 6.5, 3900, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a590022', '4028817a3357462e01336d523195001a', '7', '天顺', '9955/6105', null, '15c6d6ad-3608-4d73-83f3-23f605123b90.png', '竹节碗，喷紫色，喷漆，喷珠光\r\n直径：31CM\r\n4只/内盒', 4, 'PCS', 408, 408, 0, null, 11.5, 4692, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a590023', '4028817a3357462e01336d523195001a', '7', '天顺', '9227/6092', null, '0ffed7a5-6fd6-4b36-9387-7108bb408fdf.png', '海星盘，喷紫色，喷漆，喷珠光\r\n直径：30CM\r\n4只/内盒', 4, 'PCS', 408, 408, 0, null, 11, 4488, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133813f25a30002', '4028817a33812ffd0133813f25940001', '4', '精艺', '4993', '22.png', '3feb6071-7835-48b6-beca-e54202221c3b.png', '全明料死模风灯，电镀花银喷绿色 \r\n明料挺底\r\n尺寸：11.', 1, 'PCS', 300, 300, 0, null, 8.5, 2550, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133813f25a30003', '4028817a33812ffd0133813f25940001', '4', '精艺', '4994', '23.png', '56ada31d-acfc-4261-b28d-8be65ba2a21e.png', '全明料死模风灯，电镀花银喷蓝色\r\n明料挺底\r\n尺寸：11.5', 1, 'PCS', 300, 300, 0, null, 8.5, 2550, 2);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133813f25a30004', '4028817a33812ffd0133813f25940001', '4', '精艺', '4995', '24.png', '9eb0c66c-d682-4f19-b89a-1a4808da5456.png', '全明料死模风灯，电镀花银喷紫色\r\n明料挺底\r\n尺寸：11.5', 1, 'PCS', 300, 300, 0, null, 8.5, 2550, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacc40005', '4028817a33812ffd0133813f25940001', '2', '光华', '9868', '01.png', 'ba10c6b0-34b7-4911-a45c-cc282cf8072d.png', '全明料喇叭底糖缸配盖子\r\n尺寸：16X40CM高\r\n1只/上', 1, 'PCS', 600, 600, 0, null, 16, 9600, 27);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacc40006', '4028817a33812ffd0133813f25940001', '7', '天顺', '5099', '14.png', 'd38c8874-e641-4c59-9f6d-eb07df231d44.png', '全明料钻石蛋糕盘粘底座\r\n喷蓝色，喷漆\r\n尺寸：23X11.', 1, 'PCS', 300, 300, 0, null, 11, 3300, 9);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacc40007', '4028817a33812ffd0133813f25940001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5094', '20.png', '662d9320-a8b7-4957-8d73-' || chr(10) || '' || chr(10) || 'e4560e12e0e7.png', '全明料冰花风灯，粘电镀底座  \r\n尺寸：15.8X32CM高', 1, 'PCS', 300, 300, 0, null, 14.5, 4350, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacc40008', '4028817a33812ffd0133813f25940001', '2', '光华', '5189', '02.png', 'a2a503a3-f0cd-49b4-b05c-8ea55ecbe2bf.png', '全明料竖棱风灯，粘电镀底座\r\n底座由我司提供\r\n尺寸：20X', 1, 'PCS', 300, 300, 0, null, 14, 4200, 12);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacc40009', '4028817a33812ffd0133813f25940001', '4', '精艺', '5331', '25.png', '1b211d97-1def-49c6-90a8-8097bbd07f68.png', '全明料死模风灯，电镀花银喷绿色\r\n\r\n尺寸：17X23CM高', 1, 'PCS', 300, 300, 0, null, 11.5, 3450, 13);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacc4000a', '4028817a33812ffd0133813f25940001', '4028817a33d4f8b40133d9989f5e0024', '民鑫', '5095', '21.png', '7b5d7395-40b4-45ad-9c42-' || chr(10) || '' || chr(10) || 'c7050e232448.png', '全明料冰花风灯，粘明料底座 \r\n尺寸：15.8X32CM高\r', 1, 'PCS', 300, 300, 0, null, 14, 4200, 8);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4000b', '4028817a33812ffd0133813f25940001', '2', '光华', '843MA', '03.png', 'c0229e90-0a5b-438d-8b07-4acd238b142b.png', '全明料喇叭底糖缸，带盖子\r\n盖子：10CMX10.3CM高', 1, 'PCS', 600, 600, 0, null, 16, 9600, 21);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4000c', '4028817a33812ffd0133813f25940001', '4', '精艺', '4997', '27.png', '0fdad1e1-452c-4ae4-a354-49688bd41778.png', '全明料死模风灯，电镀花银喷蓝色  \r\n明料挺底  \r\n尺寸：11', 1, 'PCS', 300, 300, 0, null, 10.5, 3150, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4000d', '4028817a33812ffd0133813f25940001', '4', '精艺', '4996', '26.png', '7ae6c20e-0f57-4fab-9e40-22d1a486e943.png', '全明料死模风灯，电镀花银喷绿色\r\n明料挺底\r\n尺寸：11.5', 1, 'PCS', 300, 300, 0, null, 10.5, 3150, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4000e', '4028817a33812ffd0133813f25940001', '2', '光华', '600MA', '05.png', '958fe4fb-db40-4977-bf2e-2c2db29d65f3.png', '全明料蛋糕盘+罩子,磨口抛光\r\n蛋糕罩子尺寸：17.5X15', 1, 'PCS', 600, 600, 0, null, 18, 10800, 17);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4000f', '4028817a33812ffd0133813f25940001', '2', '光华', '602MA', '06.png', '624ab3d2-12f3-4dd8-b438-c03a3018b170.png', '全明平光蛋糕盘+罩子,磨口抛光\r\n蛋糕罩子尺寸：17.5X1', 1, 'PCS', 600, 600, 0, null, 19, 11400, 18);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40010', '4028817a33812ffd0133813f25940001', '2', '光华', '8759', '07.png', 'f92f57f8-65de-42be-9814-bad100059d23.png', '全明料竖棱糖缸配盖子\r\n尺寸：16.5X40CM高\r\n1只/', 1, 'PCS', 600, 600, 0, null, 15, 9000, 25);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d3a0be10018', '4028817a3357462e01336d3a0be10014', '1', '宏艺', 'JK1014005', null, '9ed4ab1e-d425-4b8d-beb3-1fa6dc63d1df.png', '全明料低口杯，烤鱼白花纸\r\n尺寸：7.3X10.5CM高\r\n', 4, 'PCS', 1800, 1800, 0, null, 5.3, 9540, 4);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d3a0be10019', '4028817a3357462e01336d3a0be10014', '1', '宏艺', 'JK1080766-3', null, '21b5e24a-a58a-4a58-a705-1595faeec581.png', '全明料低口杯，烤3种不同的白花纸\r\n尺寸：7.3X10.5C', 3, 'PCS', 1800, 1800, 0, null, 5.3, 9540, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d523195001b', '4028817a3357462e01336d523195001a', '7', '天顺', '8708/6203', null, '1bab511c-4f4c-4de7-8b65-4ccdcd00a569.png', '怪虫小碗，喷紫色，喷漆，喷珠光\r\n直径：18CM\r\n4只/内', 4, 'PCS', 600, 600, 0, null, 6.5, 3900, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a59001c', '4028817a3357462e01336d523195001a', '7', '天顺', '9749/6525', null, '143a4aa8-894d-4226-a461-eac712567360.png', '怪虫碗，喷绿色，喷漆，喷珠光\r\n直径：18CM\r\n4只/内盒', 4, 'PCS', 600, 600, 0, null, 6.5, 3900, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a59001d', '4028817a3357462e01336d523195001a', '7', '天顺', '9226/6116', null, 'fcf3f5a9-a405-4f33-abb9-f317c60f1453.png', '海星盘，喷绿色，喷漆，喷珠光\r\n直径：31CM\r\n4只/内盒', 4, 'PCS', 408, 408, 0, null, 11, 4488, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a59001e', '4028817a3357462e01336d523195001a', '7', '天顺', '9748/6115', null, '657ac46a-bd23-4a2d-9abe-c552a8fc3727.png', '海星盘，喷蓝色，喷漆，喷珠光\r\n直径：31CM\r\n4只/内盒', 4, 'PCS', 408, 408, 0, null, 11, 4488, 5);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a3357462e01336d5e8a59001f', '4028817a3357462e01336d523195001a', '7', '天顺', '9956/6308', null, '1ca7fc1c-aad2-4f1e-8c3b-9a1009e22c04.png', '竹节碗，喷蓝色，喷漆，喷珠光\r\n直径：31CM\r\n4只/内盒', 4, 'PCS', 408, 408, 0, null, 11.5, 4692, 9);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40012', '4028817a33812ffd0133813f25940001', '2', '光华', '5118', '08.png', '635cdf31-8e48-45f3' || chr(10) || '' || chr(10) || '-886c-5fffd532175b.png', '全明料蛋糕盘+罩子\r\n罩子上烤白金字母花纸（SWEETS)\r', 1, 'PCS', 300, 300, 0, null, 16, 4800, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40013', '4028817a33812ffd0133813f25940001', '7', '天顺', '8708', '15.png', '39b3ac6f-fb30-4b37-8fff-a07fb88aef15.png', '怪虫小碗，喷紫色，喷漆，喷珠光\r\n尺寸：18CX9CM高\r\n', 1, 'PCS', 600, 600, 0, null, 6.5, 3900, 23);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40014', '4028817a33812ffd0133813f25940001', '4', '精艺', '5336', '29.png', '466ba3d1-94b5-44ca-92c9-98631bf3b92b.png', '全明料死模风灯，电镀花银喷绿色  \r\n   \r\n尺寸：14.5X', 1, 'PCS', 300, 300, 0, null, 8, 2400, 14);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40015', '4028817a33812ffd0133813f25940001', '4', '精艺', '5337', '28.png', '78ff069b-327e-488e-a629-b76bed0efb98.png', '全明料死模风灯，电镀花银喷蓝色\r\n\r\n尺寸：14.5X20C', 1, 'PCS', 300, 300, 0, null, 8, 2400, 15);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40016', '4028817a33812ffd0133813f25940001', '2', '光华', '603MA', '09.png', 'ea12f8ba-afc1-4651-bc10-432c85fcb091.png', '全明平光蛋糕盘+罩子,磨口抛光\r\n蛋糕罩子尺寸：17.5X1', 1, 'PCS', 600, 600, 0, null, 20, 12000, 19);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40017', '4028817a33812ffd0133813f25940001', '2', '光华', '5117', '10.png', '4f7fdc19-c276-47da-aced-5cec4e02be08.png', '全明料蛋糕盘+罩子\r\n罩上烤白金字母花纸（SWEETS)\r\n', 1, 'PCS', 300, 300, 0, null, 17, 5100, 10);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40018', '4028817a33812ffd0133813f25940001', '4', '精艺', '5400', '31.png', '3b810117-19c6-446e-886f-d3b2fd5ba411.png', '全明料死模风灯，电镀花银喷蓝色\r\n \r\n尺寸：17X23CM', 1, 'PCS', 300, 300, 0, null, 11.5, 3450, 16);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd40019', '4028817a33812ffd0133813f25940001', '4', '精艺', '4998', '30.png', '0c400655-fb24-4781-aae1-eaa30e31ad4c.png', '全明料死模风灯，电镀花银喷紫色\r\n明料挺底\r\n尺寸：11.5', 1, 'PCS', 300, 300, 0, null, 10.5, 3150, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4001a', '4028817a33812ffd0133813f25940001', '2', '光华', '8760', '11.png', '2aaba753-e5d2-4c42-badf-cc16acf81d2b.png', '全明料竖棱糖缸配盖子\r\n尺寸：16.5X51CM高\r\n\r\n1', 1, 'PCS', 600, 600, 0, null, 16, 9600, 26);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4001b', '4028817a33812ffd0133813f25940001', '2', '光华', '844MA', '12.png', '6f6f097f-ae83-4ecb-80c6-ec1e93353985.png', '全明料糖缸带盖子\r\n盖子：9.3X13.3CM高 壁厚3MM', 1, 'PCS', 600, 600, 0, null, 16, 9600, 22);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4001c', '4028817a33812ffd0133813f25940001', '2', '光华', '9869', '13.png', 'be81bc6b-610b-45fa-bb8b-5156d8de9d52.png', '全明料喇叭底糖缸配盖子\r\n尺寸：19X40CM高\r\n1只/上', 1, 'PCS', 600, 600, 0, null, 16, 9600, 28);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33812ffd0133816aacd4001d', '4028817a33812ffd0133813f25940001', '7', '天顺', '8709', '16.png', 'd33ee976-4d35-4990-ae41-eebee8989f5a.png', '怪虫小碗，喷蓝色，喷漆，喷珠光\r\n尺寸：18CMX9CM高\r', 1, 'PCS', 600, 600, 0, null, 6.5, 3900, 24);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e88000e', '4028817a33d4f8b40133d9878e88000d', '13', '平遥鸿艺', 'JK1060019/11990', null, null, '全明料密直棱低口杯\r\n尺寸：9X10.5CM高\r\n4只/五层', 4, 'PCS', 696, 696, 0, null, 5, 3480, 6);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e88000f', '4028817a33d4f8b40133d9878e88000d', '13', '平遥鸿艺', 'JK103134/11989', null, null, '全明料密直棱香槟杯\r\n尺寸：9X21CM高\r\n4只/五层内盒', 4, 'PCS', 832, 832, 0, null, 6, 4992, 7);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880010', '4028817a33d4f8b40133d9878e88000d', '1', '宏艺', 'JK1050152/11306', null, null, '全明料酒杯，口部描1CM白金边\r\n尺寸：7X26CM高\r\n4', 4, 'PCS', 608, 608, 0, null, 8.5, 5168, 1);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880011', '4028817a33d4f8b40133d9878e88000d', '2', '光华', 'JK103233/11301', null, null, '全明料糖缸配盖子，糖缸刻钻石描亮油\r\n尺寸：11X30.5C', 1, 'PCS', 12, 12, 0, null, 18, 216, 11);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880012', '4028817a33d4f8b40133d9878e88000d', '1', '宏艺', 'JK1050068/11314', null, null, '全明料马丁尼，口部描1CM白金边\r\n尺寸：12X19CM高\r', 4, 'PCS', 608, 608, 0, null, 11.2, 6809.6, 3);
insert into CONTRACT_PRODUCT_C (CONTRACT_PRODUCT_ID, CONTRACT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, LOADING_RATE, BOX_NUM, PACKING_UNIT, CNUMBER, OUT_NUMBER, FINISHED, PRODUCT_REQUEST, PRICE, AMOUNT, ORDER_NO)
values ('4028817a33d4f8b40133d9878e880013', '4028817a33d4f8b40133d9878e88000d', '2', '光华', 'JK1050317/12006', null, null, '全明料糖缸配盖子，糖缸刻交叉麦穗花\r\n尺寸：10.5X14C', 1, 'PCS', 168, 168, 0, null, 9.5, 1596, 9);
commit;
prompt 145 records loaded
prompt Loading DEPT_P...
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('100', '杰信商贸集团', null, 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('3d00290a-1af0-4c28-853e-29fbf96a2722', '市场部', '100', 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('4028827c4fb6202a014fb6209c730000', '杰信总裁办', null, 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('4028827c4fb633bd014fb64467470000', '杰信', null, null);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('4028827c4fb645b0014fb64668550000', '船运部cgx', '4028827c4fb6202a014fb6209c730000', 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('73f3fa2f-66a2-4d16-8306-78d89003031b', '网络部', '100', 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('97f88a8c-90fc-4d52-aed7-2046f62fb498', '总经办', '100', 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('aeb1c7d3-9a54-4f73-b0ec-0325b83aef45', '船运部', '100', 1);
insert into DEPT_P (DEPT_ID, DEPT_NAME, PARENT_ID, STATE)
values ('297ef78a61176f410161176fd7930000', '网络研发部', '73f3fa2f-66a2-4d16-8306-78d89003031b', 1);
commit;
prompt 9 records loaded
prompt Loading DICT_P...
insert into DICT_P (DICT_ID, DESCRIPTION, DICTYPE, NAME, VAL)
values ('operatef', '给用户赋角色', 'operate', '角色', '6');
insert into DICT_P (DICT_ID, DESCRIPTION, DICTYPE, NAME, VAL)
values ('operatea', '新增的操作', 'operate', '新增', '1');
insert into DICT_P (DICT_ID, DESCRIPTION, DICTYPE, NAME, VAL)
values ('operateb', '修改的操作', 'operate', '修改', '2');
insert into DICT_P (DICT_ID, DESCRIPTION, DICTYPE, NAME, VAL)
values ('operatec', '删除的操作', 'operate', '删除', '3');
insert into DICT_P (DICT_ID, DESCRIPTION, DICTYPE, NAME, VAL)
values ('operated', '查询的操作', 'operate', '查看', '4');
insert into DICT_P (DICT_ID, DESCRIPTION, DICTYPE, NAME, VAL)
values ('operatee', '赋权限的操作', 'operate', '权限', '5');
commit;
prompt 6 records loaded
prompt Loading MODULE_P...
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('1', null, null, '系统首页', 1, 0, null, '系统首页', 'home', 0, 1, null, null, null, 'home', 1, null, null, to_timestamp('21-07-2015 23:39:13.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('101', '1', '系统首页', '我的留言板', 2, 0, null, '我的留言板', null, 1, 1, null, null, null, 'home', 6, null, null, to_timestamp('22-07-2015 00:14:13.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('102', '1', '系统首页', '我的代办任务', 2, 0, null, '我的代办任务', null, 1, 1, null, null, null, 'home', 7, null, null, to_timestamp('22-07-2015 00:14:14.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('103', '1', '系统首页', '请假单管理', 2, 0, null, '请假单管理', null, 1, 1, null, null, null, 'home', 8, null, null, to_timestamp('22-07-2015 00:14:16.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('2', null, null, '货运管理', 1, 0, null, '货运管理', 'cargo', 0, 1, null, null, null, 'cargo', 2, null, null, to_timestamp('21-07-2015 23:39:20.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('201', '2', '货运管理', '购销合同', 2, 0, null, '购销合同', 'cargo/contractAction_list', 1, 1, null, null, null, 'cargo', 9, null, null, to_timestamp('25-07-2015 10:00:33.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('202', '2', '货运管理', '出货表', 2, 0, null, '出货表', 'cargo/outProductAction_toedit', 1, 1, null, null, null, 'cargo', 10, null, null, to_timestamp('25-07-2015 10:00:43.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('203', '2', '货运管理', '合同管理', 2, 0, null, '合同管理', 'cargo/exportAction_contractList', 1, 1, null, null, null, 'cargo', 11, null, null, to_timestamp('25-07-2015 10:00:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('204', '2', '货运管理', '出口报运', 2, 0, null, '出口报运', 'cargo/exportAction_list.action', 1, 1, null, null, null, 'cargo', 12, null, null, to_timestamp('25-07-2015 10:00:57.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('205', '2', '货运管理', '装箱管理', 2, 0, null, '装箱管理', 'cargo/packingListAction_list', 1, 1, null, null, null, 'cargo', 22, null, null, to_timestamp('30-07-2015 16:18:45.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('206', '2', '货运管理', '委托管理', 2, 0, null, '委托管理', 'cargo/shippingOrderAction_list', 1, 1, null, null, null, 'cargo', 23, null, null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('207', '2', '货运管理', '发票管理', 2, 0, null, '发票管理', 'cargo/invoiceAction_list', 1, 1, null, null, null, 'cargo', 24, null, null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('208', '2', '货运管理', '财务管理', 2, 0, null, '财务管理', 'cargo/financeAction_list', 1, 1, null, null, null, 'cargo', 25, null, null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-07-2015 16:13:54.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('3', null, null, '统计分析', 1, 0, null, '统计分析', 'stat', 0, 1, null, null, null, 'stat', 3, null, null, to_timestamp('21-07-2015 23:39:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('11-11-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('302', '3', '统计分析', '产品销售排行', 2, 0, null, '产品销售排行', 'stat/statChartAction_productsale', 1, 1, null, null, null, 'stat', 14, null, null, to_timestamp('05-12-2015 10:28:21.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4', null, null, '基础信息', 1, 0, null, '基础信息', 'baseinfo', 0, 1, null, null, null, 'baseinfo', 4, null, null, to_timestamp('21-07-2015 23:39:30.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('401', '4', '基础信息', '系统代码', 2, 0, null, '系统代码', null, 1, 1, null, null, null, 'baseinfo', 16, null, null, to_timestamp('22-07-2015 00:13:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('402', '4', '基础信息', '厂家信息', 2, 0, null, '厂家信息', null, 1, 1, null, null, null, 'baseinfo', 17, null, null, to_timestamp('22-07-2015 00:13:55.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('5', null, null, '系统管理', 1, 0, null, '系统管理', 'sysadmin', 0, 1, null, null, null, 'sysadmin', 5, null, null, to_timestamp('21-07-2015 23:39:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('501', '5', '系统管理', '部门管理', 2, 0, null, '部门管理', 'sysadmin/dept/list', 1, 1, null, null, null, 'sysadmin', 18, null, null, to_timestamp('22-07-2015 00:13:45.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('502', '5', '系统管理', '用户管理', 2, 0, null, '用户管理', 'sysadmin/user/list', 1, 1, null, null, null, 'sysadmin', 19, null, null, to_timestamp('22-07-2015 00:13:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('503', '5', '系统管理', '角色管理', 2, 0, null, '角色管理', 'sysadmin/role/list', 1, 1, null, null, null, 'sysadmin', 20, null, null, to_timestamp('22-07-2015 00:13:47.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('504', '5', '系统管理', '模块管理', 2, 0, null, '模块管理', 'sysadmin/module/list', 1, 1, null, null, null, 'sysadmin', 21, null, null, to_timestamp('22-07-2015 00:13:50.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('6', null, null, '流程管理', 1, 0, null, '流程管理', 'activiti', 0, 1, null, null, null, 'activiti', 60, null, null, to_timestamp('01-08-2015 23:41:55.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-08-2015 23:41:55.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('601', '6', '流程管理', '部署流程', 2, 0, null, '部署流程', 'flow/flowAction_deploy.action', 1, 1, null, null, null, 'activiti', 61, null, null, to_timestamp('01-08-2015 23:48:16.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-08-2015 23:48:16.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('602', '6', '流程管理', '查询流程', 2, 0, null, '查询流程', 'flow/flowAction_queryProcessDefinition.action', 1, 1, null, null, null, 'activiti', 62, null, null, to_timestamp('01-08-2015 23:48:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-08-2015 23:48:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('603', '6', '流程管理', '添加采购单', 2, 0, null, '添加采购单', 'flow/orderFlowAction_addOrder.action', 1, 1, null, null, null, 'activiti', 63, null, null, to_timestamp('02-08-2015 23:50:13.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('02-08-2015 23:50:13.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into MODULE_P (MODULE_ID, PARENT_ID, PARENT_NAME, NAME, LAYER_NUM, IS_LEAF, ICO, CPERMISSION, CURL, CTYPE, STATE, BELONG, CWHICH, QUOTE_NUM, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('604', '6', '流程管理', '查询采购单', 2, 0, null, '查询采购单', 'flow/orderFlowAction_orderTaskList.action', 1, 1, null, null, null, 'activiti', 64, null, null, to_timestamp('03-08-2015 00:22:09.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('03-08-2015 00:22:09.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
commit;
prompt 28 records loaded
prompt Loading ROLE_P...
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '船运专员', '船运专员', 9, null, null, to_timestamp('11-09-2015 16:59:44.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('25-07-2015 09:55:21.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '船运经理', '船运经理', 10, null, null, to_timestamp('11-09-2015 16:59:47.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('25-07-2015 09:55:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '装箱专员', '装箱专员', 11, null, null, to_timestamp('11-09-2015 16:59:49.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('31-07-2015 14:49:21.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '总经理', 'sysadmin', 1, null, null, to_timestamp('11-09-2015 16:58:57.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '销售经理', 'salemanager', 2, null, null, to_timestamp('11-09-2015 16:58:04.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0003', '合同专责', 'contract', 3, null, null, to_timestamp('11-09-2015 16:58:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '销售专责', 'sale', 4, null, null, to_timestamp('11-09-2015 16:57:47.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0005', '报运经理', 'transportation', 5, null, null, to_timestamp('11-09-2015 16:57:42.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '报运专责', 'trans', 6, null, null, to_timestamp('11-09-2015 16:57:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '财务经理', 'financial', 7, null, null, to_timestamp('11-09-2015 16:57:32.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into ROLE_P (ROLE_ID, NAME, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '财务专责', 'fin', 8, null, null, to_timestamp('11-09-2015 16:57:25.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-07-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
commit;
prompt 11 records loaded
prompt Loading DICT_MODULE_P...
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee38b005a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee38d005b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee38f005c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee391005d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee393005e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee396005f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3a20061');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3b40062');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3c00066');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3c40067');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3c60068');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3ca0069');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3cc006a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3ce006b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3d0006c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3d2006d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3de0072');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3e20073');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3eb0076');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3ee0077');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3f10078');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3f8007a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('207', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee403007e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('501', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee40f0080');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259103000c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325915b000d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325919e000e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('201', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732591c8000f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732592020010');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732592d90011');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325934e0012');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('202', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732593af0013');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732593c40014');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732590cc000a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732590ce000b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732593fd0015');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732594390016');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732594840017');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732594cb0018');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732594e40019');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259511001a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325953c001b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325955d001c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259592001d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732595cf001e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732595ed001f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732596280020');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325966a0021');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732596ad0022');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732596cd0023');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('207', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732596ec0024');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('207', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325971b0025');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('207', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732597480026');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('207', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732597880027');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('208', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325979d0028');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('208', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732597e80029');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('208', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259815002a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('208', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259851002b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('302', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325987e002c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('302', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732598aa002d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('302', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732598e3002e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('302', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325990c002f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('401', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325993a0030');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('401', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732599640031');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('401', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732599a90032');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('401', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732599d50033');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('402', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259a020034');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('402', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259a2c0035');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('402', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259a5a0036');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('402', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259a840037');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('501', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259ab30038');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('501', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259aea0039');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('501', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259b17003a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('501', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259b42003b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('503', 'operatee', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259c820041');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('503', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259cbc0042');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('503', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259cf20043');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('503', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259d1e0044');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('503', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259d4a0045');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('504', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259d770046');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('504', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259dae0047');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('603', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259ff90054');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('603', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325a0260055');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('604', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325a0510056');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('604', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325a07e0057');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('604', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325a0aa0058');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('604', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325a0eb0059');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3980060');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3b70063');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3ba0064');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3bd0065');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3d5006e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3d7006f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3d90070');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('203', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3dc0071');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3e50074');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('204', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3e70075');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('205', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3f40079');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operatea', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3fb007b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operateb', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee3fe007c');
commit;
prompt 100 records committed...
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('206', 'operatec', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee401007d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('208', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee407007f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('502', 'operated', '4028a1c34ec2e5c8014ec2ebf8430001', '297ef78a61732c850161732ee4120081');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173258eea0000');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173258f260001');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173258f530002');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('101', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173258f7d0003');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173258fac0004');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173258fd60005');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732590040006');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('102', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325902f0007');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a420161732590730008');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('103', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a4201617325909d0009');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('502', 'operatef', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259b6f003c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('502', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259bbc003d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('502', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259be9003e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('502', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259c2b003f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('502', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259c570040');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('504', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259ddb0048');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('504', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259dde0049');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('601', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259e05004a');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('601', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259e33004b');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('601', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259e5f004c');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('601', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259e8c004d');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('602', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259eef004e');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('602', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259f1b004f');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('602', 'operateb', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259f470050');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('602', 'operatec', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259f740051');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('603', 'operated', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259fa00052');
insert into DICT_MODULE_P (MODULE_ID, DICT_ID, ROLE_ID, TID)
values ('603', 'operatea', '4028a1cd4ee2d9d6014ee2df4c6a0007', '297ef78a61731a42016173259fcd0053');
commit;
prompt 130 records loaded
prompt Loading EXPORT_C...
insert into EXPORT_C (EXPORT_ID, INPUT_DATE, CONTRACT_IDS, CUSTOMER_CONTRACT, LCNO, CONSIGNEE, MARKS, SHIPMENT_PORT, DESTINATION_PORT, TRANSPORT_MODE, PRICE_CONDITION, REMARK, BOX_NUMS, GROSS_WEIGHTS, MEASUREMENTS, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME)
values ('402895c15161c91d015161ca3f710000', to_date('02-12-2015', 'dd-mm-yyyy'), '4028817a3420e78a013421a693730001,4028817a353b8d8e01353d15008d0046', 'C/4040/11 C/4104/11 ', 'W', 'O', 'E', 'I', 'R', 'U', 'T', 'Y', 1, 3, 2, 0, '1c7abd8a-8d67-420e-a4b5-74defcb8e968', '4028827c4fb645b0014fb64668550000', to_date('02-12-2015 16:23:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into EXPORT_C (EXPORT_ID, INPUT_DATE, CONTRACT_IDS, CUSTOMER_CONTRACT, LCNO, CONSIGNEE, MARKS, SHIPMENT_PORT, DESTINATION_PORT, TRANSPORT_MODE, PRICE_CONDITION, REMARK, BOX_NUMS, GROSS_WEIGHTS, MEASUREMENTS, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME)
values ('4028a9ba516a93b301516a9fea090000', to_date('04-12-2015', 'dd-mm-yyyy'), '4028817a3357462e0133591b86ec0002,4028817a3357462e01336cc0877b0010', 'C/3817/11 11JK1080', 'T1', 'T7', 'T4', 'T2', 'T6', 'T3', 'FOB', 'T5', 10, 20, 10, 0, '1c7abd8a-8d67-420e-a4b5-74defcb8e968', '4028827c4fb645b0014fb64668550000', to_date('04-12-2015 09:34:03', 'dd-mm-yyyy hh24:mi:ss'));
commit;
prompt 2 records loaded
prompt Loading EXPORT_PRODUCT_C...
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f790001', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5094', 'PCS', 150, 1, null, null, null, null, null, null, 14.5, 0, 7);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f790002', '402895c15161c91d015161ca3f710000', '7', '8708', 'PCS', 600, 4, null, null, null, null, null, null, 6.5, 0, 25);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7a0003', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5086', 'PCS', 300, 1, null, null, null, null, null, null, 13, 0, 10);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7a0004', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5092', 'PCS', 102, 1, null, null, null, null, null, null, 16, 0, 5);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7a0005', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5090', 'PCS', 102, 1, null, null, null, null, null, null, 16, 0, 4);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7a0006', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5085', 'PCS', 300, 1, null, null, null, null, null, null, 11.5, 0, 9);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7b0007', '402895c15161c91d015161ca3f710000', '9', '5190', 'PCS', 100, 1, null, null, null, null, null, null, 2.4, 0, 16);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7b0008', '402895c15161c91d015161ca3f710000', '4', '5336', 'PCS', 300, 1, null, null, null, null, null, null, 8, 0, 20);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7c000a', '402895c15161c91d015161ca3f710000', '4', '4997', 'PCS', 300, 1, null, null, null, null, null, null, 10.5, 0, 5);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7c000c', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5089', 'PCS', 204, 1, null, null, null, null, null, null, 13, 0, 3);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7d000d', '402895c15161c91d015161ca3f710000', '1', '5190', 'PCS', 100, 1, null, null, null, null, null, null, 22, 0, 14);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7d000e', '402895c15161c91d015161ca3f710000', '9', '5190', 'PCS', 100, 1, null, null, null, null, null, null, 8.5, 0, 17);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7d000f', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5088', 'PCS', 204, 1, null, null, null, null, null, null, 13, 0, 2);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7d0010', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5089', 'PCS', 300, 1, null, null, null, null, null, null, 13, 0, 12);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7e0011', '402895c15161c91d015161ca3f710000', '4', '4998', 'PCS', 300, 1, null, null, null, null, null, null, 10.5, 0, 6);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f7e0013', '402895c15161c91d015161ca3f710000', '4', '5336', 'PCS', 156, 1, null, null, null, null, null, null, 8, 0, 21);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f840015', '402895c15161c91d015161ca3f710000', '7', '5144', 'PCS', 100, 1, null, null, null, null, null, null, 11, 0, 15);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f840016', '402895c15161c91d015161ca3f710000', '2', '5118', 'PCS', 152, 1, null, null, null, null, null, null, 16, 0, 12);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f850018', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5084', 'PCS', 300, 1, null, null, null, null, null, null, 11.5, 0, 8);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f850019', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5095', 'PCS', 150, 1, null, null, null, null, null, null, 14, 0, 8);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f85001a', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5086', 'PCS', 204, 1, null, null, null, null, null, null, 13, 0, 1);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f85001b', '402895c15161c91d015161ca3f710000', '7', '5099', 'PCS', 152, 1, null, null, null, null, null, null, 11, 0, 10);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f85001c', '402895c15161c91d015161ca3f710000', '7', '8709', 'PCS', 600, 4, null, null, null, null, null, null, 6.5, 0, 26);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f86001d', '402895c15161c91d015161ca3f710000', '7', '5144', 'PCS', 152, 1, null, null, null, null, null, null, 11, 0, 13);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f86001e', '402895c15161c91d015161ca3f710000', '2', '5117', 'PCS', 300, 1, null, null, null, null, null, null, 17, 0, 13);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f860020', '402895c15161c91d015161ca3f710000', '4', '5337', 'PCS', 156, 1, null, null, null, null, null, null, 8, 0, 22);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f860022', '402895c15161c91d015161ca3f710000', '4', '5330', 'PCS', 156, 1, null, null, null, null, null, null, 8, 0, 20);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f860024', '402895c15161c91d015161ca3f710000', '2', '8759', 'PCS', 600, 1, null, null, null, null, null, null, 15, 0, 27);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f870025', '402895c15161c91d015161ca3f710000', '4', '4994', 'PCS', 300, 1, null, null, null, null, null, null, 8.5, 0, 2);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f870027', '402895c15161c91d015161ca3f710000', '9', '5190', 'PCS', 100, 1, null, null, null, null, null, null, 8.5, 0, 15);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f870028', '402895c15161c91d015161ca3f710000', '4', '4996', 'PCS', 300, 1, null, null, null, null, null, null, 10.5, 0, 4);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f87002a', '402895c15161c91d015161ca3f710000', '2', '844MA', 'PCS', 600, 1, null, null, null, null, null, null, 16, 0, 24);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f87002b', '402895c15161c91d015161ca3f710000', '9', '5190', 'PCS', 100, 1, null, null, null, null, null, null, 2.4, 0, 18);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f87002c', '402895c15161c91d015161ca3f710000', '2', '843MA', 'PCS', 600, 1, null, null, null, null, null, null, 16, 0, 23);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f88002d', '402895c15161c91d015161ca3f710000', '9', '5191', 'PCS', 100, 1, null, null, null, null, null, null, 10, 0, 18);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f88002e', '402895c15161c91d015161ca3f710000', '2', '5117', 'PCS', 100, 1, null, null, null, null, null, null, 17, 0, 11);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f880030', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5083', 'PCS', 300, 1, null, null, null, null, null, null, 11.5, 0, 7);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f880031', '402895c15161c91d015161ca3f710000', '2', '9868', 'PCS', 600, 1, null, null, null, null, null, null, 16, 0, 29);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f890032', '402895c15161c91d015161ca3f710000', '7', '9749', 'PCS', 600, 4, null, null, null, null, null, null, 6.5, 0, 28);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f890033', '402895c15161c91d015161ca3f710000', '4', '4993', 'PCS', 300, 1, null, null, null, null, null, null, 8.5, 0, 1);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f890035', '402895c15161c91d015161ca3f710000', '1', '5190', 'PCS', 100, 1, null, null, null, null, null, null, 22, 0, 16);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f890036', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5093', 'PCS', 102, 1, null, null, null, null, null, null, 16, 0, 6);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f890037', '402895c15161c91d015161ca3f710000', '7', '5098', 'PCS', 152, 1, null, null, null, null, null, null, 11, 0, 9);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8a0038', '402895c15161c91d015161ca3f710000', '4', '5400', 'PCS', 300, 1, null, null, null, null, null, null, 11.5, 0, 22);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8a003a', '402895c15161c91d015161ca3f710000', '4', '5337', 'PCS', 300, 1, null, null, null, null, null, null, 8, 0, 21);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8a003c', '402895c15161c91d015161ca3f710000', '2', '5118', 'PCS', 300, 1, null, null, null, null, null, null, 16, 0, 14);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8b003e', '402895c15161c91d015161ca3f710000', '4', '5331', 'PCS', 300, 1, null, null, null, null, null, null, 11.5, 0, 19);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8d0040', '402895c15161c91d015161ca3f710000', '9', '5191', 'PCS', 100, 1, null, null, null, null, null, null, 2.4, 0, 19);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8d0041', '402895c15161c91d015161ca3f710000', '4028817a33d4f8b40133d9989f5e0024', '5088', 'PCS', 300, 1, null, null, null, null, null, null, 13, 0, 11);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8e0042', '402895c15161c91d015161ca3f710000', '1', '5191', 'PCS', 100, 1, null, null, null, null, null, null, 32, 0, 17);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('402895c15161c91d015161ca3f8e0043', '402895c15161c91d015161ca3f710000', '4', '4995', 'PCS', 300, 1, null, null, null, null, null, null, 8.5, 0, 3);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('4028a9ba516a93b301516a9fea0f0001', '4028a9ba516a93b301516a9fea090000', '2', '2964', 'PCS', 144, 1, 1, null, null, null, null, null, 24, 0, 1);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('4028a9ba516a93b301516a9fea0f0003', '4028a9ba516a93b301516a9fea090000', '2', '2977', 'PCS', 144, 1, null, null, 5, null, 5, null, 17, 0, 4);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('4028a9ba516a93b301516a9fea0f0004', '4028a9ba516a93b301516a9fea090000', '3', 'JK1700011', 'PCS', 504, 24, null, 2, null, null, null, 2, 4.6, 0, 1);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('4028a9ba516a93b301516a9fea0f0005', '4028a9ba516a93b301516a9fea090000', '2', '2965', 'PCS', 144, 1, null, null, 3, null, 3, null, 17, 0, 2);
insert into EXPORT_PRODUCT_C (EXPORT_PRODUCT_ID, EXPORT_ID, FACTORY_ID, PRODUCT_NO, PACKING_UNIT, CNUMBER, BOX_NUM, GROSS_WEIGHT, NET_WEIGHT, SIZE_LENGTH, SIZE_WIDTH, SIZE_HEIGHT, EX_PRICE, PRICE, TAX, ORDER_NO)
values ('4028a9ba516a93b301516a9fea100007', '4028a9ba516a93b301516a9fea090000', '2', '2976', 'PCS', 144, 1, null, null, null, 4, null, null, 17, 0, 3);
commit;
prompt 56 records loaded
prompt Loading EXT_CPRODUCT_C...
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fcdff5490012', '4028817a33d4f8b40133d9bea39b0032', '20', '喜福来', 'JK1050807/JK033', null, '套6全明料酒杯\r\n杯碗电镀渐变色，挺底电镀\r\n尺寸：8X24CM高', 'SETS', 300, 21, 6300, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月15日/工厂。                          没有经过我司同意无故' || chr(10) || '' || chr(10) || '延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fcdff5490013', '4028817a33d4f8b40133d9bea39b0030', '20', '喜福来', 'JK1050806/JK032', null, '套6全明料香槟杯\r\n杯碗电镀渐变色，挺底电镀\r\n尺寸：5.7X25CM高', 'SETS', 320, 21, 6720, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2011年12月15日/工厂。                          没有经过我司同意无故' || chr(10) || '' || chr(10) || '延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fd906b0d0029', '4028817a33fc4e280133fd81e7d70027', '19', '综艺花纸', 'JK1040009/141760', null, '白色字母花纸 \r\n送祁县宏艺厂', 'PCS', 300, .9, 270, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月25日；', 3);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fd906b0d002a', '4028817a33fc4e280133fd81e7d7001f', '19', '综艺花纸', 'J859102682/113860', null, '白色字母花纸\r\nSTORAGE ONLY\r\n祁县宏艺厂', 'PCS', 300, .4, 120, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月25日；', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fd906b0d002b', '4028817a33fc4e280133fd81e7d70026', '19', '综艺花纸', 'JK10501218/160380', null, '白' || chr(10) || '' || chr(10) || '色字母花纸 \r\n送祁县宏艺厂', 'PCS', 600, .4, 240, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月25日；', 4);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353cadeab80037', '4028817a3420e78a013421a693820005', '19', '综艺花纸', '5118', 'undefined', '白金字母花纸\r\nSWEETS\r\n送祁县光华厂', 'PCS', 300, 3, 900, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2012' || chr(10) || '' || chr(10) || '年1月15日。', 12);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353cadec6d003a', '4028817a3420e78a013421d2e3fe0013', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5336', 'c8350cd2-47ae-4054-ad81-70004fe4eb44.jpg', '全明料死模风灯，电镀花银喷绿色      \r\n 尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日送', 'PCS', 300, 3, 900, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 8);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353cadec6d0044', '4028817a3420e78a013421e2e3c10016', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5400', '601585a1-ba16-42bb-9ffb-' || chr(10) || '' || chr(10) || 'd187b521be1f.jpg', '全明料死模风灯，电镀花银喷蓝色      \r\n尺寸：17X23CM高      \r\n1只/五层内盒      6只/大箱      \r\n毛坯1月30日送', 'PCS', 300, 3.5, 1050, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 10);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353d39f06c005d', '4028817a353b8d8e01353d32350d0051', '19', '综艺花纸', '5117', 'aec0cd7f-795e-4c5f-b8c5-532b6479c4be.jpg', '白金字母花纸\r\nSWEETS\r\n安全包装送祁县光华厂', 'PCS', 100, 3, 300, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2012' || chr(10) || '' || chr(10) || '年2月5日。', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353d39f06c005e', '4028817a353b8d8e01353d32350d005b', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5336', '4436f9d7-b0e2-4926-9cd4-f6c66333c290.jpg', '全明料死模风灯，电镀花银喷绿色      \r\n       \r\n尺寸：14.5X20CM高 \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日送', 'PCS', 156, 3, 468, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 4);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353d39f06c005f', '4028817a353b8d8e01353d32350d005a', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5330', 'be775015-234a-4504-ad52-af6af53d2a9c.jpg', '全明料死模风灯，电镀花银喷紫色      \r\n      \r\n尺寸：14.5X20CM高\r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日送', 'PCS', 156, 3, 468, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 3);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353d39f06c0060', '4028817a353b8d8e01353d32350d0055', '19', '综艺花纸', '5118', 'undefined', '白金字母花纸\r\nSWEETS\r\n安全包装送祁县光华厂', 'PCS', 100, 3, 300, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2012' || chr(10) || '' || chr(10) || '年2月5日。', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353d39f06c0061', '4028817a353b8d8e01353d32350d0057', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5337', '673a4e11-3706-4beb-b958-' || chr(10) || '' || chr(10) || 'ee1d7c564b3b.jpg', '全明料死模风灯，电镀花银喷蓝色      \r\n       \r\n尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱' || chr(10) || '' || chr(10) || '    \r\n毛坯1月30日送', 'PCS', 156, 3, 468, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 5);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fd906b0d002c', '4028817a33fc4e280133fd81e7d70021', '19', '综艺花纸', '123540', null, '白色字母花纸(HIGH TEA)\r\n字体：ENGLISH SCRIPT\r\n尺寸：18X5.5CM\r\n祁县光华厂', 'PCS', 100, .3, 30, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月25日；', 5);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fd906b0d002d', '4028817a33fc4e280133fd81e7d70022', '19', '综艺花纸', 'JK1052446/158080', null, '白色字母花纸\r\n\r\n \r\n祁县会龙厂', 'PCS', 702, .25, 175.5, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月25日；', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fd906b0d002e', '4028817a33fc4e280133fd81e7d7001e', '19', '综艺花纸', '169280', 'undefined', '白色字母花纸(HIGH TEA)\r\n字体：ENGLISH SCRIPT\r\n尺寸：18X5.5CM\r\n祁县光华厂', 'PCS', 100, .3, 30, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月25日；', 6);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fded2e6d0040', '4028817a33fc4e280133fde6504f0039', '19', '综艺花纸', 'JK169340/13076', 'undefined', '蒙砂白花纸\r\n\"烤在蛋糕罩子上(25X26CM)\r\n\"\r\n祁县光华厂', 'PCS', 200, 1.02, 204, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月20日', 4);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fded2e6d0041', '4028817a33fc4e280133fde6504f0038', '19', '综艺花纸', 'JK1050198/12860', 'undefined', '蒙砂白花纸\r\n烤在红酒杯（11X19CM)上\r\n送平遥鸿艺', 'PCS', 400, .49, 196, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月20日', 3);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fded2e6d0042', '4028817a33fc4e280133fde6504f003c', '19', '综艺花纸', 'JK1050195/12859', 'undefined', '蒙砂白花纸\r\n烤在香槟杯(8X21CM)上\r\n送平遥鸿艺', 'PCS', 400, .4, 160, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月20日', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fded2e6d0043', '4028817a33fc4e280133fde6504f0037', '19', '综艺花纸', 'JK1050201/12078', null, '蒙砂白花纸\r\n烤在蛋糕罩子上\r\n祁县光华厂', 'PCS', 402, .8, 321.6, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月20日；', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd3200001', '4028817a33812ffd0133816aacd40019', '22', '瑞成', '4998', 'undefined', '全明料死模风灯 ，电镀花银喷紫色\r\n尺寸：11.5X30.5CM', 'PCS', 300, 1.7, 510, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 6);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0002', '4028817a33812ffd0133816aacd40017', '19', '综艺花纸', '5117', 'undefined', '白金字母花纸\r\nSWEETS\r\n送祁县光华厂', 'PCS', 300, 3, 900, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月30日；', 12);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0003', '4028817a33812ffd0133813f25a30002', '22', '瑞成', '4993', null, '全明料死模风灯，电镀花银喷绿色\r\n尺寸：11.5X20.3CM\r\n毛坯1月25日送', 'PCS', 300, 1.7, 510, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0004', '4028817a33812ffd0133816aacd40018', '22', '瑞成', '5400', 'undefined', '全明料死模风灯，电镀花银喷蓝色\r\n尺寸：17X23CM高', 'PCS', 300, 3.5, 1050, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 10);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0005', '4028817a33812ffd0133816aacd4000d', '22', '瑞成', '4996', 'undefined', '全明料死模风灯，电镀花银喷绿色\r\n尺寸：11.5X30.5CM高', 'PCS', 300, 1.7, 510, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 4);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0006', '4028817a33812ffd0133816aacd40014', '22', '瑞成', '5336', null, '全明料死模风灯，电镀花银喷绿色\r\n尺寸：14.5X20CM高', 'PCS', 300, 2, 600, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致，\r\n       并将验货照片传回' || chr(10) || '' || chr(10) || '公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重后' || chr(10) || '' || chr(10) || '果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 8);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0007', '4028817a33812ffd0133813f25a30003', '22', '瑞成', '4994', 'undefined', '全明料死模风灯，电镀花银喷蓝色\r\n尺寸：11.5X20.3CM高', 'PCS', 300, 1.7, 510, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f0009', '4028817a33812ffd0133816aacd4000c', '22', '瑞成', '4997', null, '全明料死模风灯，电镀花银喷蓝色\r\n尺寸：11.5X30.5CM高', 'PCS', 300, 1.7, 510, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 5);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f000a', '4028817a33812ffd0133816aacd40012', '19', '综艺花纸', '5118', 'undefined', '白金字母花纸\r\nSWEETS\r\n送祁县光华厂', 'PCS', 600, 3, 1800, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月30日；', 13);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f000b', '4028817a33812ffd0133816aacd40015', '22', '瑞成', '5337', null, '全明料死模风灯，电镀花银喷蓝色\r\n尺寸：14.5X20CM高', 'PCS', 300, 2, 600, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 9);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f000c', '4028817a33812ffd0133816aacc40009', '22', '瑞成', '5331', 'undefined', '全明料死模风灯，电镀花银喷绿色\r\n尺寸：17X23CM高', 'PCS', 300, 3.5, 1050, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 7);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a343a5c9101343a6fd35f000d', '4028817a33812ffd0133813f25a30004', '22', '瑞成', '4995', 'undefined', '全明料死模风灯，电镀花银喷紫色\r\n尺寸：11.5X20.3CM', 'PCS', 300, 1.7, 510, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年1月10日/工厂。\r\n       没有经过我司同意无故延期交货造成严重' || chr(10) || '' || chr(10) || '后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 3);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353cad7b730023', '4028817a3420e78a013421a693820007', '19', '综艺花纸', '5117', 'undefined', '白金字母花纸\r\nSWEETS\r\n送祁县光华厂', 'PCS', 300, 3, 900, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2012' || chr(10) || '' || chr(10) || '年1月15日。', 11);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353cad7b730024', '4028817a3420e78a013421e2e3c1001a', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5337', 'e877a4e2-2e48-4b06-91a8-3fb64f150a0f.jpg', '全明料死模风灯，电镀花银喷蓝色      \r\n尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日送', 'PCS', 300, 3, 900, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 9);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a353b8d8e01353cad7b73002b', '4028817a3420e78a013421d2e3fe0014', '4028817a33ecdbf70133ee202e49000b', '瑞成电镀厂', '5331', '51902cb9-1650-480b-8373-2da4c3f2338b.jpg', '全明料死模风灯，电镀花银喷绿色      \r\n尺寸：17X23CM高      \r\n1只/五层内盒      6只/大箱      \r\n毛坯1月30日送', 'PCS', 300, 3.5, 1050, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传' || chr(10) || '' || chr(10) || '回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果' || chr(10) || '' || chr(10) || '的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 7);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a3357462e013359291f540007', '4028817a3357462e0133591b86ec0003', '16', '康达', '2965', 'undefined', '彩盒，新菲林\r\n配全明料糖缸带盖子\r\n彩盒尺寸：20X20X41CM', 'PCS', 144, 3.2, 460.8, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11月05日。', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a3357462e013359291f640008', '4028817a3357462e0133591b86ec0004', '16', '康达', '2964', null, '彩盒，新菲林\r\n配全明料糖缸带盖子\r\n彩盒尺寸：22.5X22.5X48.5CM', 'PCS', 144, 4, 576, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11月05日。', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a3357462e013359291f640009', '4028817a3357462e0133592355750006', '16', '康达', '2976', 'undefined', '彩盒，新菲林\r\n配明料糖缸带盖子\r\n彩盒尺寸：25.7X25.7X35.7CM', 'PCS', 144, 3.9, 561.6, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11月05日。', 4);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a3357462e013359291f64000a', '4028817a3357462e0133592355750006', '16', '康达', '2976', 'undefined', '彩盒，新菲林\r\n配全明料糖缸带盖子\r\n彩盒尺寸：21.5X21.5X41CM', 'PCS', 144, 3.3, 475.2, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11月05日。', 3);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33d4f8b40133d994c45e0021', '4028817a33d4f8b40133d9878e880014', '19', '综艺花纸', 'JK169340/13076', 'undefined', '蒙砂白花纸\r\n烤在蛋糕罩上\r\n送祁县光华厂', 'PCS', 464, 1.02, 473.28, '1.产品的颜色、造型、尺寸、务必同我司提供样稿一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月20日。', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33d4f8b40133d994c45e0022', '4028817a33d4f8b40133d9878e880016', '19', '综艺花纸', 'JK1050201/12078', null, '蒙砂白花纸\r\n烤在蛋糕罩上\r\n送祁县光华厂', 'PCS', 204, .8, 163.2, '1.产品的颜色、造型、尺寸、务必同我司提供的样稿一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交' || chr(10) || '' || chr(10) || '期:2011年11月20日送指定工厂。', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33ecdbf70133edfc84d40001', '4028817a3357462e01336d3a0be10018', '19', '综艺花纸', 'JK1014005', '94d2d773-24b6-412e-b0e3-0fc9dddf0955.png', '低温鱼花纸\r\n明料低口杯\r\n祁县宏艺厂', 'PCS', 1800, 1.2, 2160, '1.产品的颜色、造型、尺寸、务必同提供的样品一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011年' || chr(10) || '' || chr(10) || '12月10；', 4);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33ecdbf70133edfc84e40002', '4028817a3357462e01336d3a0be10019', '19', '综艺花纸', 'JK1080766-3', '29bb909d-d527-475d-bfbe-e5e05a02349c.png', '套3白花纸\r\n\r\n送祁县宏艺厂', 'SETS', 600, .6, 360, '1.产品的颜色、造型、尺寸、务必同提供的样品一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011年' || chr(10) || '' || chr(10) || '12月10；', 1);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33ecdbf70133edfc84e40003', '4028817a3357462e01336d3a0be10017', '19', '综艺花纸', 'JK1014006', '7be85008-7652-4995-aaca-3ade8405eca9.png', '套6彩色花纸\r\n明料低口杯\r\n祁县宏艺厂', 'SETS', 300, 9, 2700, '1.产品的颜色、造型、尺寸、务必同提供的样品一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011年' || chr(10) || '' || chr(10) || '12月10；', 5);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33ecdbf70133edfc84e40004', '4028817a3357462e01336d3a0be10016', '19', '综艺花纸', 'JK1014001', '7a3d341f-f473-44ce-9bd4-c7f2b87343ca.png', '低温鱼花纸\r\n明料大碗\r\n送祁县宏艺厂', 'PCS', 1000, 2.4, 2400, '1.产品的颜色、造型、尺寸、务必同提供的样品一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011年' || chr(10) || '' || chr(10) || '12月10；', 2);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33ecdbf70133edfc84e40005', '4028817a3357462e01336d3a0be10015', '19', '综艺花纸', 'JK1014003', '73980c53-44f6-4232-8c04-9d08a66eeccb.png', '低温鱼花纸\r\n明料盘子\r\n\r\n送祁县天顺厂', 'PCS', 1200, 3.8, 4560, '1.产品的颜色、造型、尺寸、务必同提供的样品一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011年' || chr(10) || '' || chr(10) || '12月10；', 3);
insert into EXT_CPRODUCT_C (EXT_CPRODUCT_ID, CONTRACT_PRODUCT_ID, FACTORY_ID, FACTORY_NAME, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, PACKING_UNIT, CNUMBER, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028817a33fc4e280133fcdff5490011', '4028817a33fc4e280133fcdb13f40010', '19', '综艺花纸', 'JK046/JK1050201', 'undefined', '蒙砂白花纸\r\n烤在蛋糕罩子上\r\n送祁县光华厂', 'PCS', 600, .8, 480, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2011' || chr(10) || '' || chr(10) || '年11月15日；', 3);
commit;
prompt 47 records loaded
prompt Loading EXT_EPRODUCT_C...
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f7c000b', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f7c000a', '4997', '7dbc495e-a12c-4eec-9975-c93c1b3f4297.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷浅蓝色\r\n明料挺底      \r\n尺寸：11.5X30.5CM高    \r\n1只/五层内盒      6只/大箱  \r\n毛坯1月30日送', 300, 'PCS', 1.7, 510, '' || chr(10) || '' || chr(10) || '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公' || chr(10) || '' || chr(10) || '司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果的，' || chr(10) || '' || chr(10) || '按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 5);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f7e0012', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f7e0011', '4998', '44fc2f77-af8a-42d3-8d9b-fa2bafa8f47a.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷浅紫色\r\n明料挺底      \r\n尺寸：11.5X30.5CM高    \r\n1只/五层内盒      6只/大箱  \r\n毛坯1月30日送', 300, 'PCS', 1.7, 510, '' || chr(10) || '' || chr(10) || '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公' || chr(10) || '' || chr(10) || '司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。毛坯送至祁县瑞成玻璃镀膜厂。 \r\n       没有经过我司' || chr(10) || '' || chr(10) || '同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 6);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f840014', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f7e0013', '5336', '4436f9d7-b0e2-4926-9cd4-f6c66333c290.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷绿色      \r\n       \r\n尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 156, 'PCS', 3, 468, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致，' || chr(10) || '' || chr(10) || '\r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意' || chr(10) || '' || chr(10) || '无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 4);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f850017', '19', '402895c15161c91d015161ca3f840016', '5118', 'undefined', '白金字母花纸\r\nSWEETS\r\n安全包装送祁县光华' || chr(10) || '' || chr(10) || '厂', 100, 'PCS', 3, 300, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合' || chr(10) || '' || chr(10) || '同号及货号；\r\n3.交期:2012年2月5日。', 2);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f86001f', '19', '402895c15161c91d015161ca3f86001e', '5117', 'undefined', '白金字母花纸\r\nSWEETS\r\n送' || chr(10) || '' || chr(10) || '祁县光华厂', 300, 'PCS', 3, 900, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相' || chr(10) || '' || chr(10) || '对应的合同号及货号；\r\n3.交期:2012年1月15日。', 11);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f860021', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f860020', '5337', '673a4e11-3706-4beb-b958-ee1d7c564b3b.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷蓝色      \r\n       \r\n尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 156, 'PCS', 3, 468, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致，' || chr(10) || '' || chr(10) || '\r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意' || chr(10) || '' || chr(10) || '无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 5);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f860023', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f860022', '5330', 'be775015-234a-4504-ad52-af6af53d2a9c.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷紫色      \r\n      \r\n尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 156, 'PCS', 3, 468, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致，' || chr(10) || '' || chr(10) || '\r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意' || chr(10) || '' || chr(10) || '无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 3);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f870026', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f870025', '4994', '05b37ddc-8904-4df3-8167-b98129c600de.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷浅蓝色\r\n明料挺底      \r\n尺寸：11.5X20.3CM    \r\n1只/五层内盒     12只/大箱  \r\n毛坯1月30日送', 300, 'PCS', 1.7, 510, '' || chr(10) || '' || chr(10) || '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公' || chr(10) || '' || chr(10) || '司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。毛坯送至祁县瑞成玻璃镀膜厂。 \r\n       没有经过我司' || chr(10) || '' || chr(10) || '同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 2);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f870029', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f870028', '4996', '987692c0-6e47-4117-b6c8-3dbbeaca1b0c.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷浅绿色\r\n明料挺底      \r\n尺寸：11.5X30.5CM高    \r\n1只/五层内盒      6只/大箱  \r\n毛坯1月30日送', 300, 'PCS', 1.7, 510, '' || chr(10) || '' || chr(10) || '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公' || chr(10) || '' || chr(10) || '司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。毛坯送至祁县瑞成玻璃镀膜厂。 \r\n       没有经过我司' || chr(10) || '' || chr(10) || '同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 4);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f88002f', '19', '402895c15161c91d015161ca3f88002e', '5117', 'aec0cd7f-795e-4c5f-b8c5-532b6479c4be.jpg', '白金字母花纸\r\nSWEETS\r\n安全包装送祁县' || chr(10) || '' || chr(10) || '光华厂', 100, 'PCS', 3, 300, '1.产品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应' || chr(10) || '' || chr(10) || '的合同号及货号；\r\n3.交期:2012年2月5日。', 1);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f7c0009', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f7b0008', '5336', 'c8350cd2-47ae-4054-ad81-70004fe4eb44.jpg', '全' || chr(10) || '' || chr(10) || '明料死模风灯，电镀花银喷绿色      \r\n 尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 300, 'PCS', 3, 900, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致，' || chr(10) || '' || chr(10) || '\r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意' || chr(10) || '' || chr(10) || '无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 8);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f890034', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f890033', '4993', 'a803fa9e-dda1-476a-a822-a51b226aca39.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷浅绿色 \r\n明料挺底      \r\n尺寸：11.5X20.3CM    \r\n1只/五层内盒      12只/大箱  \r\n毛坯1月30日送', 300, 'PCS', 1.7, 510, '' || chr(10) || '' || chr(10) || '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公' || chr(10) || '' || chr(10) || '司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意无故延期交货造成严重后果的，' || chr(10) || '' || chr(10) || '按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 1);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f8a0039', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f8a0038', '5400', '601585a1-ba16-42bb-9ffb-d187b521be1f.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷蓝色      \r\n尺寸：17X23CM高      \r\n1只/五层内盒      6只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 300, 'PCS', 3.5, 1050, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致' || chr(10) || '' || chr(10) || '， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司' || chr(10) || '' || chr(10) || '同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 10);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f8a003b', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f8a003a', '5337', 'e877a4e2-2e48-4b06-91a8-3fb64f150a0f.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷蓝色      \r\n尺寸：14.5X20CM高      \r\n1只/五层内盒      12只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 300, 'PCS', 3, 900, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致，' || chr(10) || '' || chr(10) || '\r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司同意' || chr(10) || '' || chr(10) || '无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 9);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f8b003d', '19', '402895c15161c91d015161ca3f8a003c', '5118', 'undefined', '白金字母花纸\r\nSWEETS\r\n送祁县光华厂', 300, 'PCS', 3, 900, '1.产' || chr(10) || '' || chr(10) || '品的颜色、造型、尺寸、重量务必同我司封样一致；\r\n2.工厂免费提供2% 余量，以防损耗，代用包装送至指定工厂；请在外包装上注明相对应的合同号及货号；\r\n3.交期:2012年1月15日' || chr(10) || '' || chr(10) || '。', 12);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f8b003f', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f8b003e', '5331', '51902cb9-1650-480b-8373-2da4c3f2338b.jpg', '全' || chr(10) || '' || chr(10) || '明料死模风灯，电镀花银喷绿色      \r\n尺寸：17X23CM高      \r\n1只/五层内盒      6只/大箱      \r\n毛坯1月30日' || chr(10) || '' || chr(10) || '送', 300, 'PCS', 3.5, 1050, '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致' || chr(10) || '' || chr(10) || '， \r\n       并将验货照片传回公司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。       没有经过我司' || chr(10) || '' || chr(10) || '同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 7);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('402895c15161c91d015161ca3f8e0044', '4028817a33ecdbf70133ee202e49000b', '402895c15161c91d015161ca3f8e0043', '4995', 'b232e729-a02f-48b2-987b-2c6311827816.jpg', '全明料死模' || chr(10) || '' || chr(10) || '风灯，电镀花银喷浅紫色\r\n明料挺底      \r\n尺寸：11.5X20.3CM    \r\n1只/五层内盒     12只/大箱  \r\n毛坯1月30日送', 300, 'PCS', 1.7, 510, '' || chr(10) || '' || chr(10) || '★   产品与封样无明显差异，唛头、标签及包装质量务必符合公司要求。 \r\n ★★  产品生产前期、中期、后期抽验率不得少于10%，质量和封样一致， \r\n       并将验货照片传回公' || chr(10) || '' || chr(10) || '司。 \r\n★★★ 重点客人的质量标准检验，产品抽验率不得少于50%，务必做到入箱前检查。 \r\n 交期：2012年2月15日/工厂。毛坯送至祁县瑞成玻璃镀膜厂。 \r\n       没有经过我司' || chr(10) || '' || chr(10) || '同意无故延期交货造成严重后果的，按照客人的相关要求处理。 \r\n 开票：出货后请将增值税发票、验货报告、合同复印件及出库单一并寄至我司，以便我司安排付款。', 3);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028a9ba516a93b301516a9fea0f0002', '16', '4028a9ba516a93b301516a9fea0f0001', '2964', null, '彩盒，新菲林\r\n配全明料糖缸带盖子\r\n彩盒尺寸：' || chr(10) || '' || chr(10) || '22.5X22.5X48.5CM', 144, 'PCS', 4, 576, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11' || chr(10) || '' || chr(10) || '月05日。', 1);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028a9ba516a93b301516a9fea100006', '16', '4028a9ba516a93b301516a9fea0f0005', '2965', 'undefined', '彩盒，新菲林\r\n配全明料糖缸带盖子\r\n彩盒尺寸：' || chr(10) || '' || chr(10) || '20X20X41CM', 144, 'PCS', 3.2, 460.8, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11月05日' || chr(10) || '' || chr(10) || '。', 2);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028a9ba516a93b301516a9fea100008', '16', '4028a9ba516a93b301516a9fea100007', '2976', 'undefined', '彩盒，新菲林\r\n配明料糖缸带盖子\r\n彩盒尺寸：' || chr(10) || '' || chr(10) || '25.7X25.7X35.7CM', 144, 'PCS', 3.9, 561.6, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11' || chr(10) || '' || chr(10) || '月05日。', 4);
insert into EXT_EPRODUCT_C (EXT_EPRODUCT_ID, FACTORY_ID, EXPORT_PRODUCT_ID, PRODUCT_NO, PRODUCT_IMAGE, PRODUCT_DESC, CNUMBER, PACKING_UNIT, PRICE, AMOUNT, PRODUCT_REQUEST, ORDER_NO)
values ('4028a9ba516a93b301516a9fea100009', '16', '4028a9ba516a93b301516a9fea100007', '2976', 'undefined', '彩盒，新菲林\r\n配全明料糖缸带盖子\r\n彩盒尺寸：' || chr(10) || '' || chr(10) || '21.5X21.5X41CM', 144, 'PCS', 3.3, 475.2, '1.彩盒要求350克面纸；\r\n2.工厂待用安全包装，待我司运至工厂；\r\n3.工厂免费提供1%余量，以防划伤，破损；\r\n4.交期:2011年11月' || chr(10) || '' || chr(10) || '05日。', 3);
commit;
prompt 21 records loaded
prompt Loading LOGIN_LOG_P...
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('00330EC5-4F2C-48BB-AFC1-ADC5CBAEB7AC', '001|调试', '192.168.1.110', to_date('17-01-2012 14:04:46', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('009275C9-7459-4862-B339-C7CD13C244D6', '001|调试', '192.168.1.110', to_date('17-01-2012 11:57:33', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('00D0157A-AD60-4856-802E-A3461F6939E0', '001|调试', '127.0.0.1', to_date('07-10-2011 12:37:29', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('00DA73C6-8DB4-402A-BEE0-95BDD79D0CDB', '001|调试', '192.168.1.103', to_date('11-09-2012 10:56:23', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('011BD53F-99AF-4B45-B23B-4E02723BE7D7', '001|调试', '192.168.1.106', to_date('29-10-2012 14:23:51', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('015CC22A-5C53-4597-B4AC-B51694D75C86', '001|调试', '192.168.1.103', to_date('20-01-2012 16:03:49', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('01970044-E8A0-41DD-A7CB-EF0E012FE798', '001|调试', '192.168.1.103', to_date('18-01-2012 11:40:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('01C6DB18-D8AC-48CE-B3F2-09BCDFD8D9A3', '001|调试', '127.0.0.1', to_date('21-08-2011 22:34:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('01F90304-E542-4B5E-9B3B-E49C17B6E891', '001|调试', '192.168.1.106', to_date('18-10-2011 11:15:42', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('02AF06BD-65E4-4E02-8128-9E43B2AE06B6', 'anonymous|', '192.168.1.109', to_date('14-08-2012 09:54:00', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('02B4B900-9D3F-4306-8F54-6395FDB5234A', '001|调试', '192.168.1.106', to_date('29-10-2012 14:38:24', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('02E0CA26-C6E2-4C90-B94C-4CB7C63A7971', '001|调试', '127.0.0.1', to_date('26-09-2011 19:48:13', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('03C5ACAB-C6C4-456F-9B3D-64A80BBECADA', '001|调试', '127.0.0.1', to_date('18-09-2011 22:49:41', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('03ED9524-0BBA-4082-8FA6-2F6BA905A627', '001|调试', '127.0.0.1', to_date('21-09-2011 19:32:38', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('042027CF-496F-4C79-BDD8-F3BFC05EDBCC', 'anonymous|', '192.168.1.114', to_date('20-01-2012 12:15:28', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('0451DE27-3C35-4054-B27B-80EC5F5303E9', '001|调试', '127.0.0.1', to_date('20-08-2011 00:14:17', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('0464165A-6013-4AF8-8ED3-9350369780ED', '001|调试', '127.0.0.1', to_date('01-10-2011 21:39:43', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('04ED9BC3-FB5F-4F89-9DF6-5F34FE0ACB26', '001|调试', '127.0.0.1', to_date('26-08-2011 20:19:15', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('05586466-481A-4426-A237-D06BB78FA27A', '001|调试', '192.168.1.110', to_date('09-02-2012 10:33:01', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('06376BC7-200F-442A-85F4-27578A9BAA54', 'anonymous|', '192.168.1.114', to_date('20-01-2012 11:53:21', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('06767A52-69EC-430D-B15C-9BDB0952CF53', 'anonymous|', '192.168.1.105', to_date('16-04-2012 16:00:36', 'dd-mm-yyyy hh24:mi:ss'));
insert into LOGIN_LOG_P (LOGIN_LOG_ID, LOGIN_NAME, IP_ADDRESS, LOGIN_TIME)
values ('07C0244F-BFAC-45D4-945A-91B1E7B060F4', 'anonymous|', '192.168.1.111', to_date('06-09-2012 09:19:19', 'dd-mm-yyyy hh24:mi:ss'));
commit;
prompt 22 records loaded
prompt Loading MODULE_DICT_P...
prompt Table is empty
prompt Loading ONLINE_INFO_T...
insert into ONLINE_INFO_T (A1)
values ('00');
insert into ONLINE_INFO_T (A1)
values ('01');
insert into ONLINE_INFO_T (A1)
values ('02');
insert into ONLINE_INFO_T (A1)
values ('03');
insert into ONLINE_INFO_T (A1)
values ('04');
insert into ONLINE_INFO_T (A1)
values ('05');
insert into ONLINE_INFO_T (A1)
values ('06');
insert into ONLINE_INFO_T (A1)
values ('07');
insert into ONLINE_INFO_T (A1)
values ('08');
insert into ONLINE_INFO_T (A1)
values ('09');
insert into ONLINE_INFO_T (A1)
values ('10');
insert into ONLINE_INFO_T (A1)
values ('11');
insert into ONLINE_INFO_T (A1)
values ('12');
insert into ONLINE_INFO_T (A1)
values ('13');
insert into ONLINE_INFO_T (A1)
values ('14');
insert into ONLINE_INFO_T (A1)
values ('15');
insert into ONLINE_INFO_T (A1)
values ('16');
insert into ONLINE_INFO_T (A1)
values ('17');
insert into ONLINE_INFO_T (A1)
values ('18');
insert into ONLINE_INFO_T (A1)
values ('19');
insert into ONLINE_INFO_T (A1)
values ('20');
insert into ONLINE_INFO_T (A1)
values ('21');
insert into ONLINE_INFO_T (A1)
values ('22');
insert into ONLINE_INFO_T (A1)
values ('23');
commit;
prompt 24 records loaded
prompt Loading PACKING_LIST_C...
insert into PACKING_LIST_C (PACKING_LIST_ID, SELLER, BUYER, INVOICE_NO, INVOICE_DATE, MARKS, DESCRIPTIONS, EXPORT_IDS, EXPORT_NOS, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME)
values ('402899d050a3727d0150a372acfe0000', 'A1', 'D1', 'B1', to_date('30-09-2015', 'dd-mm-yyyy'), 'C1', 'E1', '402899d050992bbd0150992c516b0000', 'C/3817/11 11JK1080 ', 0, null, null, null);
commit;
prompt 1 records loaded
prompt Loading ROLE_MODULE_P...
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '5');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '501');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ebf8430001', '502');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '3');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1c34ec2e5c8014ec2ec38cc0002', '302');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '6');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '601');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '602');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '603');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0000', '604');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '3');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '302');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '4');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '401');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '402');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '5');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '501');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '502');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '503');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '504');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '6');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '601');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0001', '602');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '4');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '401');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '5');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '501');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '502');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0002', '503');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0004', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '102');
commit;
prompt 100 records committed...
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '3');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0006', '302');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '3');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '302');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '4');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '401');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '402');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '5');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '501');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '502');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '503');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '504');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '6');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '601');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '602');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '603');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0007', '604');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '1');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '101');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '102');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '103');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '2');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '201');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '202');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '203');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '204');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '205');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '206');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '207');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '208');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '3');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '302');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '4');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '401');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '402');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '5');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '501');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '502');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '503');
insert into ROLE_MODULE_P (ROLE_ID, MODULE_ID)
values ('4028a1cd4ee2d9d6014ee2df4c6a0008', '504');
commit;
prompt 163 records loaded
prompt Loading USER_P...
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('aca5520d-b970-430d-b7eb-62efae670e09', '297ef78a61176f410161176fd7930000', 'zbz2', 'f974703ad3eb086dba5484e4e241340d', 1, null, null, to_timestamp('17-02-2018 14:25:07.526000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('002108e2-9a10-4510-9683-8d8fd1d374ef', '4028827c4fb6202a014fb6209c730000', 'lw', '054d482f7b4d3633da1969b1c5c7f70e', 1, null, null, to_timestamp('18-10-2015 17:00:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('18-10-2015 17:00:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('18077bdb-8dd3-4aae-95a2-078c963f8416', '4028827c4fb6202a014fb6209c730000', 'lisi', '42bd4e7685cb11d3ba02716c313cb04b', 1, null, null, to_timestamp('24-09-2015 00:41:12.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 00:14:23.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('254488b1-37f0-4741-8eaf-3ababe15a3b2', '4028827c4fb6202a014fb6209c730000', 'aa', null, 1, null, null, to_timestamp('20-09-2015 01:05:42.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('20-09-2015 01:05:42.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('290e5d08-8992-4c7b-95fc-dbbe7b592e14', '4028827c4fb645b0014fb64668550000', 'zhaoliu', 'a33005a4ff1f4890efaee6f754259839', 1, null, null, to_timestamp('30-10-2015 14:51:17.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-10-2015 14:51:17.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('424b2d01-d812-4f30-be40-dcda14110118', '4028827c4fb6202a014fb6209c730000', 'J0724', '22db00a6ab82911b95e3b58eb3bd7dd4', 1, null, null, to_timestamp('21-10-2015 10:47:24.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:47:24.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('5758571d-93c6-48f0-9e67-20a442779531', '4028827c4fb645b0014fb64668550000', 'C', 'c1a732d1b4900854b68472148fe47504', 1, null, null, to_timestamp('01-12-2015 09:37:51.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-12-2015 09:37:51.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('671cf074-d849-4157-93e6-6024d3dcba47', '4028827c4fb645b0014fb64668550000', 'A', '91f40ee798e79cb7d4a75ecc1fec18b5', 1, null, null, to_timestamp('14-09-2015 09:36:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('14-09-2015 09:36:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('6f9f16c8-827b-4cc8-9e20-210aa82d1fcf', '4028827c4fb645b0014fb64668550000', 'D', '0488beaa24f24c21f6f291737baef59a', 1, null, null, to_timestamp('01-12-2015 09:38:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-12-2015 09:38:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('71a5a695-0ba5-4f0d-a0b5-0a304efde944', '4028827c4fb6202a014fb6209c730000', 'J0723', 'a482e34a17bbfc6b5807cce38ac9026a', 1, null, null, to_timestamp('21-10-2015 10:46:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:46:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('9fe270f8-f682-4126-92aa-604d945c95f1', '4028827c4fb6202a014fb6209c730000', 'zhangsan', '654407ac2e454fe560337510aa6adb97', 1, null, null, to_timestamp('24-09-2015 00:41:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 00:13:40.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('a4e6e173-39dc-4b2d-a089-6eb92d117682', '4028827c4fb6202a014fb6209c730000', 'asd', '5933fcbd143b7c752d5f2967a41fd979', 1, null, null, to_timestamp('24-09-2015 11:41:03.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:41:03.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('acde96ad-32e9-4c9c-8555-a90a282193a0', '4028827c4fb645b0014fb64668550000', 'ajaj', 'b867f817d1be3fd65813a7cf798251ce', 1, null, null, to_timestamp('12-09-2015 16:44:24.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('11-09-2015 11:42:02.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('acde96ad-32e9-4c9c-8555-a90a282193a1', '4028827c4fb645b0014fb64668550000', 'aa', '9ec97e6366c4339a71a08b8b805f378a', 1, null, null, to_timestamp('13-09-2015 15:29:22.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('b11c3da4-4760-4f4f-9913-78f7749ffcf9', '4028827c4fb6202a014fb6209c730000', 'J0725', '42c491bd87c7ed9ef5efdfa732665651', 1, null, null, to_timestamp('21-10-2015 10:48:11.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:48:11.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('b891b14b-1316-4a79-8b88-695be1e3f42f', '4028827c4fb6202a014fb6209c730000', 'aj', 'd7d57e0a542eb25ce59e667c8fc50791', 1, null, null, to_timestamp('24-09-2015 11:37:10.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:37:10.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('d583ce5d-49d1-4c37-b7d8-fab189e62329', '4028827c4fb645b0014fb64668550000', 'B', '66a8c64be672631a14de2989e3e52177', 1, null, null, to_timestamp('14-09-2015 16:35:05.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('14-09-2015 16:35:05.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('e0de22fe-2c50-4216-ad75-ed0494d2dc92', '4028827c4fb6202a014fb6209c730000', 'cgx', 'e2bd4809f74129a3df82675786c2f035', 1, null, null, to_timestamp('24-09-2015 11:43:02.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:39:47.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('ee720667-5373-4a36-996b-fded2c257f48', '4028827c4fb645b0014fb64668550000', 'wangwu', '4d6a8546c786edaed7ec4858bee8975c', 1, null, null, to_timestamp('30-10-2015 14:50:18.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-10-2015 14:50:18.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('4fd7c4a4-4938-4271-a4f6-224fe17caafa', 'aeb1c7d3-9a54-4f73-b0ec-0325b83aef45', 'zcx', '37acb4c36403203ec8413233166d6899', 1, null, null, to_timestamp('10-02-2018 12:22:41.717000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('fc49e222-d7df-46e7-86e6-3b1863acc833', 'aeb1c7d3-9a54-4f73-b0ec-0325b83aef45', 'zp', '0f30c7a34b56103a81f9fae2efda74dd', 1, null, null, to_timestamp('10-02-2018 14:04:59.310000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
insert into USER_P (USER_ID, DEPT_ID, USER_NAME, PASSWORD, STATE, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME)
values ('f3668638-0373-4111-bea3-32fd3ea136bd', 'aeb1c7d3-9a54-4f73-b0ec-0325b83aef45', 'zbz1', '73301573b5763669ddb74472d5f842b6', 1, null, null, to_timestamp('01-02-2018 21:00:22.096000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'));
commit;
prompt 22 records loaded
prompt Loading ROLE_USER_P...
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('002108e2-9a10-4510-9683-8d8fd1d374ef', '4028a1c34ec2e5c8014ec2ebf8430001');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('5758571d-93c6-48f0-9e67-20a442779531', '4028a1c34ec2e5c8014ec2ebf8430001');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('6f9f16c8-827b-4cc8-9e20-210aa82d1fcf', '4028a1c34ec2e5c8014ec2ebf8430001');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('f3668638-0373-4111-bea3-32fd3ea136bd', '4028a1c34ec2e5c8014ec2ebf8430001');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('002108e2-9a10-4510-9683-8d8fd1d374ef', '4028a1c34ec2e5c8014ec2ec38cc0002');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('290e5d08-8992-4c7b-95fc-dbbe7b592e14', '4028a1c34ec2e5c8014ec2ec38cc0002');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('18077bdb-8dd3-4aae-95a2-078c963f8416', '4028a1cd4ee2d9d6014ee2df4c6a0000');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('9fe270f8-f682-4126-92aa-604d945c95f1', '4028a1cd4ee2d9d6014ee2df4c6a0000');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('ee720667-5373-4a36-996b-fded2c257f48', '4028a1cd4ee2d9d6014ee2df4c6a0000');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('acde96ad-32e9-4c9c-8555-a90a282193a1', '4028a1cd4ee2d9d6014ee2df4c6a0001');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('671cf074-d849-4157-93e6-6024d3dcba47', '4028a1cd4ee2d9d6014ee2df4c6a0002');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('acde96ad-32e9-4c9c-8555-a90a282193a1', '4028a1cd4ee2d9d6014ee2df4c6a0002');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('d583ce5d-49d1-4c37-b7d8-fab189e62329', '4028a1cd4ee2d9d6014ee2df4c6a0004');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('424b2d01-d812-4f30-be40-dcda14110118', '4028a1cd4ee2d9d6014ee2df4c6a0007');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('71a5a695-0ba5-4f0d-a0b5-0a304efde944', '4028a1cd4ee2d9d6014ee2df4c6a0007');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('a4e6e173-39dc-4b2d-a089-6eb92d117682', '4028a1cd4ee2d9d6014ee2df4c6a0007');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('acde96ad-32e9-4c9c-8555-a90a282193a0', '4028a1cd4ee2d9d6014ee2df4c6a0007');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('b11c3da4-4760-4f4f-9913-78f7749ffcf9', '4028a1cd4ee2d9d6014ee2df4c6a0007');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('b891b14b-1316-4a79-8b88-695be1e3f42f', '4028a1cd4ee2d9d6014ee2df4c6a0007');
insert into ROLE_USER_P (USER_ID, ROLE_ID)
values ('e0de22fe-2c50-4216-ad75-ed0494d2dc92', '4028a1cd4ee2d9d6014ee2df4c6a0007');
commit;
prompt 20 records loaded
prompt Loading USER_INFO_P...
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('aca5520d-b970-430d-b7eb-62efae670e09', '王红', 'f3668638-0373-4111-bea3-32fd3ea136bd', to_timestamp('30-01-2018 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3500, to_timestamp('03-02-1998 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', '研发专员', '4652123', 4, '无', 68, null, null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '957671816@qq.com');
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('002108e2-9a10-4510-9683-8d8fd1d374ef', 'lw', 'b891b14b-1316-4a79-8b88-695be1e3f42f', to_timestamp('06-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 100, to_timestamp('13-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'lw', '3243234', 4, 'lw', 12, null, null, to_timestamp('18-10-2015 17:00:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('18-10-2015 17:00:53.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('18077bdb-8dd3-4aae-95a2-078c963f8416', '李四', null, to_timestamp('10-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 222, to_timestamp('01-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '222', '222', 4, '222', 222, null, null, to_timestamp('24-09-2015 00:14:23.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 00:14:23.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('254488b1-37f0-4741-8eaf-3ababe15a3b2', 'ss', '671cf074-d849-4157-93e6-6024d3dcba47', to_timestamp('14-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 122, to_timestamp('08-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', 's', '112', 4, 'a', 11, null, null, to_timestamp('14-09-2015 16:49:30.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('14-09-2015 16:49:30.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('290e5d08-8992-4c7b-95fc-dbbe7b592e14', '赵六', 'acde96ad-32e9-4c9c-8555-a90a282193a1', to_timestamp('07-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 200, to_timestamp('27-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '拍电影', '4354354354', 4, '拍得很好', 13, null, null, to_timestamp('30-10-2015 14:51:17.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-10-2015 14:51:17.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('424b2d01-d812-4f30-be40-dcda14110118', 'J0724', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('20-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 444, to_timestamp('12-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', 'J0724', '3432', 4, 'dd', 13, null, null, to_timestamp('21-10-2015 10:47:24.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:47:24.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('5758571d-93c6-48f0-9e67-20a442779531', 'C', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('07-12-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 4444, to_timestamp('16-12-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'C', '43534543', 4, 'C', 12, null, null, to_timestamp('01-12-2015 09:37:51.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-12-2015 09:37:51.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('671cf074-d849-4157-93e6-6024d3dcba47', 'A', 'acde96ad-32e9-4c9c-8555-a90a282193a0', to_timestamp('08-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 111111, to_timestamp('31-08-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'A', '435435', 4, 'A', 1, null, null, to_timestamp('14-09-2015 09:36:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('14-09-2015 09:36:37.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('6f9f16c8-827b-4cc8-9e20-210aa82d1fcf', 'D', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('01-12-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 2222, to_timestamp('07-12-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'D', '3224', 4, 'D', 14, null, null, to_timestamp('01-12-2015 09:38:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-12-2015 09:38:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('71a5a695-0ba5-4f0d-a0b5-0a304efde944', 'J0723', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('05-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 465464, to_timestamp('26-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'J0723', '32432', 4, 'q', 12, null, null, to_timestamp('21-10-2015 10:46:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:46:29.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('9fe270f8-f682-4126-92aa-604d945c95f1', '张三', null, to_timestamp('16-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 1111, to_timestamp('31-08-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '111', '111', 4, '111', 111, null, null, to_timestamp('24-09-2015 00:13:40.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 00:13:40.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('a4e6e173-39dc-4b2d-a089-6eb92d117682', 'asd', '671cf074-d849-4157-93e6-6024d3dcba47', to_timestamp('01-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3333, to_timestamp('29-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'qq', '123', 4, 'qqq', 2, null, null, to_timestamp('24-09-2015 11:41:03.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:41:03.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('acde96ad-32e9-4c9c-8555-a90a282193a0', '小娇', null, to_timestamp('14-09-2015 17:05:20.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 20000, to_timestamp('10-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', '服务员', '32543223', 1, '要提高服务质量', 1, null, null, to_timestamp('11-09-2015 11:15:34.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('11-09-2015 11:15:34.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('acde96ad-32e9-4c9c-8555-a90a282193a1', 'cgx', null, to_timestamp('14-09-2015 08:28:27.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-1981 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, null, null, 4, null, null, null, null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('12-12-2012 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('b11c3da4-4760-4f4f-9913-78f7749ffcf9', 'J0725', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('06-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 555, to_timestamp('19-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', 'J0725', '5464', 3, 'qqq', 14, null, null, to_timestamp('21-10-2015 10:48:11.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('21-10-2015 10:48:11.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('b891b14b-1316-4a79-8b88-695be1e3f42f', '阿娇', 'acde96ad-32e9-4c9c-8555-a90a282193a1', to_timestamp('02-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 2000, to_timestamp('08-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', '拍电影', '333', 4, '333', 333, null, null, to_timestamp('24-09-2015 11:37:10.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:37:10.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('cab9cc26-3911-436a-b470-79373de4be22', '小陈', 'acde96ad-32e9-4c9c-8555-a90a282193a0', to_timestamp('08-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 1000, to_timestamp('22-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '拍戏', '222', 4, '2222222', 22, null, null, to_timestamp('24-09-2015 11:35:56.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:35:56.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('d583ce5d-49d1-4c37-b7d8-fab189e62329', 'B', 'acde96ad-32e9-4c9c-8555-a90a282193a1', to_timestamp('14-09-2015 17:02:46.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 11111, to_timestamp('15-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', 'B', '54654634', 3, 'B', 1, null, null, to_timestamp('14-09-2015 16:35:05.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('14-09-2015 16:35:05.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('e0de22fe-2c50-4216-ad75-ed0494d2dc92', '小陈', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('07-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 2222, to_timestamp('08-09-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '拍片', '2', 4, '22', 2, null, null, to_timestamp('24-09-2015 11:39:32.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('24-09-2015 11:39:32.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('ee720667-5373-4a36-996b-fded2c257f48', '王五', 'acde96ad-32e9-4c9c-8555-a90a282193a1', to_timestamp('08-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 100, to_timestamp('27-10-2015 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '演员', '32532', 4, '要向cgx学习', 12, null, null, to_timestamp('30-10-2015 14:50:18.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('30-10-2015 14:50:18.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('4fd7c4a4-4938-4271-a4f6-224fe17caafa', '张春霞', '18077bdb-8dd3-4aae-95a2-078c963f8416', to_timestamp('06-02-2018 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 6000, to_timestamp('10-01-2007 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', '船运经理', '4561489', 3, 'wu ', 45, null, null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '957671816@qq.com');
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('fc49e222-d7df-46e7-86e6-3b1863acc833', '张萍', '4fd7c4a4-4938-4271-a4f6-224fe17caafa', to_timestamp('08-02-2018 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 3000, to_timestamp('05-02-2002 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '0', '船运专员', '4547568', 4, '无', 46, null, null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '957671816@qq.com');
insert into USER_INFO_P (USER_INFO_ID, NAME, MANAGER_ID, JOIN_DATE, SALARY, BIRTHDAY, GENDER, STATION, TELEPHONE, DEGREE, REMARK, ORDER_NO, CREATE_BY, CREATE_DEPT, CREATE_TIME, UPDATE_BY, UPDATE_TIME, EMAIL)
values ('f3668638-0373-4111-bea3-32fd3ea136bd', '老王', 'acde96ad-32e9-4c9c-8555-a90a282193a1', to_timestamp('05-02-2018 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), 5000, to_timestamp('12-02-2013 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1', '船运专员5', '23446', 4, null, 67, null, null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null, to_timestamp('01-01-1970 08:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), null);
commit;
prompt 23 records loaded
prompt Enabling foreign key constraints for CONTRACT_PRODUCT_C...
alter table CONTRACT_PRODUCT_C enable constraint SYS_C0011368;
alter table CONTRACT_PRODUCT_C enable constraint SYS_C0011369;
prompt Enabling foreign key constraints for DEPT_P...
alter table DEPT_P enable constraint SYS_C0011372;
prompt Enabling foreign key constraints for DICT_MODULE_P...
alter table DICT_MODULE_P enable constraint SSDDD;
alter table DICT_MODULE_P enable constraint SSDFHSDG;
alter table DICT_MODULE_P enable constraint SSDGRGSE;
prompt Enabling foreign key constraints for EXPORT_PRODUCT_C...
alter table EXPORT_PRODUCT_C enable constraint SYS_C0011377;
alter table EXPORT_PRODUCT_C enable constraint SYS_C0011378;
prompt Enabling foreign key constraints for EXT_CPRODUCT_C...
alter table EXT_CPRODUCT_C enable constraint SYS_C0011381;
alter table EXT_CPRODUCT_C enable constraint SYS_C0011382;
prompt Enabling foreign key constraints for EXT_EPRODUCT_C...
alter table EXT_EPRODUCT_C enable constraint SYS_C0011385;
alter table EXT_EPRODUCT_C enable constraint SYS_C0011386;
prompt Enabling foreign key constraints for MODULE_DICT_P...
alter table MODULE_DICT_P enable constraint GYTHSD;
prompt Enabling foreign key constraints for ROLE_MODULE_P...
alter table ROLE_MODULE_P enable constraint SYS_C0011398;
prompt Enabling foreign key constraints for USER_P...
alter table USER_P enable constraint SYS_C0011407;
prompt Enabling foreign key constraints for ROLE_USER_P...
alter table ROLE_USER_P enable constraint SYS_C0011411;
prompt Enabling foreign key constraints for USER_INFO_P...
alter table USER_INFO_P enable constraint SYS_C0011418;
prompt Enabling triggers for CONTRACT_C...
alter table CONTRACT_C enable all triggers;
prompt Enabling triggers for FACTORY_C...
alter table FACTORY_C enable all triggers;
prompt Enabling triggers for CONTRACT_PRODUCT_C...
alter table CONTRACT_PRODUCT_C enable all triggers;
prompt Enabling triggers for DEPT_P...
alter table DEPT_P enable all triggers;
prompt Enabling triggers for DICT_P...
alter table DICT_P enable all triggers;
prompt Enabling triggers for MODULE_P...
alter table MODULE_P enable all triggers;
prompt Enabling triggers for ROLE_P...
alter table ROLE_P enable all triggers;
prompt Enabling triggers for DICT_MODULE_P...
alter table DICT_MODULE_P enable all triggers;
prompt Enabling triggers for EXPORT_C...
alter table EXPORT_C enable all triggers;
prompt Enabling triggers for EXPORT_PRODUCT_C...
alter table EXPORT_PRODUCT_C enable all triggers;
prompt Enabling triggers for EXT_CPRODUCT_C...
alter table EXT_CPRODUCT_C enable all triggers;
prompt Enabling triggers for EXT_EPRODUCT_C...
alter table EXT_EPRODUCT_C enable all triggers;
prompt Enabling triggers for LOGIN_LOG_P...
alter table LOGIN_LOG_P enable all triggers;
prompt Enabling triggers for MODULE_DICT_P...
alter table MODULE_DICT_P enable all triggers;
prompt Enabling triggers for ONLINE_INFO_T...
alter table ONLINE_INFO_T enable all triggers;
prompt Enabling triggers for PACKING_LIST_C...
alter table PACKING_LIST_C enable all triggers;
prompt Enabling triggers for ROLE_MODULE_P...
alter table ROLE_MODULE_P enable all triggers;
prompt Enabling triggers for USER_P...
alter table USER_P enable all triggers;
prompt Enabling triggers for ROLE_USER_P...
alter table ROLE_USER_P enable all triggers;
prompt Enabling triggers for USER_INFO_P...
alter table USER_INFO_P enable all triggers;
set feedback on
set define on
prompt Done.
