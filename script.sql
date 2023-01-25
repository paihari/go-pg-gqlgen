


CREATE TABLE domains (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE classes (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE stages (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE privileges (
    id SERIAL,
    name VARCHAR(128) UNIQUE,
    description VARCHAR(256),
    scope VARCHAR(32),
    policies TEXT[],
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    attempt INTEGER,
    UNIQUE(name, scope),
    PRIMARY KEY(id)
);

CREATE TABLE tasks (
    id SERIAL,
    name VARCHAR(128),
    description VARCHAR(256),
    privilege_id INTEGER REFERENCES privilege(id) DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    attempt INTEGER,
    UNIQUE(name, privilege_id),
    PRIMARY KEY(id)
);

CREATE TABLE roles (
    id SERIAL,
    domain_id INTEGER REFERENCES domain(id) DEFAULT 1,
    task_id INTEGER REFERENCES task(id)  ON DELETE CASCADE DEFAULT 1,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE notifications (
    id SERIAL,
    control VARCHAR(32) UNIQUE,
    scope TEXT,
    content TEXT[],
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE budgets (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    reference VARCHAR(32),
    term VARCHAR(32),
    amount INTEGER,
    correction SMALLINT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE alerts (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    measure VARCHAR(32),
    threshold INTEGER,
    budget_id INTEGER REFERENCES budget(id) DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE channels (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT,
    stage SMALLINT,
    service VARCHAR(32),
    address VARCHAR(64),
    alert_id INTEGER REFERENCES alert(id) DEFAULT 1,
    notification_id INTEGER REFERENCES notification(id) ON DELETE CASCADE DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE subscriptions (
    id SERIAL,
    topic VARCHAR(32),
    role_id INTEGER REFERENCES roles(id) DEFAULT 1,
    channel_id INTEGER REFERENCES channels(id) ON DELETE CASCADE DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE agreements (
    id SERIAL,
    topic VARCHAR(32),
    role_id INTEGER REFERENCES roles(id) DEFAULT 1,
    channel_id INTEGER REFERENCES channels(id) ON DELETE CASCADE DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);




INSERT INTO domains(name, description) VALUES ('service', 'The service domain is for root admins and auditors only');
INSERT INTO domains(name, description) VALUES ('application', 'The application domain is for operators who oversee the installation, patching and updating of software applications');
INSERT INTO domains(name, description) VALUES ('network', 'The network domain is for operators who manage, monitor, maintain, secure, and service the network.');
INSERT INTO domains(name, description) VALUES ('database', 'The database domain is for operators who ensure the performance, integrity and security of a databases');
INSERT INTO domains(name, description) VALUES ('operations', 'The scurity operation domain is for operator who deal with security issues on an organizational and technical level');

-- look up table for contract classifications
INSERT INTO classes(name, description) VALUES ('free', 'The service is deployed into a free-tier account.');
INSERT INTO classes(name, description) VALUES ('trial', 'The service represents a sponsored proof-of-concept and has to abide to budget restrictions.');
INSERT INTO classes(name, description) VALUES ('payg', 'Provisioning resources immedeately increases the cloud bill.');
INSERT INTO classes(name, description) VALUES ('commit', 'The service budget is planned ahead and resources are accounted against a credit commitment.');

-- look up table for contract classifications
INSERT INTO stages(name, description) VALUES ('development', 'The service is still under development.');
INSERT INTO stages(name, description) VALUES ('uat', 'The service is in user acceptance testing, data is not persisted.');
INSERT INTO stages(name, description) VALUES ('production', 'The service is in production and has to comply with the securty and compliance guidelines.');


INSERT INTO privileges(name, description, scope, policies, attempt) 
    VALUES ('Let the Help Desk manage users', 'Ability to create, update, and delete users and their credentials. It does not include the ability to put users in groups', 'tenancy', '{"Allow group HelpDesk to manage users in tenancy"}', 1)
    ON CONFLICT (name, scope)
    DO UPDATE SET attempt = privileges.attempt + 1
RETURNING *;
INSERT INTO privileges(name, description, scope, policies, attempt) VALUES ('Let auditors inspect your resources', 'Ability to list the resources in all compartments', 'tenancy', '{"Allow group Auditors to inspect all-resources in tenancy" , "Allow group Auditors to read instances in tenancy" , "Allow group Auditors to read audit-events in tenancy"}', 1)
    ON CONFLICT (name, scope)
    DO UPDATE SET attempt = privileges.attempt + 1
RETURNING *;

-- reference table that defines operator tasks, based on predefined privileges
INSERT INTO tasks(name, description, privilege_id, attempt) 
    VALUES ('cloudops', 'ability to manage resources for the entire service resident', 1, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt) 
    VALUES ('sysops', 'tbd', null, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt)
    VALUES ('netops', 'tbd', null, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt)
    VALUES ('dba', 'tbd', null, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt)
    VALUES ('secops', 'tbd', null, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt)
    VALUES ('cloudops', 'ability to manage resources for the entire service resident', 2, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt)
    VALUES ('helpdesk', 'ability to investigate resources for the entire service resident', 1, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;
INSERT INTO tasks(name, description, privilege_id, attempt)
    VALUES ('auditor', 'ability to monitor resources for the entire service resident', 2, 1)
    ON CONFLICT (name, privilege_id)
    DO UPDATE SET attempt = tasks.attempt + 1
RETURNING *;

-- matching table combines domains and tasks into operator roles
INSERT INTO roles(domain_id, task_id, class, stage) VALUES (1, 1, 1, 1);
INSERT INTO roles(domain_id, task_id, class, stage) VALUES (2, 2, 1, 1);
INSERT INTO roles(domain_id, task_id, class, stage) VALUES (3, 3, 1, 1);
INSERT INTO roles(domain_id, task_id, class, stage) VALUES (4, 4, 1, 1);
INSERT INTO roles(domain_id, task_id, class, stage) VALUES (5, 5, 1, 1);


-- lookup table for operator notifications
INSERT INTO notifications(control, scope, content) VALUES ('application', 'software application that is served by the resources', '{"IT", "HR", "Sales"}');
INSERT INTO notifications(control, scope, content) VALUES ('version', 'track version of the service', '{"0.0.1"}');
INSERT INTO notifications(control, scope, content) VALUES ('confidentiallity', 'track the date of the last update', '{"open", "restricted", "confidential", "secret", "top_secret"}');

-- allows for cost tracking
INSERT INTO budgets(name, reference, amount, term, correction) VALUES ('IT', 'cost_center', 100, 'monthly', 1);
INSERT INTO budgets(name, reference, amount, term, correction) VALUES ('HR', 'cost_center', 100, 'monthly', 1);
INSERT INTO budgets(name, reference, amount, term, correction) VALUES ('Sales', 'cost_center', 100, 'monthly', 1);
INSERT INTO budgets(name, reference, amount, term, correction) VALUES ('Development', 'cost_type', 100, 'monthly', 1);
INSERT INTO budgets(name, reference, amount, term, correction) VALUES ('User', 'created_by', 100, 'monthly', 1);

-- table defines alerts for budget violations
INSERT INTO alerts(name, description, measure, threshold, budget_id) VALUES ('limit', 'warn admin when UCC runs against a limit', 'PERCENTAGE', 90, 1);
INSERT INTO alerts(name, description, measure, threshold, budget_id) VALUES ('credits', 'warn admin when UCC run out', 'ABSOLUTE', 100, 1);

-- look up table for communication channels
INSERT INTO channel(name, description, class, stage, service, address, alert_id, notification_id) VALUES ('activation', 'tbd', 1, 1, 'EMAIL', 'ace_de@oracle.com', 1, null);
INSERT INTO channel(name, description, class, stage, service, address, alert_id, notification_id) VALUES ('incident', 'tbd', 1, 1, 'SLACK', 'https://bit.ly/3iqR5H8', null, 1);

-- many to many tabble that subscirbes admin operators to notification channels
INSERT INTO subscriptions(topic, role_id, channel_id) VALUES ('operation', 1, 2); 
INSERT INTO subscriptions(topic, role_id, channel_id) VALUES ('governance', 1, 1);
INSERT INTO subscriptions(topic, role_id, channel_id) VALUES ('cost', 1, 1);

-- many to many tabble that subscirbes admin operators to notification channels
INSERT INTO agreements(topic, role_id, channel_id) VALUES ('operation', 1, 2); 
INSERT INTO agreements(topic, role_id, channel_id) VALUES ('governance', 1, 1);
INSERT INTO agreements(topic, role_id, channel_id) VALUES ('cost', 1, 1);


CREATE TABLE sizes (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    cores SMALLINT,
    storage INTEGER,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE backups (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);



CREATE TABLE dbs (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    managed BOOLEAN DEFAULT TRUE,
    version TEXT[],
    model TEXT[],
    license TEXT[],
    secret VARCHAR(32),
    size_id INTEGER REFERENCES sizes(id) DEFAULT 1,
    backup_id INTEGER REFERENCES backups(id) DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);



CREATE TABLE buckets (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    providerkey BOOLEAN DEFAULT TRUE,
    observe BOOLEAN DEFAULT TRUE,
    replicate BOOLEAN DEFAULT TRUE,
    internet BOOLEAN DEFAULT TRUE,
    tiered BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE filesystems (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);



CREATE TABLE residents (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    account VARCHAR(32) UNIQUE,
    dbs_id INTEGER REFERENCES dbs(id) ON DELETE CASCADE DEFAULT 1,
    bucket_id INTEGER REFERENCES buckets(id) ON DELETE CASCADE DEFAULT 1,
    filesystem_id INTEGER REFERENCES filesystems(id) ON DELETE CASCADE DEFAULT 1,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);




INSERT INTO sizes (name, cores, storage) VALUES ('small', 2, 128);
INSERT INTO sizes (name, cores, storage) VALUES ('medium', 4, 256);
INSERT INTO sizes (name, cores, storage) VALUES ('large', 8, 512);

INSERT INTO backups(name, description) VALUES ('database', 'storage for database backups');

INSERT INTO dbs(name, class, stage, managed, version, model, license, size_id, backup_id) VALUES ('autonomous', 1, 1, TRUE, '{"19c"}', '{"OLTP", "DW", "JSON", "APEX"}', '{"LICENSE_INCLUDED"}', 1, null);

INSERT INTO buckets(name, description, class, stage, providerkey, observe, replicate, internet, tiered) VALUES ('operation', 'storage for operational data', 2, 1, null, FALSE, FALSE, FALSE, FALSE);
INSERT INTO buckets(name, description, class, stage, providerkey, observe, replicate, internet, tiered) VALUES ('share', 'document share', 2, 1, null, FALSE, FALSE, TRUE, FALSE);

-- look up table for filesystems
INSERT INTO filesystems(name, description, class, stage) VALUES ('dwh', 'filesystem for the operation data warehouse', 3, 3);

INSERT INTO residents(name, description, account, dbs_id, bucket_id, filesystem_id) VALUES ('oci.compartment.xxx', 'service description', 'oci.tenancy.xxx', 2, 1, 1);



-- Other Scripts

CREATE TABLE vpcs (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    cidr_block TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    vpc_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE internetgateways (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    internet_gateway_id TEXT,
    vpc_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);


CREATE TABLE route_tables (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    route_table_id TEXT,
    vpc_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE routes (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    cidr_block TEXT,
    internet_gateway_id TEXT,
    route_table_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE subnets (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    subnet_id TEXT,
    cidr_block TEXT,
    vpc_id TEXT,
    route_table_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE security_groups (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    vpc_id TEXT,
    security_group_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE network_interfaces (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    subnet_id TEXT,
    security_group_id TEXT, 
    private_ip_address TEXT,
    network_interface_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE elastic_ips (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    network_interface_id TEXT,
    allocation_id TEXT,
    ip_address TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);

CREATE TABLE instances (
    id SERIAL,
    name VARCHAR(32) UNIQUE,
    description TEXT,
    class SMALLINT DEFAULT 1,
    stage SMALLINT DEFAULT 1,
    image_id TEXT,
    instance_type TEXT,
    instance_id TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY(id)
);










https://github.com/go-pg/pg/issues/654
