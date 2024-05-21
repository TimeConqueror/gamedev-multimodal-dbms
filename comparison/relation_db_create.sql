-- Players
CREATE TABLE IF NOT EXISTS public.players
(
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT players_pkey PRIMARY KEY (id)
    )

-- Clans
(
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    id bigint NOT NULL,
    CONSTRAINT clans_pkey PRIMARY KEY (id)
    )

-- Player Clans
CREATE TABLE IF NOT EXISTS public.players_clans
(
    player_id bigint NOT NULL,
    clan_id bigint NOT NULL,
    CONSTRAINT players_clans_pkey PRIMARY KEY (player_id, clan_id),
    CONSTRAINT cl FOREIGN KEY (clan_id)
    REFERENCES public.clans (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID,
    CONSTRAINT pl FOREIGN KEY (player_id)
    REFERENCES public.players (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID
    )

-- Clan Relations
CREATE TABLE IF NOT EXISTS public.clan_relations
(
    state character varying(10) COLLATE pg_catalog."default" NOT NULL,
    rel_id bigint NOT NULL,
    clan_id1 bigint NOT NULL,
    clan_id2 bigint NOT NULL,
    CONSTRAINT clan_relations_pkey PRIMARY KEY (rel_id),
    CONSTRAINT fk1 FOREIGN KEY (clan_id1)
    REFERENCES public.clans (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID,
    CONSTRAINT fk2 FOREIGN KEY (clan_id2)
    REFERENCES public.clans (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID
    )

-- Users
CREATE TABLE IF NOT EXISTS public.users
(
    id bigint NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    name character varying(16) COLLATE pg_catalog."default",
    data text COLLATE pg_catalog."default",
    CONSTRAINT users_pkey PRIMARY KEY (id)
    )

-- Quests
CREATE TABLE IF NOT EXISTS public.quests
(
    id integer NOT NULL DEFAULT nextval('quests_id_seq'::regclass),
    data text COLLATE pg_catalog."default",
    CONSTRAINT quests_pkey PRIMARY KEY (id)
    )

-- Users Quests
CREATE TABLE IF NOT EXISTS public.users_quests
(
    user_id integer NOT NULL,
    quest_id integer NOT NULL,
    finished boolean NOT NULL DEFAULT true,
    CONSTRAINT quest_fk FOREIGN KEY (quest_id)
    REFERENCES public.quests (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID,
    CONSTRAINT user_fk FOREIGN KEY (user_id)
    REFERENCES public.users (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID
    )

    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS users_quests_i_user
    ON public.users_quests USING btree
    (user_id ASC NULLS LAST)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS users_quests_i_user_quest
    ON public.users_quests USING btree
    (user_id ASC NULLS LAST, quest_id ASC NULLS LAST)
    TABLESPACE pg_default;

-- Instructions
CREATE TABLE IF NOT EXISTS public.instructions
(
    id bigint NOT NULL,
    type character varying(255) COLLATE pg_catalog."default" NOT NULL,
    data text COLLATE pg_catalog."default",
    npc character varying(200) COLLATE pg_catalog."default",
    CONSTRAINT instructions_pkey PRIMARY KEY (id)
    )

-- Instruction Links
CREATE TABLE IF NOT EXISTS public.instruction_links
(
    instruction_id bigint NOT NULL,
    predicate text COLLATE pg_catalog."default",
    next_id bigint,
    CONSTRAINT source_fk FOREIGN KEY (instruction_id)
    REFERENCES public.instructions (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID,
    CONSTRAINT target_fk FOREIGN KEY (next_id)
    REFERENCES public.instructions (id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID
    )