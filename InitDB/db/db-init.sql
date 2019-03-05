CREATE TABLE Account (id SERIAL NOT NULL,
  email VARCHAR,
  name VARCHAR NOT NULL,
  firstName VARCHAR NOT NULL,
  lastName VARCHAR NOT NULL,
  PRIMARY KEY (id)
);

-- table to hold auth2 details
CREATE TABLE UserConnection (tokenId VARCHAR NOT NULL,
  googleUserId VARCHAR(255) NOT NULL,
  accessToken VARCHAR(255) NOT NULL,
  expireTime BIGINT,
  refreshToken VARCHAR(255),
  tokenType VARCHAR(255) NOT NULL,
  userId INT NOT NULL,
  PRIMARY KEY (tokenId),
  FOREIGN KEY(userId) REFERENCES Account(id)
);

CREATE TABLE Analysis (id SERIAL NOT NULL,
  owner INT NOT NULL,
  title VARCHAR NOT NULL,
  outcome varchar(255) NOT NULL,
  problem JSONB NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(owner) REFERENCES Account(id)
);

CREATE TABLE Model (
  id SERIAL NOT NULL,
  title VARCHAR NOT NULL,
  analysisId INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY(analysisId) REFERENCES Analysis(id)
);

CREATE TABLE PataviTask (
  id SERIAL NOT NULL,
  modelId INT NOT NULL,
  method varchar,
  problem JSONB,
  result TEXT,
  PRIMARY KEY(id),
  FOREIGN KEY(modelId) REFERENCES Model(id)
);
DROP TABLE patavitask;

ALTER TABLE model add column taskId INT;

ALTER TABLE model add column linearModel VARCHAR NOT NULL DEFAULT 'fixed';
ALTER TABLE analysis DROP COLUMN outcome;
ALTER TABLE analysis ADD COLUMN outcome JSONB NOT NULL DEFAULT '{"name": "automatically generated name"}';

ALTER TABLE model ADD COLUMN modelType JSONB NOT NULL DEFAULT '{"type": "network"}';
ALTER TABLE model ADD COLUMN burn_in_iterations INT NOT NULL DEFAULT 5000;
ALTER TABLE model ADD COLUMN inference_iterations INT NOT NULL DEFAULT 20000;
ALTER TABLE model ADD COLUMN thinning_factor INT NOT NULL DEFAULT 10;
BEGIN;

ALTER TABLE model ADD COLUMN likelihood VARCHAR(255);
ALTER TABLE model ADD COLUMN link VARCHAR(255);

UPDATE model SET likelihood = 'normal', link='identity' ;
UPDATE model SET likelihood = 'binom', link='logit' FROM analysis
  WHERE model.analysisid = analysis.id AND (analysis.problem->'entries'->0->>'responders')::int IS NOT NULL;

ALTER TABLE model ALTER likelihood SET NOT NULL;
ALTER TABLE model ALTER link SET NOT NULL;

ALTER TABLE model ADD COLUMN outcome_scale DOUBLE PRECISION;

COMMIT;ALTER TABLE model ADD COLUMN heterogeneity_prior JSONB;
ALTER TABLE model ADD COLUMN regressor JSONB;
ALTER TABLE analysis ADD COLUMN primaryModel INT;
ALTER TABLE analysis ADD FOREIGN KEY(primaryModel) REFERENCES model(id);ALTER TABLE model ADD COLUMN sensitivity JSONB;
-- change taskid to be new patavi URIs
UPDATE model SET taskid = NULL ;
ALTER TABLE model ALTER COLUMN taskid TYPE VARCHAR(128) ;
ALTER TABLE model RENAME COLUMN taskid TO taskUrl ;
-- add archive colum
ALTER TABLE model ADD COLUMN "archived" boolean NOT NULL DEFAULT FALSE ;
ALTER TABLE model ADD COLUMN "archived_on" date;
CREATE TABLE funnelplot (
  plotId SERIAL NOT NULL,
  modelId INT NOT NULL,
  t1 INT NOT NULL,
  t2 INT NOT NULL,
  biasDirection VARCHAR NOT NULL,
  PRIMARY KEY (plotid, modelId, t1, t2)
);
CREATE TABLE modelBaseline (
  modelId INT NOT NULL,
  baseline JSONB NOT NULL,
  PRIMARY KEY (modelId),
  FOREIGN KEY (modelId) REFERENCES model(id)
);
CREATE TABLE "session" (
  "sid" varchar NOT NULL COLLATE "default",
        "sess" json NOT NULL,
        "expire" timestamp(6) NOT NULL
)
WITH (OIDS=FALSE);
ALTER TABLE "session" ADD CONSTRAINT "session_pkey" PRIMARY KEY ("sid") NOT DEFERRABLE INITIALLY IMMEDIATE;

DROP TABLE UserConnection;
ALTER TABLE account ADD COLUMN username VARCHAR;
ALTER TABLE account ADD COLUMN password VARCHAR DEFAULT '';
ALTER TABLE account DROP COLUMN name;

INSERT INTO Account (username, firstName, lastName, password) VALUES ('user1', 'user1', 'user', '$2a$14$xBM5MUyrzpqdjtNd3deoTuSNVpPC081TyXHibH4bQMF0QZyDIkw9i');
