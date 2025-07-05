--
-- PostgreSQL database dump
--

-- Dumped from database version 16.9 (Ubuntu 16.9-1.pgdg24.04+1)
-- Dumped by pg_dump version 16.9 (Ubuntu 16.9-1.pgdg24.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: poc_mcp_system
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
      BEGIN
          NEW.updated_at = CURRENT_TIMESTAMP;
          RETURN NEW;
      END;
      $$;


ALTER FUNCTION public.update_updated_at_column() OWNER TO poc_mcp_system;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_version; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.app_version (
    id integer NOT NULL,
    app_version character varying(255),
    version_name character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.app_version OWNER TO poc_mcp_system;

--
-- Name: app_version_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.app_version_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.app_version_id_seq OWNER TO poc_mcp_system;

--
-- Name: app_version_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.app_version_id_seq OWNED BY public.app_version.id;


--
-- Name: cidades; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.cidades (
    id integer NOT NULL,
    cd_cidade character varying(255),
    nm_cidade character varying(255),
    ds_uf character varying(255),
    cd_uf character varying(255),
    sincronizado character varying(255),
    dt_inclusao character varying(255),
    dt_alteracao character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.cidades OWNER TO poc_mcp_system;

--
-- Name: cidades_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.cidades_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cidades_id_seq OWNER TO poc_mcp_system;

--
-- Name: cidades_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.cidades_id_seq OWNED BY public.cidades.id;


--
-- Name: clientes; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.clientes (
    id integer NOT NULL,
    cd_cliente character varying(255),
    cd_mdlog character varying(255),
    id_cliente character varying(255),
    nm_cliente character varying(255),
    nm_fantasia character varying(255),
    nr_documento character varying(255),
    nr_insc_est character varying(255),
    nr_insc_muni text,
    dt_nasc character varying(255),
    abrev_logra character varying(255),
    nm_endereco character varying(255),
    nr_endereco character varying(255),
    ds_compl_end text,
    nm_bairro character varying(255),
    cd_uf character varying(255),
    cd_cep character varying(255),
    nm_contato character varying(255),
    nm_contatofin character varying(255),
    nm_cargo text,
    nm_email character varying(255),
    nm_emailfin character varying(255),
    nr_telefone character varying(255),
    dt_inclusao text,
    dt_alteracao character varying(255),
    suframa text,
    dt_sufra character varying(255),
    cd_repres character varying(255),
    cd_repres2 character varying(255),
    cd_repres3 character varying(255),
    nr_telefone2 character varying(255),
    nr_telefone3 text,
    ds_observacao text,
    cd_bosch character varying(255),
    cd_cidade character varying(255),
    cd_class character varying(255),
    limite character varying(255),
    id_status text,
    reg_trib character varying(255),
    ds_grmt character varying(255),
    sincronizado character varying(255),
    categoria character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.clientes OWNER TO poc_mcp_system;

--
-- Name: clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.clientes_id_seq OWNER TO poc_mcp_system;

--
-- Name: clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.clientes_id_seq OWNED BY public.clientes.id;


--
-- Name: combo_cab; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.combo_cab (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.combo_cab OWNER TO poc_mcp_system;

--
-- Name: combo_cab_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.combo_cab_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.combo_cab_id_seq OWNER TO poc_mcp_system;

--
-- Name: combo_cab_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.combo_cab_id_seq OWNED BY public.combo_cab.id;


--
-- Name: combo_itens; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.combo_itens (
    id integer NOT NULL,
    cd_item character varying(255),
    cd_combo character varying(255),
    cd_produto character varying(255),
    qt_prod character varying(255),
    pc_desc_item character varying(255),
    op_soma text,
    class_cli text,
    op_desc_prod character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.combo_itens OWNER TO poc_mcp_system;

--
-- Name: combo_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.combo_itens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.combo_itens_id_seq OWNER TO poc_mcp_system;

--
-- Name: combo_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.combo_itens_id_seq OWNED BY public.combo_itens.id;


--
-- Name: combo_repres; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.combo_repres (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.combo_repres OWNER TO poc_mcp_system;

--
-- Name: combo_repres_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.combo_repres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.combo_repres_id_seq OWNER TO poc_mcp_system;

--
-- Name: combo_repres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.combo_repres_id_seq OWNED BY public.combo_repres.id;


--
-- Name: config; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.config (
    id integer NOT NULL,
    cd_config character varying(255),
    ds_config character varying(255),
    vl_extenso character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.config OWNER TO poc_mcp_system;

--
-- Name: config_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.config_id_seq OWNER TO poc_mcp_system;

--
-- Name: config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.config_id_seq OWNED BY public.config.id;


--
-- Name: consulta_cd_pedido; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.consulta_cd_pedido (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.consulta_cd_pedido OWNER TO poc_mcp_system;

--
-- Name: consulta_cd_pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.consulta_cd_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.consulta_cd_pedido_id_seq OWNER TO poc_mcp_system;

--
-- Name: consulta_cd_pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.consulta_cd_pedido_id_seq OWNED BY public.consulta_cd_pedido.id;


--
-- Name: consulta_pedido; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.consulta_pedido (
    id integer NOT NULL,
    cd_pedido character varying(255),
    cd_cliente character varying(255),
    cd_repres character varying(255),
    id_status character varying(255),
    dt_alteracao character varying(255),
    hr_alteracao character varying(255),
    id_bonifica text,
    op_hab_suframa character varying(255),
    cod_suframa text,
    vl_pedido character varying(255),
    dt_envio character varying(255),
    dt_inclusao character varying(255),
    hr_inclusao character varying(255),
    dt_aprova character varying(255),
    dt_canc character varying(255),
    div_ven text,
    tip_ped character varying(255),
    dt_envio_bosch character varying(255),
    mensagem text,
    dt_fatu character varying(255),
    obs_pagto text,
    cd_pagto character varying(255),
    cd_usu_atual character varying(255),
    op_com_descontos character varying(255),
    cd_produto_subs text,
    op_repr character varying(255),
    dt_cod_suframa character varying(255),
    dt_programa character varying(255),
    dt_status text,
    ds_status_1 text,
    ds_motivo text,
    ds_status_2 text,
    area_resp text,
    acao_di text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.consulta_pedido OWNER TO poc_mcp_system;

--
-- Name: consulta_pedido_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.consulta_pedido_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.consulta_pedido_id_seq OWNER TO poc_mcp_system;

--
-- Name: consulta_pedido_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.consulta_pedido_id_seq OWNED BY public.consulta_pedido.id;


--
-- Name: consulta_pedido_itens; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.consulta_pedido_itens (
    id integer NOT NULL,
    cd_pedido character varying(255),
    cd_repres character varying(255),
    cd_produto character varying(255),
    desc_neg character varying(255),
    tp_produto character varying(255),
    cd_combo text,
    nr_quantidade character varying(255),
    nr_qtd_ant character varying(255),
    vl_venda_pedido character varying(255),
    vl_venda_pedido_sesp character varying(255),
    vl_venda_pedido_sfreud character varying(255),
    vl_icms_st character varying(255),
    nr_qt_irmaos character varying(255),
    op_preco character varying(255),
    cd_grupdesc character varying(255),
    cd_gruposel character varying(255),
    cd_gruporede character varying(255),
    uso_sele character varying(255),
    uso_rede character varying(255),
    vl_liquido character varying(255),
    pc_desc_class_cli character varying(255),
    cd_dc character varying(255),
    pc_desc_avista character varying(255),
    vl_lista character varying(255),
    vl_desc_class_cli character varying(255),
    vl_desc_avista character varying(255),
    pc_desc_tabela character varying(255),
    vl_desc_tabela character varying(255),
    pc_desc_adicional character varying(255),
    vl_desc_adicional character varying(255),
    pc_desc_lq character varying(255),
    vl_desc_lq character varying(255),
    pc_desc_lqpl character varying(255),
    vl_desc_lqpl character varying(255),
    pc_desc_qt character varying(255),
    vl_desc_qt character varying(255),
    pc_desc_ad_cli_a character varying(255),
    vl_desc_ad_cli_a character varying(255),
    pc_desc_ad_cli_aa character varying(255),
    vl_desc_ad_cli_aa character varying(255),
    pc_desc_prog character varying(255),
    vl_desc_prog character varying(255),
    pc_desc_est character varying(255),
    vl_desc_est character varying(255),
    pc_desc_esp character varying(255),
    vl_desc_esp character varying(255),
    pc_desc_combo character varying(255),
    vl_desc_combo character varying(255),
    pc_desc_freud character varying(255),
    vl_desc_freud character varying(255),
    vl_desc_neg character varying(255),
    vl_base character varying(255),
    pc_icms character varying(255),
    vl_icms character varying(255),
    vl_base_ipi character varying(255),
    pc_ipi character varying(255),
    vl_ipi character varying(255),
    vl_base_st character varying(255),
    pc_mva character varying(255),
    pc_icms_int character varying(255),
    vl_icms_subs character varying(255),
    vl_precosuframa character varying(255),
    pc_ipi_suframa character varying(255),
    vl_ipi_suframa character varying(255),
    pc_icms_suframa character varying(255),
    vl_icms_suframa character varying(255),
    vl_piscofins_suframa character varying(255),
    pc_piscofins_suframa character varying(255),
    vl_liqlista_suframa character varying(255),
    pc_redu_sp character varying(255),
    vl_redu_sp character varying(255),
    pc_red character varying(255),
    vl_red character varying(255),
    vl_mva character varying(255),
    leg character varying(255),
    pr_negociado character varying(255),
    negociado1 character varying(255),
    negociado2 character varying(255),
    negociado3 character varying(255),
    dt_log character varying(255),
    hr_log character varying(255),
    qt_cancelada character varying(255),
    op_cancelado text,
    dt_cancelado character varying(255),
    pc_desc_extra character varying(255),
    vl_desc_extra character varying(255),
    cd_grupomadeira character varying(255),
    uso_madeira character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.consulta_pedido_itens OWNER TO poc_mcp_system;

--
-- Name: consulta_pedido_itens_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.consulta_pedido_itens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.consulta_pedido_itens_id_seq OWNER TO poc_mcp_system;

--
-- Name: consulta_pedido_itens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.consulta_pedido_itens_id_seq OWNED BY public.consulta_pedido_itens.id;


--
-- Name: dc_prod; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.dc_prod (
    id integer NOT NULL,
    cd_dcp character varying(255),
    cd_produto character varying(255),
    cd_dc character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dc_prod OWNER TO poc_mcp_system;

--
-- Name: dc_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.dc_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dc_prod_id_seq OWNER TO poc_mcp_system;

--
-- Name: dc_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.dc_prod_id_seq OWNED BY public.dc_prod.id;


--
-- Name: de_cli; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.de_cli (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.de_cli OWNER TO poc_mcp_system;

--
-- Name: de_cli_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.de_cli_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.de_cli_id_seq OWNER TO poc_mcp_system;

--
-- Name: de_cli_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.de_cli_id_seq OWNED BY public.de_cli.id;


--
-- Name: de_prod; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.de_prod (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.de_prod OWNER TO poc_mcp_system;

--
-- Name: de_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.de_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.de_prod_id_seq OWNER TO poc_mcp_system;

--
-- Name: de_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.de_prod_id_seq OWNED BY public.de_prod.id;


--
-- Name: de_repr; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.de_repr (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.de_repr OWNER TO poc_mcp_system;

--
-- Name: de_repr_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.de_repr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.de_repr_id_seq OWNER TO poc_mcp_system;

--
-- Name: de_repr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.de_repr_id_seq OWNED BY public.de_repr.id;


--
-- Name: des_cli; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.des_cli (
    id integer NOT NULL,
    cd_dec character varying(255),
    cd_de character varying(255),
    cd_cliente character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.des_cli OWNER TO poc_mcp_system;

--
-- Name: des_cli_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.des_cli_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.des_cli_id_seq OWNER TO poc_mcp_system;

--
-- Name: des_cli_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.des_cli_id_seq OWNED BY public.des_cli.id;


--
-- Name: des_prod; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.des_prod (
    id integer NOT NULL,
    cd_dep character varying(255),
    cd_de character varying(255),
    cd_produto character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.des_prod OWNER TO poc_mcp_system;

--
-- Name: des_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.des_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.des_prod_id_seq OWNER TO poc_mcp_system;

--
-- Name: des_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.des_prod_id_seq OWNED BY public.des_prod.id;


--
-- Name: des_repr; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.des_repr (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.des_repr OWNER TO poc_mcp_system;

--
-- Name: des_repr_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.des_repr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.des_repr_id_seq OWNER TO poc_mcp_system;

--
-- Name: des_repr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.des_repr_id_seq OWNED BY public.des_repr.id;


--
-- Name: desc_condicional; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desc_condicional (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desc_condicional OWNER TO poc_mcp_system;

--
-- Name: desc_condicional_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desc_condicional_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desc_condicional_id_seq OWNER TO poc_mcp_system;

--
-- Name: desc_condicional_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desc_condicional_id_seq OWNED BY public.desc_condicional.id;


--
-- Name: desc_escala; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desc_escala (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desc_escala OWNER TO poc_mcp_system;

--
-- Name: desc_escala_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desc_escala_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desc_escala_id_seq OWNER TO poc_mcp_system;

--
-- Name: desc_escala_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desc_escala_id_seq OWNED BY public.desc_escala.id;


--
-- Name: desconto_clientes; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desconto_clientes (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desconto_clientes OWNER TO poc_mcp_system;

--
-- Name: desconto_clientes_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desconto_clientes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desconto_clientes_id_seq OWNER TO poc_mcp_system;

--
-- Name: desconto_clientes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desconto_clientes_id_seq OWNED BY public.desconto_clientes.id;


--
-- Name: desconto_combinado; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desconto_combinado (
    id integer NOT NULL,
    cd_item character varying(255),
    cd_produto1 character varying(255),
    cd_produto2 character varying(255),
    cd_grupo_rede character varying(255),
    cd_grupo_select character varying(255),
    pc_desc character varying(255),
    qt_prod character varying(255),
    cd_grupo character varying(255),
    cd_grupo2 character varying(255),
    cd_grupo_rede2 character varying(255),
    cd_grupo_select2 character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desconto_combinado OWNER TO poc_mcp_system;

--
-- Name: desconto_combinado_2; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desconto_combinado_2 (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desconto_combinado_2 OWNER TO poc_mcp_system;

--
-- Name: desconto_combinado_2_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desconto_combinado_2_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desconto_combinado_2_id_seq OWNER TO poc_mcp_system;

--
-- Name: desconto_combinado_2_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desconto_combinado_2_id_seq OWNED BY public.desconto_combinado_2.id;


--
-- Name: desconto_combinado_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desconto_combinado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desconto_combinado_id_seq OWNER TO poc_mcp_system;

--
-- Name: desconto_combinado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desconto_combinado_id_seq OWNED BY public.desconto_combinado.id;


--
-- Name: desconto_estrategico; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desconto_estrategico (
    id integer NOT NULL,
    cd_de character varying(255),
    nm_de character varying(255),
    id_ativo character varying(255),
    uf_ac character varying(255),
    uf_al character varying(255),
    uf_ap character varying(255),
    uf_am character varying(255),
    uf_ba character varying(255),
    uf_ce character varying(255),
    uf_df character varying(255),
    uf_es character varying(255),
    uf_go character varying(255),
    uf_ma character varying(255),
    uf_mt character varying(255),
    uf_ms character varying(255),
    uf_mg character varying(255),
    uf_pr character varying(255),
    uf_pb character varying(255),
    uf_pa character varying(255),
    uf_pe character varying(255),
    uf_pi character varying(255),
    uf_rj character varying(255),
    uf_rn character varying(255),
    uf_rs character varying(255),
    uf_ro character varying(255),
    uf_rr character varying(255),
    uf_sc character varying(255),
    uf_se character varying(255),
    uf_sp character varying(255),
    uf_to character varying(255),
    pc_de character varying(255),
    op_repr character varying(255),
    op_cli character varying(255),
    op_prod character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desconto_estrategico OWNER TO poc_mcp_system;

--
-- Name: desconto_estrategico_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desconto_estrategico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desconto_estrategico_id_seq OWNER TO poc_mcp_system;

--
-- Name: desconto_estrategico_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desconto_estrategico_id_seq OWNED BY public.desconto_estrategico.id;


--
-- Name: desconto_eventos; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.desconto_eventos (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.desconto_eventos OWNER TO poc_mcp_system;

--
-- Name: desconto_eventos_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.desconto_eventos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.desconto_eventos_id_seq OWNER TO poc_mcp_system;

--
-- Name: desconto_eventos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.desconto_eventos_id_seq OWNED BY public.desconto_eventos.id;


--
-- Name: dp_cab; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.dp_cab (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dp_cab OWNER TO poc_mcp_system;

--
-- Name: dp_cab_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.dp_cab_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dp_cab_id_seq OWNER TO poc_mcp_system;

--
-- Name: dp_cab_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.dp_cab_id_seq OWNED BY public.dp_cab.id;


--
-- Name: dp_pol; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.dp_pol (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dp_pol OWNER TO poc_mcp_system;

--
-- Name: dp_pol_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.dp_pol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dp_pol_id_seq OWNER TO poc_mcp_system;

--
-- Name: dp_pol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.dp_pol_id_seq OWNED BY public.dp_pol.id;


--
-- Name: dp_prod; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.dp_prod (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.dp_prod OWNER TO poc_mcp_system;

--
-- Name: dp_prod_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.dp_prod_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dp_prod_id_seq OWNER TO poc_mcp_system;

--
-- Name: dp_prod_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.dp_prod_id_seq OWNED BY public.dp_prod.id;


--
-- Name: fabr; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.fabr (
    id integer NOT NULL,
    cd_fabr character varying(255),
    ds_fabr character varying(255),
    id_status character varying(255),
    pc_desc character varying(255),
    dt_validade_desc character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.fabr OWNER TO poc_mcp_system;

--
-- Name: fabr_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.fabr_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fabr_id_seq OWNER TO poc_mcp_system;

--
-- Name: fabr_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.fabr_id_seq OWNED BY public.fabr.id;


--
-- Name: filiais; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.filiais (
    id integer NOT NULL,
    cd_filial character varying(255),
    nm_razao character varying(255),
    ds_reduzida character varying(255),
    id_quinz character varying(255),
    dt_quinzena_ini character varying(255),
    dt_quinzena character varying(255),
    pc_quinz character varying(255),
    id_quinzpl text,
    dt_quinzena_inipl character varying(255),
    dt_quinzenapl character varying(255),
    pc_quinzpl character varying(255),
    valor1_ini character varying(255),
    valor1_fim character varying(255),
    pc_valor1 character varying(255),
    dt_valor1_ini character varying(255),
    dt_valor1_fim character varying(255),
    valor2_ini character varying(255),
    valor2_fim character varying(255),
    pc_valor2 character varying(255),
    dt_valor2_ini character varying(255),
    dt_valor2_fim character varying(255),
    valor3_ini character varying(255),
    valor3_fim character varying(255),
    pc_valor3 character varying(255),
    dt_valor3_ini character varying(255),
    dt_valor3_fim character varying(255),
    valor4_ini character varying(255),
    valor4_fim character varying(255),
    pc_valor4 character varying(255),
    dt_valor4_ini character varying(255),
    dt_valor4_fim character varying(255),
    valor5_ini character varying(255),
    valor5_fim character varying(255),
    pc_valor5 character varying(255),
    dt_valor5_ini character varying(255),
    dt_valor5_fim character varying(255),
    pc_class_a character varying(255),
    pc_class_b character varying(255),
    pc_class_c character varying(255),
    pc_class_am character varying(255),
    pc_class_x character varying(255),
    vl_min_parc character varying(255),
    vl_min_ped character varying(255),
    op_cli2vend character varying(255),
    url character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.filiais OWNER TO poc_mcp_system;

--
-- Name: filiais_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.filiais_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.filiais_id_seq OWNER TO poc_mcp_system;

--
-- Name: filiais_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.filiais_id_seq OWNED BY public.filiais.id;


--
-- Name: grupdesc; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.grupdesc (
    id integer NOT NULL,
    cd_grupo character varying(255),
    nm_grupo character varying(255),
    pc_desc_tab character varying(255),
    pc_desc_av character varying(255),
    pc_desc_adic character varying(255),
    qt_venda01 character varying(255),
    qt_venda02 character varying(255),
    qt_venda03 character varying(255),
    qt_venda04 character varying(255),
    qt_venda05 character varying(255),
    pc_desc01 character varying(255),
    pc_desc01a character varying(255),
    pc_desc01aa character varying(255),
    pc_desc01b character varying(255),
    pc_desc02 character varying(255),
    pc_desc02a character varying(255),
    pc_desc02aa character varying(255),
    pc_desc02b character varying(255),
    pc_desc03 character varying(255),
    pc_desc03a character varying(255),
    pc_desc03aa character varying(255),
    pc_desc03b character varying(255),
    pc_desc04 character varying(255),
    pc_desc04a character varying(255),
    pc_desc04aa character varying(255),
    pc_desc04b character varying(255),
    pc_desc05 character varying(255),
    pc_desc05a character varying(255),
    pc_desc05aa character varying(255),
    pc_desc05b character varying(255),
    id_quinzpl character varying(255),
    pc_adic_clia character varying(255),
    pc_adic_cliam character varying(255),
    op_uf text,
    uf_ac text,
    uf_al text,
    uf_ap text,
    uf_am text,
    uf_ba text,
    uf_ce text,
    uf_df text,
    uf_es text,
    uf_go text,
    uf_ma text,
    uf_mt text,
    uf_ms text,
    uf_mg text,
    uf_pa text,
    uf_pe text,
    uf_pb text,
    uf_pr text,
    uf_rj text,
    uf_rn text,
    uf_rs text,
    uf_ro text,
    uf_rr text,
    uf_se text,
    uf_sc text,
    uf_sp text,
    uf_to text,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.grupdesc OWNER TO poc_mcp_system;

--
-- Name: grupdesc_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.grupdesc_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grupdesc_id_seq OWNER TO poc_mcp_system;

--
-- Name: grupdesc_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.grupdesc_id_seq OWNED BY public.grupdesc.id;


--
-- Name: grupos_mt; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.grupos_mt (
    id integer NOT NULL,
    cd_grmt character varying(255),
    ds_grmt character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.grupos_mt OWNER TO poc_mcp_system;

--
-- Name: grupos_mt_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.grupos_mt_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.grupos_mt_id_seq OWNER TO poc_mcp_system;

--
-- Name: grupos_mt_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.grupos_mt_id_seq OWNED BY public.grupos_mt.id;


--
-- Name: login_usuario; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.login_usuario (
    id integer NOT NULL,
    cd_usuario character varying(255),
    nm_usuario character varying(255),
    tp_priv character varying(255),
    nm_login character varying(255),
    nm_senha character varying(255),
    sincronizado character varying(255),
    dt_inclusao character varying(255),
    dt_alteracao character varying(255),
    cd_repres character varying(255),
    nm_repres character varying(255),
    sincronizado_repres character varying(255),
    metam character varying(255),
    dt_inclusao_repres text,
    dt_alteracao_repres character varying(255),
    id_status_repres character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.login_usuario OWNER TO poc_mcp_system;

--
-- Name: login_usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.login_usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.login_usuario_id_seq OWNER TO poc_mcp_system;

--
-- Name: login_usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.login_usuario_id_seq OWNED BY public.login_usuario.id;


--
-- Name: logradouro; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.logradouro (
    id integer NOT NULL,
    cd_logra character varying(255),
    abrev_logra character varying(255),
    ds_logra character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.logradouro OWNER TO poc_mcp_system;

--
-- Name: logradouro_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.logradouro_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.logradouro_id_seq OWNER TO poc_mcp_system;

--
-- Name: logradouro_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.logradouro_id_seq OWNED BY public.logradouro.id;


--
-- Name: ncm_4; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.ncm_4 (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ncm_4 OWNER TO poc_mcp_system;

--
-- Name: ncm_4_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.ncm_4_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncm_4_id_seq OWNER TO poc_mcp_system;

--
-- Name: ncm_4_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.ncm_4_id_seq OWNED BY public.ncm_4.id;


--
-- Name: ncm_71218; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.ncm_71218 (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ncm_71218 OWNER TO poc_mcp_system;

--
-- Name: ncm_71218_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.ncm_71218_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncm_71218_id_seq OWNER TO poc_mcp_system;

--
-- Name: ncm_71218_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.ncm_71218_id_seq OWNED BY public.ncm_71218.id;


--
-- Name: ncm_material; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.ncm_material (
    id integer NOT NULL,
    msg character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.ncm_material OWNER TO poc_mcp_system;

--
-- Name: ncm_material_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.ncm_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ncm_material_id_seq OWNER TO poc_mcp_system;

--
-- Name: ncm_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.ncm_material_id_seq OWNED BY public.ncm_material.id;


--
-- Name: produtos; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.produtos (
    id integer NOT NULL,
    cd_produto character varying(255),
    cd_produto_subs text,
    nm_produto character varying(255),
    ds_imagem1 character varying(255),
    ds_imagem2 character varying(255),
    ds_imagem3 character varying(255),
    ds_imagem4 character varying(255),
    cd_fabr character varying(255),
    ds_fabr character varying(255),
    cd_grupo character varying(255),
    cd_grupo_loja character varying(255),
    dt_inclusao character varying(255),
    dt_alteracao character varying(255),
    id_status character varying(255),
    cd_trib character varying(255),
    vl_venda character varying(255),
    id_bruto character varying(255),
    qt_venda01 character varying(255),
    qt_venda02 character varying(255),
    qt_venda03 character varying(255),
    qt_venda04 text,
    qt_venda05 text,
    pc_desc01 character varying(255),
    pc_desc01a character varying(255),
    pc_desc01aa character varying(255),
    pc_desc01b character varying(255),
    pc_desc02 character varying(255),
    pc_desc02a character varying(255),
    pc_desc02aa character varying(255),
    pc_desc02b character varying(255),
    pc_desc03 character varying(255),
    pc_desc03a character varying(255),
    pc_desc03aa character varying(255),
    pc_desc03b character varying(255),
    pc_desc04 text,
    pc_desc04a character varying(255),
    pc_desc04aa character varying(255),
    pc_desc04b character varying(255),
    pc_desc05 text,
    pc_desc05a character varying(255),
    pc_desc05aa character varying(255),
    pc_desc05b character varying(255),
    pc_desc_tab character varying(255),
    pc_desc_av character varying(255),
    pc_desc_adic character varying(255),
    per_ipi character varying(255),
    cd_ncm character varying(255),
    qtd_min character varying(255),
    vl_redu character varying(255),
    vl_redudema character varying(255),
    id_quinz character varying(255),
    id_quinzpl character varying(255),
    pc_adic_clia character varying(255),
    pc_adic_cliam character varying(255),
    vl_lista character varying(255),
    pc_icms_vllista character varying(255),
    pc_icms_vlvenda character varying(255),
    pc_icms_vlredu character varying(255),
    pc_icms_vlredudema character varying(255),
    bs_icms_redu character varying(255),
    ali_icms_redusp character varying(255),
    sincronizado character varying(255),
    id_desc_cli character varying(255),
    cd_origem character varying(255),
    id_desc_esc character varying(255),
    cd_barras character varying(255),
    op_mix_acessorios text,
    op_mix_azulskil text,
    id_promocao character varying(255),
    vl_promocao character varying(255),
    vl_redu_pro character varying(255),
    vl_redudema_pro character varying(255),
    vl_liquido character varying(255),
    vl_redu_liq character varying(255),
    vl_redudema_liq character varying(255),
    id_liquido character varying(255),
    tpp_produto character varying(255),
    op_uf text,
    uf_ac text,
    uf_al text,
    uf_ap text,
    uf_am text,
    uf_ba text,
    uf_ce text,
    uf_df text,
    uf_es text,
    uf_go text,
    uf_ma text,
    uf_mt text,
    uf_ms text,
    uf_mg text,
    uf_pa text,
    uf_pe text,
    uf_pb text,
    uf_pr text,
    uf_rj text,
    uf_rn text,
    uf_rs text,
    uf_ro text,
    uf_rr text,
    uf_se text,
    uf_sc text,
    uf_sp text,
    uf_to text,
    vl_pene character varying(255),
    vl_pepe character varying(255),
    qt_venda01a character varying(255),
    qt_venda02a character varying(255),
    qt_venda03a character varying(255),
    qt_venda04a character varying(255),
    qt_venda05a character varying(255),
    qt_venda01aa character varying(255),
    qt_venda02aa character varying(255),
    qt_venda03aa character varying(255),
    qt_venda04aa character varying(255),
    qt_venda05aa character varying(255),
    pc_icms_pepe character varying(255),
    pc_icms_pene character varying(255),
    op_ufa text,
    uf_aca text,
    uf_ala text,
    uf_apa text,
    uf_ama text,
    uf_baa text,
    uf_cea text,
    uf_dfa text,
    uf_esa text,
    uf_goa text,
    uf_maa text,
    uf_mta text,
    uf_msa text,
    uf_mga text,
    uf_paa text,
    uf_pea text,
    uf_pia text,
    uf_pba text,
    uf_pra text,
    uf_rja text,
    uf_rna text,
    uf_rsa text,
    uf_roa text,
    uf_rra text,
    uf_sea text,
    uf_sca text,
    uf_spa text,
    uf_toa text,
    op_ufaa text,
    uf_acaa text,
    uf_alaa text,
    uf_apaa text,
    uf_amaa text,
    uf_baaa text,
    uf_ceaa text,
    uf_dfaa text,
    uf_esaa text,
    uf_goaa text,
    uf_maaa text,
    uf_mtaa text,
    uf_msaa text,
    uf_mgaa text,
    uf_paaa text,
    uf_peaa text,
    uf_piaa text,
    uf_pbaa text,
    uf_praa text,
    uf_rjaa text,
    uf_rnaa text,
    uf_rsaa text,
    uf_roaa text,
    uf_rraa text,
    uf_seaa text,
    uf_scaa text,
    uf_spaa text,
    uf_toaa text,
    qt_venda01b character varying(255),
    qt_venda02b character varying(255),
    qt_venda03b character varying(255),
    qt_venda04b character varying(255),
    qt_venda05b character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.produtos OWNER TO poc_mcp_system;

--
-- Name: produtos_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.produtos_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.produtos_id_seq OWNER TO poc_mcp_system;

--
-- Name: produtos_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.produtos_id_seq OWNED BY public.produtos.id;


--
-- Name: qtd_registros; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.qtd_registros (
    id integer NOT NULL,
    qtd_produtos integer,
    qtd_produtos_alterados integer,
    qtd_ncm_4 character varying(255),
    qtd_ncm_71218 character varying(255),
    qtd_ncm_material character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.qtd_registros OWNER TO poc_mcp_system;

--
-- Name: qtd_registros_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.qtd_registros_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.qtd_registros_id_seq OWNER TO poc_mcp_system;

--
-- Name: qtd_registros_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.qtd_registros_id_seq OWNED BY public.qtd_registros.id;


--
-- Name: repres; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.repres (
    id integer NOT NULL,
    cd_repres character varying(255),
    nm_repres character varying(255),
    sincronizado character varying(255),
    metam character varying(255),
    dt_inclusao text,
    dt_alteracao character varying(255),
    id_status character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.repres OWNER TO poc_mcp_system;

--
-- Name: repres_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.repres_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.repres_id_seq OWNER TO poc_mcp_system;

--
-- Name: repres_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.repres_id_seq OWNED BY public.repres.id;


--
-- Name: tp_pagamento; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.tp_pagamento (
    id integer NOT NULL,
    cd_pagto character varying(255),
    ds_pagto character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tp_pagamento OWNER TO poc_mcp_system;

--
-- Name: tp_pagamento_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.tp_pagamento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_pagamento_id_seq OWNER TO poc_mcp_system;

--
-- Name: tp_pagamento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.tp_pagamento_id_seq OWNED BY public.tp_pagamento.id;


--
-- Name: tp_ped; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.tp_ped (
    id integer NOT NULL,
    id_tipo character varying(255),
    cd_tipo character varying(255),
    ds_tipo character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tp_ped OWNER TO poc_mcp_system;

--
-- Name: tp_ped_consulta; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.tp_ped_consulta (
    id integer NOT NULL,
    id_tipo character varying(255),
    cd_tipo character varying(255),
    ds_tipo character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.tp_ped_consulta OWNER TO poc_mcp_system;

--
-- Name: tp_ped_consulta_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.tp_ped_consulta_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_ped_consulta_id_seq OWNER TO poc_mcp_system;

--
-- Name: tp_ped_consulta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.tp_ped_consulta_id_seq OWNED BY public.tp_ped_consulta.id;


--
-- Name: tp_ped_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.tp_ped_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tp_ped_id_seq OWNER TO poc_mcp_system;

--
-- Name: tp_ped_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.tp_ped_id_seq OWNED BY public.tp_ped.id;


--
-- Name: trib_icms; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.trib_icms (
    id integer NOT NULL,
    cd_trib character varying(255),
    ds_trib character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.trib_icms OWNER TO poc_mcp_system;

--
-- Name: trib_icms_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.trib_icms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.trib_icms_id_seq OWNER TO poc_mcp_system;

--
-- Name: trib_icms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.trib_icms_id_seq OWNED BY public.trib_icms.id;


--
-- Name: uf; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.uf (
    id integer NOT NULL,
    cd_uf character varying(255),
    ds_uf character varying(255),
    uf_abrev character varying(255),
    pc_icms character varying(255),
    pc_icms_imp character varying(255),
    pc_icms_nac character varying(255),
    pc_icms_int character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.uf OWNER TO poc_mcp_system;

--
-- Name: uf_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.uf_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.uf_id_seq OWNER TO poc_mcp_system;

--
-- Name: uf_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.uf_id_seq OWNED BY public.uf.id;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: poc_mcp_system
--

CREATE TABLE public.usuarios (
    id integer NOT NULL,
    cd_usuario character varying(255),
    nm_usuario character varying(255),
    cd_repres character varying(255),
    tp_priv character varying(255),
    nm_login character varying(255),
    nm_senha character varying(255),
    sincronizado character varying(255),
    dt_inclusao character varying(255),
    dt_alteracao character varying(255),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.usuarios OWNER TO poc_mcp_system;

--
-- Name: usuarios_id_seq; Type: SEQUENCE; Schema: public; Owner: poc_mcp_system
--

CREATE SEQUENCE public.usuarios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_seq OWNER TO poc_mcp_system;

--
-- Name: usuarios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: poc_mcp_system
--

ALTER SEQUENCE public.usuarios_id_seq OWNED BY public.usuarios.id;


--
-- Name: app_version id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.app_version ALTER COLUMN id SET DEFAULT nextval('public.app_version_id_seq'::regclass);


--
-- Name: cidades id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.cidades ALTER COLUMN id SET DEFAULT nextval('public.cidades_id_seq'::regclass);


--
-- Name: clientes id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.clientes ALTER COLUMN id SET DEFAULT nextval('public.clientes_id_seq'::regclass);


--
-- Name: combo_cab id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.combo_cab ALTER COLUMN id SET DEFAULT nextval('public.combo_cab_id_seq'::regclass);


--
-- Name: combo_itens id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.combo_itens ALTER COLUMN id SET DEFAULT nextval('public.combo_itens_id_seq'::regclass);


--
-- Name: combo_repres id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.combo_repres ALTER COLUMN id SET DEFAULT nextval('public.combo_repres_id_seq'::regclass);


--
-- Name: config id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.config ALTER COLUMN id SET DEFAULT nextval('public.config_id_seq'::regclass);


--
-- Name: consulta_cd_pedido id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.consulta_cd_pedido ALTER COLUMN id SET DEFAULT nextval('public.consulta_cd_pedido_id_seq'::regclass);


--
-- Name: consulta_pedido id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.consulta_pedido ALTER COLUMN id SET DEFAULT nextval('public.consulta_pedido_id_seq'::regclass);


--
-- Name: consulta_pedido_itens id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.consulta_pedido_itens ALTER COLUMN id SET DEFAULT nextval('public.consulta_pedido_itens_id_seq'::regclass);


--
-- Name: dc_prod id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dc_prod ALTER COLUMN id SET DEFAULT nextval('public.dc_prod_id_seq'::regclass);


--
-- Name: de_cli id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.de_cli ALTER COLUMN id SET DEFAULT nextval('public.de_cli_id_seq'::regclass);


--
-- Name: de_prod id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.de_prod ALTER COLUMN id SET DEFAULT nextval('public.de_prod_id_seq'::regclass);


--
-- Name: de_repr id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.de_repr ALTER COLUMN id SET DEFAULT nextval('public.de_repr_id_seq'::regclass);


--
-- Name: des_cli id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.des_cli ALTER COLUMN id SET DEFAULT nextval('public.des_cli_id_seq'::regclass);


--
-- Name: des_prod id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.des_prod ALTER COLUMN id SET DEFAULT nextval('public.des_prod_id_seq'::regclass);


--
-- Name: des_repr id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.des_repr ALTER COLUMN id SET DEFAULT nextval('public.des_repr_id_seq'::regclass);


--
-- Name: desc_condicional id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desc_condicional ALTER COLUMN id SET DEFAULT nextval('public.desc_condicional_id_seq'::regclass);


--
-- Name: desc_escala id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desc_escala ALTER COLUMN id SET DEFAULT nextval('public.desc_escala_id_seq'::regclass);


--
-- Name: desconto_clientes id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_clientes ALTER COLUMN id SET DEFAULT nextval('public.desconto_clientes_id_seq'::regclass);


--
-- Name: desconto_combinado id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_combinado ALTER COLUMN id SET DEFAULT nextval('public.desconto_combinado_id_seq'::regclass);


--
-- Name: desconto_combinado_2 id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_combinado_2 ALTER COLUMN id SET DEFAULT nextval('public.desconto_combinado_2_id_seq'::regclass);


--
-- Name: desconto_estrategico id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_estrategico ALTER COLUMN id SET DEFAULT nextval('public.desconto_estrategico_id_seq'::regclass);


--
-- Name: desconto_eventos id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_eventos ALTER COLUMN id SET DEFAULT nextval('public.desconto_eventos_id_seq'::regclass);


--
-- Name: dp_cab id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dp_cab ALTER COLUMN id SET DEFAULT nextval('public.dp_cab_id_seq'::regclass);


--
-- Name: dp_pol id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dp_pol ALTER COLUMN id SET DEFAULT nextval('public.dp_pol_id_seq'::regclass);


--
-- Name: dp_prod id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dp_prod ALTER COLUMN id SET DEFAULT nextval('public.dp_prod_id_seq'::regclass);


--
-- Name: fabr id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.fabr ALTER COLUMN id SET DEFAULT nextval('public.fabr_id_seq'::regclass);


--
-- Name: filiais id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.filiais ALTER COLUMN id SET DEFAULT nextval('public.filiais_id_seq'::regclass);


--
-- Name: grupdesc id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.grupdesc ALTER COLUMN id SET DEFAULT nextval('public.grupdesc_id_seq'::regclass);


--
-- Name: grupos_mt id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.grupos_mt ALTER COLUMN id SET DEFAULT nextval('public.grupos_mt_id_seq'::regclass);


--
-- Name: login_usuario id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.login_usuario ALTER COLUMN id SET DEFAULT nextval('public.login_usuario_id_seq'::regclass);


--
-- Name: logradouro id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.logradouro ALTER COLUMN id SET DEFAULT nextval('public.logradouro_id_seq'::regclass);


--
-- Name: ncm_4 id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.ncm_4 ALTER COLUMN id SET DEFAULT nextval('public.ncm_4_id_seq'::regclass);


--
-- Name: ncm_71218 id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.ncm_71218 ALTER COLUMN id SET DEFAULT nextval('public.ncm_71218_id_seq'::regclass);


--
-- Name: ncm_material id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.ncm_material ALTER COLUMN id SET DEFAULT nextval('public.ncm_material_id_seq'::regclass);


--
-- Name: produtos id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.produtos ALTER COLUMN id SET DEFAULT nextval('public.produtos_id_seq'::regclass);


--
-- Name: qtd_registros id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.qtd_registros ALTER COLUMN id SET DEFAULT nextval('public.qtd_registros_id_seq'::regclass);


--
-- Name: repres id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.repres ALTER COLUMN id SET DEFAULT nextval('public.repres_id_seq'::regclass);


--
-- Name: tp_pagamento id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.tp_pagamento ALTER COLUMN id SET DEFAULT nextval('public.tp_pagamento_id_seq'::regclass);


--
-- Name: tp_ped id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.tp_ped ALTER COLUMN id SET DEFAULT nextval('public.tp_ped_id_seq'::regclass);


--
-- Name: tp_ped_consulta id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.tp_ped_consulta ALTER COLUMN id SET DEFAULT nextval('public.tp_ped_consulta_id_seq'::regclass);


--
-- Name: trib_icms id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.trib_icms ALTER COLUMN id SET DEFAULT nextval('public.trib_icms_id_seq'::regclass);


--
-- Name: uf id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.uf ALTER COLUMN id SET DEFAULT nextval('public.uf_id_seq'::regclass);


--
-- Name: usuarios id; Type: DEFAULT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id SET DEFAULT nextval('public.usuarios_id_seq'::regclass);


--
-- Name: app_version app_version_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.app_version
    ADD CONSTRAINT app_version_pkey PRIMARY KEY (id);


--
-- Name: cidades cidades_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.cidades
    ADD CONSTRAINT cidades_pkey PRIMARY KEY (id);


--
-- Name: clientes clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.clientes
    ADD CONSTRAINT clientes_pkey PRIMARY KEY (id);


--
-- Name: combo_cab combo_cab_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.combo_cab
    ADD CONSTRAINT combo_cab_pkey PRIMARY KEY (id);


--
-- Name: combo_itens combo_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.combo_itens
    ADD CONSTRAINT combo_itens_pkey PRIMARY KEY (id);


--
-- Name: combo_repres combo_repres_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.combo_repres
    ADD CONSTRAINT combo_repres_pkey PRIMARY KEY (id);


--
-- Name: config config_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.config
    ADD CONSTRAINT config_pkey PRIMARY KEY (id);


--
-- Name: consulta_cd_pedido consulta_cd_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.consulta_cd_pedido
    ADD CONSTRAINT consulta_cd_pedido_pkey PRIMARY KEY (id);


--
-- Name: consulta_pedido_itens consulta_pedido_itens_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.consulta_pedido_itens
    ADD CONSTRAINT consulta_pedido_itens_pkey PRIMARY KEY (id);


--
-- Name: consulta_pedido consulta_pedido_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.consulta_pedido
    ADD CONSTRAINT consulta_pedido_pkey PRIMARY KEY (id);


--
-- Name: dc_prod dc_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dc_prod
    ADD CONSTRAINT dc_prod_pkey PRIMARY KEY (id);


--
-- Name: de_cli de_cli_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.de_cli
    ADD CONSTRAINT de_cli_pkey PRIMARY KEY (id);


--
-- Name: de_prod de_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.de_prod
    ADD CONSTRAINT de_prod_pkey PRIMARY KEY (id);


--
-- Name: de_repr de_repr_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.de_repr
    ADD CONSTRAINT de_repr_pkey PRIMARY KEY (id);


--
-- Name: des_cli des_cli_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.des_cli
    ADD CONSTRAINT des_cli_pkey PRIMARY KEY (id);


--
-- Name: des_prod des_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.des_prod
    ADD CONSTRAINT des_prod_pkey PRIMARY KEY (id);


--
-- Name: des_repr des_repr_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.des_repr
    ADD CONSTRAINT des_repr_pkey PRIMARY KEY (id);


--
-- Name: desc_condicional desc_condicional_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desc_condicional
    ADD CONSTRAINT desc_condicional_pkey PRIMARY KEY (id);


--
-- Name: desc_escala desc_escala_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desc_escala
    ADD CONSTRAINT desc_escala_pkey PRIMARY KEY (id);


--
-- Name: desconto_clientes desconto_clientes_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_clientes
    ADD CONSTRAINT desconto_clientes_pkey PRIMARY KEY (id);


--
-- Name: desconto_combinado_2 desconto_combinado_2_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_combinado_2
    ADD CONSTRAINT desconto_combinado_2_pkey PRIMARY KEY (id);


--
-- Name: desconto_combinado desconto_combinado_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_combinado
    ADD CONSTRAINT desconto_combinado_pkey PRIMARY KEY (id);


--
-- Name: desconto_estrategico desconto_estrategico_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_estrategico
    ADD CONSTRAINT desconto_estrategico_pkey PRIMARY KEY (id);


--
-- Name: desconto_eventos desconto_eventos_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.desconto_eventos
    ADD CONSTRAINT desconto_eventos_pkey PRIMARY KEY (id);


--
-- Name: dp_cab dp_cab_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dp_cab
    ADD CONSTRAINT dp_cab_pkey PRIMARY KEY (id);


--
-- Name: dp_pol dp_pol_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dp_pol
    ADD CONSTRAINT dp_pol_pkey PRIMARY KEY (id);


--
-- Name: dp_prod dp_prod_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.dp_prod
    ADD CONSTRAINT dp_prod_pkey PRIMARY KEY (id);


--
-- Name: fabr fabr_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.fabr
    ADD CONSTRAINT fabr_pkey PRIMARY KEY (id);


--
-- Name: filiais filiais_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.filiais
    ADD CONSTRAINT filiais_pkey PRIMARY KEY (id);


--
-- Name: grupdesc grupdesc_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.grupdesc
    ADD CONSTRAINT grupdesc_pkey PRIMARY KEY (id);


--
-- Name: grupos_mt grupos_mt_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.grupos_mt
    ADD CONSTRAINT grupos_mt_pkey PRIMARY KEY (id);


--
-- Name: login_usuario login_usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.login_usuario
    ADD CONSTRAINT login_usuario_pkey PRIMARY KEY (id);


--
-- Name: logradouro logradouro_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.logradouro
    ADD CONSTRAINT logradouro_pkey PRIMARY KEY (id);


--
-- Name: ncm_4 ncm_4_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.ncm_4
    ADD CONSTRAINT ncm_4_pkey PRIMARY KEY (id);


--
-- Name: ncm_71218 ncm_71218_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.ncm_71218
    ADD CONSTRAINT ncm_71218_pkey PRIMARY KEY (id);


--
-- Name: ncm_material ncm_material_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.ncm_material
    ADD CONSTRAINT ncm_material_pkey PRIMARY KEY (id);


--
-- Name: produtos produtos_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.produtos
    ADD CONSTRAINT produtos_pkey PRIMARY KEY (id);


--
-- Name: qtd_registros qtd_registros_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.qtd_registros
    ADD CONSTRAINT qtd_registros_pkey PRIMARY KEY (id);


--
-- Name: repres repres_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.repres
    ADD CONSTRAINT repres_pkey PRIMARY KEY (id);


--
-- Name: tp_pagamento tp_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.tp_pagamento
    ADD CONSTRAINT tp_pagamento_pkey PRIMARY KEY (id);


--
-- Name: tp_ped_consulta tp_ped_consulta_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.tp_ped_consulta
    ADD CONSTRAINT tp_ped_consulta_pkey PRIMARY KEY (id);


--
-- Name: tp_ped tp_ped_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.tp_ped
    ADD CONSTRAINT tp_ped_pkey PRIMARY KEY (id);


--
-- Name: trib_icms trib_icms_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.trib_icms
    ADD CONSTRAINT trib_icms_pkey PRIMARY KEY (id);


--
-- Name: uf uf_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.uf
    ADD CONSTRAINT uf_pkey PRIMARY KEY (id);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: poc_mcp_system
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id);


--
-- Name: idx_app_version_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_app_version_created_at ON public.app_version USING btree (created_at);


--
-- Name: idx_cidades_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_cidades_created_at ON public.cidades USING btree (created_at);


--
-- Name: idx_clientes_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_clientes_created_at ON public.clientes USING btree (created_at);


--
-- Name: idx_combo_cab_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_combo_cab_created_at ON public.combo_cab USING btree (created_at);


--
-- Name: idx_combo_itens_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_combo_itens_created_at ON public.combo_itens USING btree (created_at);


--
-- Name: idx_combo_repres_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_combo_repres_created_at ON public.combo_repres USING btree (created_at);


--
-- Name: idx_config_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_config_created_at ON public.config USING btree (created_at);


--
-- Name: idx_consulta_cd_pedido_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_consulta_cd_pedido_created_at ON public.consulta_cd_pedido USING btree (created_at);


--
-- Name: idx_consulta_pedido_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_consulta_pedido_created_at ON public.consulta_pedido USING btree (created_at);


--
-- Name: idx_consulta_pedido_itens_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_consulta_pedido_itens_created_at ON public.consulta_pedido_itens USING btree (created_at);


--
-- Name: idx_dc_prod_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_dc_prod_created_at ON public.dc_prod USING btree (created_at);


--
-- Name: idx_de_cli_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_de_cli_created_at ON public.de_cli USING btree (created_at);


--
-- Name: idx_de_prod_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_de_prod_created_at ON public.de_prod USING btree (created_at);


--
-- Name: idx_de_repr_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_de_repr_created_at ON public.de_repr USING btree (created_at);


--
-- Name: idx_des_cli_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_des_cli_created_at ON public.des_cli USING btree (created_at);


--
-- Name: idx_des_prod_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_des_prod_created_at ON public.des_prod USING btree (created_at);


--
-- Name: idx_des_repr_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_des_repr_created_at ON public.des_repr USING btree (created_at);


--
-- Name: idx_desc_condicional_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desc_condicional_created_at ON public.desc_condicional USING btree (created_at);


--
-- Name: idx_desc_escala_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desc_escala_created_at ON public.desc_escala USING btree (created_at);


--
-- Name: idx_desconto_clientes_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desconto_clientes_created_at ON public.desconto_clientes USING btree (created_at);


--
-- Name: idx_desconto_combinado_2_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desconto_combinado_2_created_at ON public.desconto_combinado_2 USING btree (created_at);


--
-- Name: idx_desconto_combinado_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desconto_combinado_created_at ON public.desconto_combinado USING btree (created_at);


--
-- Name: idx_desconto_estrategico_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desconto_estrategico_created_at ON public.desconto_estrategico USING btree (created_at);


--
-- Name: idx_desconto_eventos_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_desconto_eventos_created_at ON public.desconto_eventos USING btree (created_at);


--
-- Name: idx_dp_cab_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_dp_cab_created_at ON public.dp_cab USING btree (created_at);


--
-- Name: idx_dp_pol_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_dp_pol_created_at ON public.dp_pol USING btree (created_at);


--
-- Name: idx_dp_prod_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_dp_prod_created_at ON public.dp_prod USING btree (created_at);


--
-- Name: idx_fabr_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_fabr_created_at ON public.fabr USING btree (created_at);


--
-- Name: idx_filiais_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_filiais_created_at ON public.filiais USING btree (created_at);


--
-- Name: idx_grupdesc_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_grupdesc_created_at ON public.grupdesc USING btree (created_at);


--
-- Name: idx_grupos_mt_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_grupos_mt_created_at ON public.grupos_mt USING btree (created_at);


--
-- Name: idx_login_usuario_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_login_usuario_created_at ON public.login_usuario USING btree (created_at);


--
-- Name: idx_logradouro_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_logradouro_created_at ON public.logradouro USING btree (created_at);


--
-- Name: idx_ncm_4_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_ncm_4_created_at ON public.ncm_4 USING btree (created_at);


--
-- Name: idx_ncm_71218_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_ncm_71218_created_at ON public.ncm_71218 USING btree (created_at);


--
-- Name: idx_ncm_material_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_ncm_material_created_at ON public.ncm_material USING btree (created_at);


--
-- Name: idx_produtos_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_produtos_created_at ON public.produtos USING btree (created_at);


--
-- Name: idx_qtd_registros_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_qtd_registros_created_at ON public.qtd_registros USING btree (created_at);


--
-- Name: idx_repres_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_repres_created_at ON public.repres USING btree (created_at);


--
-- Name: idx_tp_pagamento_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_tp_pagamento_created_at ON public.tp_pagamento USING btree (created_at);


--
-- Name: idx_tp_ped_consulta_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_tp_ped_consulta_created_at ON public.tp_ped_consulta USING btree (created_at);


--
-- Name: idx_tp_ped_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_tp_ped_created_at ON public.tp_ped USING btree (created_at);


--
-- Name: idx_trib_icms_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_trib_icms_created_at ON public.trib_icms USING btree (created_at);


--
-- Name: idx_uf_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_uf_created_at ON public.uf USING btree (created_at);


--
-- Name: idx_usuarios_created_at; Type: INDEX; Schema: public; Owner: poc_mcp_system
--

CREATE INDEX idx_usuarios_created_at ON public.usuarios USING btree (created_at);


--
-- Name: app_version update_app_version_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_app_version_updated_at BEFORE UPDATE ON public.app_version FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: cidades update_cidades_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_cidades_updated_at BEFORE UPDATE ON public.cidades FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: clientes update_clientes_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_clientes_updated_at BEFORE UPDATE ON public.clientes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: combo_cab update_combo_cab_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_combo_cab_updated_at BEFORE UPDATE ON public.combo_cab FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: combo_itens update_combo_itens_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_combo_itens_updated_at BEFORE UPDATE ON public.combo_itens FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: combo_repres update_combo_repres_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_combo_repres_updated_at BEFORE UPDATE ON public.combo_repres FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: config update_config_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_config_updated_at BEFORE UPDATE ON public.config FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: consulta_cd_pedido update_consulta_cd_pedido_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_consulta_cd_pedido_updated_at BEFORE UPDATE ON public.consulta_cd_pedido FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: consulta_pedido_itens update_consulta_pedido_itens_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_consulta_pedido_itens_updated_at BEFORE UPDATE ON public.consulta_pedido_itens FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: consulta_pedido update_consulta_pedido_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_consulta_pedido_updated_at BEFORE UPDATE ON public.consulta_pedido FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dc_prod update_dc_prod_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_dc_prod_updated_at BEFORE UPDATE ON public.dc_prod FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: de_cli update_de_cli_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_de_cli_updated_at BEFORE UPDATE ON public.de_cli FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: de_prod update_de_prod_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_de_prod_updated_at BEFORE UPDATE ON public.de_prod FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: de_repr update_de_repr_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_de_repr_updated_at BEFORE UPDATE ON public.de_repr FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: des_cli update_des_cli_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_des_cli_updated_at BEFORE UPDATE ON public.des_cli FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: des_prod update_des_prod_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_des_prod_updated_at BEFORE UPDATE ON public.des_prod FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: des_repr update_des_repr_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_des_repr_updated_at BEFORE UPDATE ON public.des_repr FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desc_condicional update_desc_condicional_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desc_condicional_updated_at BEFORE UPDATE ON public.desc_condicional FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desc_escala update_desc_escala_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desc_escala_updated_at BEFORE UPDATE ON public.desc_escala FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desconto_clientes update_desconto_clientes_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desconto_clientes_updated_at BEFORE UPDATE ON public.desconto_clientes FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desconto_combinado_2 update_desconto_combinado_2_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desconto_combinado_2_updated_at BEFORE UPDATE ON public.desconto_combinado_2 FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desconto_combinado update_desconto_combinado_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desconto_combinado_updated_at BEFORE UPDATE ON public.desconto_combinado FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desconto_estrategico update_desconto_estrategico_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desconto_estrategico_updated_at BEFORE UPDATE ON public.desconto_estrategico FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: desconto_eventos update_desconto_eventos_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_desconto_eventos_updated_at BEFORE UPDATE ON public.desconto_eventos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dp_cab update_dp_cab_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_dp_cab_updated_at BEFORE UPDATE ON public.dp_cab FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dp_pol update_dp_pol_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_dp_pol_updated_at BEFORE UPDATE ON public.dp_pol FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: dp_prod update_dp_prod_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_dp_prod_updated_at BEFORE UPDATE ON public.dp_prod FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: fabr update_fabr_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_fabr_updated_at BEFORE UPDATE ON public.fabr FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: filiais update_filiais_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_filiais_updated_at BEFORE UPDATE ON public.filiais FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: grupdesc update_grupdesc_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_grupdesc_updated_at BEFORE UPDATE ON public.grupdesc FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: grupos_mt update_grupos_mt_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_grupos_mt_updated_at BEFORE UPDATE ON public.grupos_mt FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: login_usuario update_login_usuario_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_login_usuario_updated_at BEFORE UPDATE ON public.login_usuario FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: logradouro update_logradouro_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_logradouro_updated_at BEFORE UPDATE ON public.logradouro FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ncm_4 update_ncm_4_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_ncm_4_updated_at BEFORE UPDATE ON public.ncm_4 FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ncm_71218 update_ncm_71218_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_ncm_71218_updated_at BEFORE UPDATE ON public.ncm_71218 FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: ncm_material update_ncm_material_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_ncm_material_updated_at BEFORE UPDATE ON public.ncm_material FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: produtos update_produtos_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_produtos_updated_at BEFORE UPDATE ON public.produtos FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: qtd_registros update_qtd_registros_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_qtd_registros_updated_at BEFORE UPDATE ON public.qtd_registros FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: repres update_repres_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_repres_updated_at BEFORE UPDATE ON public.repres FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tp_pagamento update_tp_pagamento_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_tp_pagamento_updated_at BEFORE UPDATE ON public.tp_pagamento FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tp_ped_consulta update_tp_ped_consulta_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_tp_ped_consulta_updated_at BEFORE UPDATE ON public.tp_ped_consulta FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: tp_ped update_tp_ped_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_tp_ped_updated_at BEFORE UPDATE ON public.tp_ped FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: trib_icms update_trib_icms_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_trib_icms_updated_at BEFORE UPDATE ON public.trib_icms FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: uf update_uf_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_uf_updated_at BEFORE UPDATE ON public.uf FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: usuarios update_usuarios_updated_at; Type: TRIGGER; Schema: public; Owner: poc_mcp_system
--

CREATE TRIGGER update_usuarios_updated_at BEFORE UPDATE ON public.usuarios FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- PostgreSQL database dump complete
--

