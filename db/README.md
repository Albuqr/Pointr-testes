CREATE DATABASE IF NOT EXISTS pointr
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_0900_ai_ci;

USE pointr;

-- ---------------------------------------------------------------------
-- Tecnico: dono da conta. Cadastra times e abre sessões de treino.
-- ---------------------------------------------------------------------
CREATE TABLE Tecnico (
  id_tecnico        INT PRIMARY KEY AUTO_INCREMENT,
  nome              VARCHAR(100) NOT NULL,
  email             VARCHAR(100) UNIQUE NOT NULL,
  cref              VARCHAR(100) UNIQUE,                  -- registro profissional (opcional)
  categoria_atuacao VARCHAR(100) NOT NULL,
  plano             ENUM('basico','com_video') NOT NULL DEFAULT 'basico',
  salvar_video_nuvem BOOLEAN NOT NULL DEFAULT FALSE        -- só vale no plano 'com_video'
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Time: pertence a um técnico.
-- ---------------------------------------------------------------------
CREATE TABLE Time (
  id_time    INT PRIMARY KEY AUTO_INCREMENT,
  nome       VARCHAR(100) NOT NULL,
  id_tecnico INT NOT NULL,
  FOREIGN KEY (id_tecnico) REFERENCES Tecnico(id_tecnico),
  INDEX idx_time_tecnico (id_tecnico)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Jogador: pertence a um time. Número da camisa é único dentro do time.
-- ---------------------------------------------------------------------
CREATE TABLE Jogador (
  id_jogador      INT PRIMARY KEY AUTO_INCREMENT,
  id_time         INT NOT NULL,
  nome            VARCHAR(100) NOT NULL,
  data_nascimento DATE NOT NULL,
  altura          DECIMAL(3,2) NOT NULL,                  -- em metros, ex.: 1.92
  peso            DECIMAL(5,2) NOT NULL,                  -- em kg, ex.: 84.50
  n_camisa        INT NOT NULL,
  posicao         VARCHAR(30) NOT NULL,
  FOREIGN KEY (id_time) REFERENCES Time(id_time),
  UNIQUE (id_time, n_camisa),
  INDEX idx_jogador_time (id_time)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Sessao: uma gravação de treino (uma execução do edge).
-- cobertura_pct vem do relatório de cobertura gerado por sessão.
-- ---------------------------------------------------------------------
CREATE TABLE Sessao (
  id_sessao     INT PRIMARY KEY AUTO_INCREMENT,
  data          DATE NOT NULL,
  hora_inicio   TIME NOT NULL,
  hora_fim      TIME,                                      -- NULL enquanto a sessão está aberta
  cobertura_pct DECIMAL(5,2),                              -- 0.00 a 100.00
  status_sync   ENUM('pendente','sincronizada') NOT NULL DEFAULT 'pendente',
  INDEX idx_sessao_data (data)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Sessao_Time: N:N. Um treino pode ter mais de um time em quadra.
-- ---------------------------------------------------------------------
CREATE TABLE Sessao_Time (
  id_sessao INT,
  id_time   INT,
  PRIMARY KEY (id_sessao, id_time),
  FOREIGN KEY (id_sessao) REFERENCES Sessao(id_sessao),
  FOREIGN KEY (id_time)   REFERENCES Time(id_time)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Rastreamento: uma trilha (track) do ByteTrack dentro de uma sessão.
-- id_jogador fica NULL até alguém associar a trilha a um jogador real.
-- ---------------------------------------------------------------------
CREATE TABLE Rastreamento (
  id_rastreamento   INT PRIMARY KEY AUTO_INCREMENT,
  id_sessao         INT NOT NULL,
  id_track          INT NOT NULL,                          -- id vindo do rastreador
  id_jogador        INT NULL,                              -- NULL = trilha ainda não identificada
  saltos            INT DEFAULT 0,
  arremessos        INT DEFAULT 0,
  distancia_corrida DECIMAL(8,2) DEFAULT 0,                -- em metros
  FOREIGN KEY (id_sessao)  REFERENCES Sessao(id_sessao),
  FOREIGN KEY (id_jogador) REFERENCES Jogador(id_jogador),
  UNIQUE (id_sessao, id_track),
  INDEX idx_rastreamento_jogador (id_jogador)
) ENGINE=InnoDB;

-- ---------------------------------------------------------------------
-- Video: arquivo bruto ou anotado de uma sessão.
-- 'caminho' é relativo à pasta de sessões (C:/pointr_sessions), nunca
-- um caminho absoluto de uma máquina específica.
-- ---------------------------------------------------------------------
CREATE TABLE Video (
  id_video      INT PRIMARY KEY AUTO_INCREMENT,
  id_sessao     INT NOT NULL,
  com_anotacoes BOOLEAN NOT NULL,
  caminho       VARCHAR(255) NOT NULL,
  na_nuvem      BOOLEAN NOT NULL DEFAULT FALSE,
  FOREIGN KEY (id_sessao) REFERENCES Sessao(id_sessao),
  INDEX idx_video_sessao (id_sessao)
) ENGINE=InnoDB;
