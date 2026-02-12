--
-- PostgreSQL database dump
--

\restrict IXDVrGoD6P5wb9Im2SULreTvF1tY4c0ONUBg3VZruO5HJdR0eqHJmcAXt9pultv

-- Dumped from database version 18.1 (Debian 18.1-2)
-- Dumped by pg_dump version 18.1 (Debian 18.1-2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: contact_inquiry; Type: TABLE; Schema: public; Owner: don
--

CREATE TABLE public.contact_inquiry (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    email character varying(100) NOT NULL,
    message text NOT NULL,
    "timestamp" timestamp without time zone
);


ALTER TABLE public.contact_inquiry OWNER TO don;

--
-- Name: contact_inquiry_id_seq; Type: SEQUENCE; Schema: public; Owner: don
--

CREATE SEQUENCE public.contact_inquiry_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contact_inquiry_id_seq OWNER TO don;

--
-- Name: contact_inquiry_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: don
--

ALTER SEQUENCE public.contact_inquiry_id_seq OWNED BY public.contact_inquiry.id;


--
-- Name: project; Type: TABLE; Schema: public; Owner: don
--

CREATE TABLE public.project (
    id integer NOT NULL,
    title character varying(100) NOT NULL,
    description text NOT NULL,
    github_link character varying(200),
    icon character varying(50),
    color character varying(20),
    status character varying(20)
);


ALTER TABLE public.project OWNER TO don;

--
-- Name: project_id_seq; Type: SEQUENCE; Schema: public; Owner: don
--

CREATE SEQUENCE public.project_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.project_id_seq OWNER TO don;

--
-- Name: project_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: don
--

ALTER SEQUENCE public.project_id_seq OWNED BY public.project.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: don
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    username character varying(150) NOT NULL,
    password character varying(255) NOT NULL
);


ALTER TABLE public."user" OWNER TO don;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: don
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.user_id_seq OWNER TO don;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: don
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: contact_inquiry id; Type: DEFAULT; Schema: public; Owner: don
--

ALTER TABLE ONLY public.contact_inquiry ALTER COLUMN id SET DEFAULT nextval('public.contact_inquiry_id_seq'::regclass);


--
-- Name: project id; Type: DEFAULT; Schema: public; Owner: don
--

ALTER TABLE ONLY public.project ALTER COLUMN id SET DEFAULT nextval('public.project_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: don
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Data for Name: contact_inquiry; Type: TABLE DATA; Schema: public; Owner: don
--

COPY public.contact_inquiry (id, name, email, message, "timestamp") FROM stdin;
1	Don Hemsworth	h74205311@gmail.com	Help me create a new website	2026-02-12 19:46:06.375389
2	Lamartine Kipkoech 	mirriamcharles@gmail.com	Hdjdjdhsgb	2026-02-12 19:49:26.026546
\.


--
-- Data for Name: project; Type: TABLE DATA; Schema: public; Owner: don
--

COPY public.project (id, title, description, github_link, icon, color, status) FROM stdin;
2	Watch Dog	This is a security tool that can be used to monitor every activity done in a pc and be forwarded to a designated email	https://github.com/Lamartine587/watchdog.git	fas fa-eye	#10b981	Completed
1	Obsidian Vault	This is a port security tool that you can use to secure your ports	https://github.com/Lamartine587/ObsidianVault.git	fas fa-shield	#10b981	Planning
\.


--
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: don
--

COPY public."user" (id, username, password) FROM stdin;
1	mart	pbkdf2:sha256:600000$ARHfEpZoma5OjZqt$d320670e46255bec62be88c9430d0ead43dd7f42f46d3dbd5261004c30644deb
\.


--
-- Name: contact_inquiry_id_seq; Type: SEQUENCE SET; Schema: public; Owner: don
--

SELECT pg_catalog.setval('public.contact_inquiry_id_seq', 2, true);


--
-- Name: project_id_seq; Type: SEQUENCE SET; Schema: public; Owner: don
--

SELECT pg_catalog.setval('public.project_id_seq', 2, true);


--
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: don
--

SELECT pg_catalog.setval('public.user_id_seq', 1, true);


--
-- Name: contact_inquiry contact_inquiry_pkey; Type: CONSTRAINT; Schema: public; Owner: don
--

ALTER TABLE ONLY public.contact_inquiry
    ADD CONSTRAINT contact_inquiry_pkey PRIMARY KEY (id);


--
-- Name: project project_pkey; Type: CONSTRAINT; Schema: public; Owner: don
--

ALTER TABLE ONLY public.project
    ADD CONSTRAINT project_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: don
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user user_username_key; Type: CONSTRAINT; Schema: public; Owner: don
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_username_key UNIQUE (username);


--
-- PostgreSQL database dump complete
--

\unrestrict IXDVrGoD6P5wb9Im2SULreTvF1tY4c0ONUBg3VZruO5HJdR0eqHJmcAXt9pultv

